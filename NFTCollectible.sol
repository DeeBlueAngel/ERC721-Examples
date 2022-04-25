//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NFTCollectible is ERC721Enumerable, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    
    Counters.Counter private _tokenIds;

    uint public constant MAX_SUPPLY = 100; //Max nfts that can be minted
    uint public constant PRICE = 0.01 ether; //price to buy 1 nft recalib for matic eth=10^18 
	
    uint public constant MAX_PER_MINT = 5; //max mints per txn
    
    string public baseTokenURI; //ipfs url of folder with JSON meta

    constructor(string memory baseURI) ERC721("NFT Collectible Collection", "BlueNFT") {
     setBaseURI(baseURI);
}

    function reserveNFTs() public onlyOwner{
        uint totalMinted = _tokenIds.current();

        require(
            totalMinted.add(10) < MAX_SUPPLY, "No NFTs Left"
        );

        for(uint i=0;i<10;i++){
            _mintSingleNFT();
        }
    }

    function _baseURI() internal 
                    view 
                    virtual 
                    override 
                    returns (string memory) {
     return baseTokenURI;
}
    
function setBaseURI(string memory _baseTokenURI) public onlyOwner {
     baseTokenURI = _baseTokenURI;
}  

function mintNFTs(uint _count) public payable {
    //Check there is enough supply to mint 
    uint totalMinted = _tokenIds.current();
     require(
       totalMinted.add(_count) <= MAX_SUPPLY, "Not enough NFT Supply!"
     );
    //mint >0 and less than max txn limit
     require(
       _count > 0 && _count <= MAX_PER_MINT, 
       "Cannot mint NFTs as Max allowed limit reached."
     );
    //enough ether to mint requested nfts 
    require(
       msg.value >= PRICE.mul(_count), 
       "Not enough ether to purchase NFTs."
     );

//Mint the NFT 
 for (uint i = 0; i < _count; i++) {
            _mintSingleNFT();
     }

}

//Mint a single NFT and increment the counter
    function _mintSingleNFT() private {
        uint newTokenID = _tokenIds.current();
        _safeMint(msg.sender, newTokenID);
        _tokenIds.increment();
    }

//Returns a list of NFTs for a given account owner
function tokensOfOwner(address _owner) external view returns(uint[] memory){
     uint tokenCount = balanceOf(_owner);
     uint[] memory tokensId = new uint256[](tokenCount);
     for (uint i = 0; i < tokenCount; i++) {
          tokensId[i] = tokenOfOwnerByIndex(_owner, i);
     }
     
     return tokensId;
}

//Withdraw the balance -> ether
function withdraw() public payable onlyOwner {
     uint balance = address(this).balance;
     require(balance > 0, "Zero Balance");
     (bool success, ) = (msg.sender).call{value: balance}("");
     require(success, "Transfer failed.");
}

}
