// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin/utils/introspection/IERC165.sol";
import "openzeppelin/token/ERC721/IERC721.sol";
import "openzeppelin/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin/token/ERC721/extensions/IERC721Enumerable.sol";
import "openzeppelin/token/ERC721/extensions/IERC721Metadata.sol";
import "openzeppelin/utils/Counters.sol";
import "openzeppelin/utils/Strings.sol";
import "openzeppelin/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage, ERC721Enumerable {
    using Strings for uint256;

    mapping(uint256 => uint256) public tokenIdToLevels;

    constructor() ERC721("ChainBattles", "CBTLS") {}

    function mint() public {
        uint256 newItemId = totalSupply();
        _safeMint(msg.sender, newItemId);
        tokenIdToLevels[newItemId] = 0;
        _setTokenURI(newItemId, generateTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(ownerOf(tokenId) == msg.sender, "Must own token to train it");
        tokenIdToLevels[tokenId]++;
        _setTokenURI(tokenId, generateTokenURI(tokenId));
    }

    function getLevel(uint256 tokenId) public view returns (string memory) {
        uint256 level = tokenIdToLevels[tokenId];
        return level.toString();
    }

    function generateCharacter(uint256 tokenId) public view returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            getLevel(tokenId),
            "</text>",
            "</svg>"
        );
        return string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(svg)));
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721URIStorage, ERC721Enumerable)
        returns (bool)
    {
        return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Enumerable).interfaceId
            || interfaceId == type(IERC721Metadata).interfaceId || interfaceId == bytes4(0x49064906) // ERC721URIStorage
            || interfaceId == type(IERC165).interfaceId;
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        virtual
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal virtual override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function generateTokenURI(uint256 tokenId) internal view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(dataURI)));
    }
}
