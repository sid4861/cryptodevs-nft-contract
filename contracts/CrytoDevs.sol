//SPDX-License-Identifer: MIT

pragma solidity ^0.8.4;

import "./IWhitelist.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CryptoDevs is ERC721, Ownable {
    string _baseTokenURI;
    uint256 public _price = 0.01 ether;
    bool public _paused;
    uint256 public maxTokenIds = 20;
    uint256 public tokenIds;

    IWhitelist whitelist;

    bool public presaleStarted;

    uint256 public presaleEnded;

    modifier onlyWhenNotPaused() {
        require(!_paused, "Contract currently paused");
        _;
    }

    constructor(string memory baseURI, address whitelistContract)
        ERC721("Crypto devs", "CD")
    {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    function startPresale() public onlyOwner {
        presaleStarted = true;
        presaleEnded = block.timestamp + 5 minutes;
    }

    function presaleMint() public payable onlyWhenNotPaused {
        require(
            presaleStarted && block.timestamp < presaleEnded,
            "presale in not running"
        );
        require(tokenIds < maxTokenIds, "exceeded maximum number of tokens");
        require(msg.value >= _price, "not enough ether");
        require(
            whitelist.isAddressWhitelisted(msg.sender),
            "you are not whitelisted"
        );

        tokenIds += 1;
        _mint(msg.sender, tokenIds);
    }

    function mint() public payable onlyWhenNotPaused {
        require(
            presaleStarted && block.timestamp > presaleEnded,
            "presale is still running"
        );
        require(tokenIds < maxTokenIds, "exceeded maximum number of tokens");
        require(msg.value >= _price, "not enough ether");

        tokenIds += 1;
        _mint(msg.sender, tokenIds);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 balance = address(this).balance;
        (bool sent, ) = _owner.call{value: balance}("");    
        require(sent, "failed to withdraw");
    }

    receive() external payable {}
    fallback() external payable {}
}


// 0x1f17Affaee0118B6c3c63c78316790cCa5b52ffa