// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract ImageNFT is ERC721URIStorage {
    enum Status {
        OffBid, OnBid, WaittingClaim
    }

    struct Image {
        uint256 tokenID;
        string tokenName;
        string tokenURI;
        address mintedBy;
        address currentOwner;
        uint256 transferTime;
        uint256 highestBidPrice;
        Status status;
    }

    uint256 public currentImageCount;

    mapping(uint256 => Image) public imageStorage;

    mapping(uint256 => address[]) public ownerShipTrans;

    mapping(string => bool) internal tokenURIExists;

    constructor() ERC721("Image Collection", "NFT") {
        currentImageCount = 0;
    }

    function mint(
        address to,
        string memory _name,
        string memory _tokenURI
    ) internal returns (uint256) {
        currentImageCount++;
        require(!_exists(currentImageCount), "ImageID repeated.");
        require(!tokenURIExists[_tokenURI], "Token URI repeated.");

        _safeMint(to, currentImageCount);
        _setTokenURI(currentImageCount, _tokenURI);

    //새 NFT(구조체)를 만들고 새 값을 전달합니다.
        Image memory newImage = Image(
            currentImageCount,
            _name,
            _tokenURI,
            msg.sender,
            msg.sender,
            0,
            0,
            Status.OffBid
        );

        tokenURIExists[_tokenURI] = true;
        imageStorage[currentImageCount] = newImage;

        return currentImageCount;
    }

    function getImageByIndex(uint256 index)
        internal
        view
        returns (Image memory image)
    {
        require(_exists(index), "index not exist");
        return imageStorage[index];
    }

    function updateStatus(uint256 _tokenID, Status status)
        internal
        returns (bool)
    {
        Image storage image = imageStorage[_tokenID];
        image.status = status;
        return true;
    }

    function updateOwner(uint256 _tokenID, address newOwner)
        internal
        returns (bool)
    {
        Image storage image = imageStorage[_tokenID];
        ownerShipTrans[_tokenID].push(image.currentOwner);
        image.currentOwner = newOwner;
        image.transferTime += 1;

        _transfer(ownerOf(_tokenID), newOwner, _tokenID);
        return true;
    }

    function updatePrice(uint256 _tokenID, uint256 newPrice)
        internal
        returns (bool)
    {
        Image storage image = imageStorage[_tokenID];
        if (image.highestBidPrice < newPrice) {
            image.highestBidPrice = newPrice;
            return true;
        }
        return false;
    }

    function getTokenOnwer(uint256 _tokenID) external view returns (address) {
        return ownerOf(_tokenID);
    }

    function getTokenURI(uint256 _tokenID)
        external
        view
        returns (string memory)
    {
        Image memory image = imageStorage[_tokenID];
        return image.tokenURI;
    }

    function getOwnedNumber(address owner) external view returns (uint256) {
        return balanceOf(owner);
    }
}