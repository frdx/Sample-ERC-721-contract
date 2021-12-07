// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



//
//
//
//      .d88888b                                dP                           
//      88.    "'                               88                           
//      `Y88888b. .d8888b. 88d8b.d8b.  88d888b. 88 .d8888b.                  
//            `8b 88'  `88 88'`88'`88  88'  `88 88 88ooood8                  
//      d8'   .8P 88.  .88 88  88  88  88.  .88 88 88.  ...                  
//       Y88888P  `88888P8 dP  dP  dP  88Y888P' dP `88888P'                  
//                                     88
//                                     88

//       88888888b  888888ba   a88888b.dP        d88888P d8888b. d88         
//       88         88    `8b d8'   `88              d8'     `88  88         
//      a88aaaa    a88aaaa8P' 88                    d8'  .aaadP'  88         
//       88         88   `8b. 88        88888888   d8'   88'      88         
//      88         88     88 Y8.   .88           d8'    88.      88         
//      88888888P  dP     dP  Y88888P'          d8'     Y88888P d88P        
//      
//       a88888b.                     dP                                dP   
//      d8'   `88                     88                                88   
//      88        .d8888b. 88d888b. d8888P 88d888b. .d8888b. .d8888b. d8888P 
//      88        88'  `88 88'  `88   88   88'  `88 88'  `88 88'  `""   88   
//      Y8.   .88 88.  .88 88    88   88   88       88.  .88 88.  ...   88   
//      Y88888P' `88888P' dP    dP   dP   dP       `88888P8 `88888P'   dP   
//      ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
//
//
//

contract ERC721Contract is ERC721Enumerable, ERC721Burnable, ReentrancyGuard, Ownable {

    using SafeMath for uint256;
    using Strings for uint256;

    event baseURIUpdated(string newBaseURL);

    constructor() ERC721("Name", "SYMBOL") {}

    bool public mintActive = false;
    uint256 public lastMintedId;
    uint256 public constant maxSupply = 100;
    uint256 public constant mintPrice = 0.35 ether;
    
    bool public baseURILocked = false;
    string public baseURI;

    // metadata
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return string(abi.encodePacked(baseURI, Strings.toString(tokenId)));
    }

    // metadata update
    function setBaseURI(string memory _url) public onlyOwner {
        require(!baseURILocked, "Metadata on IPFS are locked.");
        emit baseURIUpdated(_url);
        baseURI = _url;
    }

    // metadata lock
    function setBaseLocked() public onlyOwner returns (bool) {
        baseURILocked = true;
        return baseURILocked;
    }

    // mint on/off button
    function mintState() public onlyOwner returns(bool) {
        mintActive = !mintActive;
        return mintActive;
    }

    function mint() public payable nonReentrant {
        require(mintActive, "Minting is not currently active.");
        require(
            lastMintedId < maxSupply,
            "Minting has ended."
        );
        require(mintPrice == msg.value, "Must use correct amount of ETH.");
        _mint();
    }

    function _mint() private {
        require(lastMintedId < maxSupply, "All minted already.");
        uint256 newTokenId = lastMintedId + 1;
        lastMintedId = newTokenId;
        _safeMint(msg.sender, newTokenId);
    }

    function reserveMint() public onlyOwner {
        _mint();
    }

    function withdraw() public onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}