// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable{

    string public tokenURI;
    bool public isPreSaleStarted;
    uint256 public preSaleEndedAt;
    uint256 public price = 0.01 ether;
    uint256 public tokenId;
    uint256 public maxTokenId = 20;
    bool public isPaused;
    IWhitelist whitelist;

    modifier onlyWhenNotPaused {
        require(!isPaused, "Contract currently paused");
        _;
    }

    constructor (address _whitelist, string memory _baseURI) ERC721("Rushi's Crypto Devs", "RCD"){
        whitelist = IWhitelist(_whitelist);
        tokenURI = _baseURI;
    }

    function startPreSale() public{
        isPreSaleStarted = true;
        preSaleEndedAt = block.timestamp + 5 minutes;
    } 

    function preSaleMint() public payable onlyWhenNotPaused{
        require(isPreSaleStarted && block.timestamp < preSaleEndedAt, "Presale is not running");
        require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted");
        require(tokenId < maxTokenId, "Exceeded maximum Crypto Devs supply");
        require(msg.value >= price, "Ether sent is not correct");
        
        tokenId += 1;
        _safeMint(msg.sender, tokenId);
    }

    function mint() public payable onlyWhenNotPaused{
        require(isPreSaleStarted && block.timestamp < preSaleEndedAt, "Presale is not running");
        require(tokenId < maxTokenId, "Exceeded maximum Crypto Devs supply");
        require(msg.value >= price, "Ether sent is not correct");
        
        tokenId += 1;
        _safeMint(msg.sender, tokenId);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return tokenURI;
    }

    function setPaused(bool val) public onlyOwner {
        isPaused = val;
    }

    function withdraw() public onlyOwner  {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) =  _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    receive() external payable {}

    fallback() external payable {}

}