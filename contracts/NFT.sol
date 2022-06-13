// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./Counters.sol";
import "./ERC721URIStorage.sol";
import "./ERC721.sol";
import "./Ownable.sol";
import "./Strings.sol";


import "./ILaunchpadNFT.sol";
contract NFT is Ownable, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _tokenIdsGaller;

    uint256 listingPrice = 0.025 ether;

    using Strings for uint256;
    string public baseURI;
    string public suffix;

    uint256 public LAUNCH_MAX_SUPPLY;   
    uint256 public LAUNCH_SUPPLY;        

    address public LAUNCHPAD;
    modifier onlyLaunchpad() {
        require(LAUNCHPAD != address(0), "launchpad address must set");
        require(msg.sender == LAUNCHPAD, "must call by launchpad");
        _;
    }

    function getMaxLaunchpadSupply() view public returns (uint256) {
        return LAUNCH_MAX_SUPPLY;
    }

    function getLaunchpadSupply() view public returns (uint256) {
        return LAUNCH_SUPPLY;
    }
    // end
    constructor(string memory name_, string memory symbol_, string memory baseURI_, address launchpad, uint256 _maxSupply) ERC721(name_, symbol_) {

        baseURI = baseURI_;
        LAUNCHPAD = launchpad;
        LAUNCH_MAX_SUPPLY = _maxSupply;
    }

    mapping(address => uint) balance; 

    function _baseURI() internal view virtual override returns (string memory){
        return baseURI;
    }

    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    function setBaseURI(string memory _newURI) external onlyOwner {
        baseURI = _newURI;
    }


    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token.");
        return string(abi.encodePacked(baseURI, tokenId.toString(), suffix));
    }

    function mintTo(address to, uint size) external onlyLaunchpad {
        require(to != address(0), "can't mint to empty address");
        require(size > 0, "size must greater than zero");
        require(LAUNCH_SUPPLY + size <= LAUNCH_MAX_SUPPLY, "max supply reached");

        for (uint256 i=1; i <= size; i++) {
            _tokenIds.increment();
            uint256 newItemId = _tokenIds.current();
            _mint(to, newItemId);
            LAUNCH_SUPPLY++;
        }
    }

    receive() external payable { }
    fallback() external payable {}


    function createToken() external payable {
        require(msg.value >= listingPrice, "ERC721: mint to the zero address");
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        require(LAUNCH_SUPPLY <= LAUNCH_MAX_SUPPLY, "max supply reached");
        _safeMint(msg.sender, newItemId);
        LAUNCH_SUPPLY++;
    }


    function withdraw() public payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

}
