// SPDX‑License‑Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IGamerProfiles {
    function users(uint256) external view returns (
        uint256 id,
        string memory psId,
        string memory xboxId,
        string memory data,
        address account,
        uint256 createdAt,
        uint256 updatedAt
    );
}

contract TrophyNFT is ERC721Enumerable, Ownable {
    struct TrophyData {
        uint256  linkedUserId;   // 0 = not linked
        string   psContext;      // e.g. the PlayStation title / trophy code
        string   extra;          // JSON / URI / anything
        uint256  createdAt;
    }

    uint256 public nextTokenId = 1;

    IGamerProfiles public profiles;   // immutable address reference

    mapping(uint256 => TrophyData) public trophyInfo;   // tokenId → details

    event TrophyMinted(uint256 indexed tokenId, uint256 indexed userId, address indexed to);

    constructor(address _profiles) ERC721("Stability Trophy", "TROPHY") {
        profiles = IGamerProfiles(_profiles);
    }

    // ------------------------------------------------------------------------------------------------
    //  Minting – caller decides where it goes (totally open for testing)
    // ------------------------------------------------------------------------------------------------
    function mintTrophy(
        address to,
        uint256 userId,
        string calldata psContext,
        string calldata extra
    ) external returns (uint256 tokenId) {
        // Optional: verify the user exists – pulls the struct and checks id != 0
        (uint256 id,,,,,,) = profiles.users(userId);
        require(id != 0, "Gamer does not exist");

        tokenId = nextTokenId++;
        _safeMint(to, tokenId);

        trophyInfo[tokenId] = TrophyData({
            linkedUserId : userId,
            psContext    : psContext,
            extra        : extra,
            createdAt    : block.timestamp
        });

        emit TrophyMinted(tokenId, userId, to);
    }

    // ------------------------------------------------------------------------------------------------
    //  Convenience helpers
    // ------------------------------------------------------------------------------------------------
    function trophiesOf(address owner) external view returns (uint256[] memory) {
        uint256 count = balanceOf(owner);
        uint256[] memory list = new uint256[](count);
        for (uint256 i; i < count; ++i) {
            list[i] = tokenOfOwnerByIndex(owner, i);
        }
        return list;
    }

    // Get trophies directly by user ID (Profile ID) - much more efficient!
    function getTrophiesForUser(uint256 userId) external view returns (uint256[] memory) {
        // First pass: count how many trophies belong to this user
        uint256 totalSupply = totalSupply();
        uint256 userTrophyCount = 0;
        
        for (uint256 tokenId = 1; tokenId <= totalSupply; tokenId++) {
            if (_exists(tokenId) && trophyInfo[tokenId].linkedUserId == userId) {
                userTrophyCount++;
            }
        }
        
        // Second pass: collect the token IDs
        uint256[] memory userTrophies = new uint256[](userTrophyCount);
        uint256 index = 0;
        
        for (uint256 tokenId = 1; tokenId <= totalSupply; tokenId++) {
            if (_exists(tokenId) && trophyInfo[tokenId].linkedUserId == userId) {
                userTrophies[index] = tokenId;
                index++;
            }
        }
        
        return userTrophies;
    }

    // Get trophy details by token ID
    function getTrophyDetails(uint256 tokenId) external view returns (uint256, string memory, string memory, uint256) {
        require(_exists(tokenId), "Trophy does not exist");
        TrophyData memory trophy = trophyInfo[tokenId];
        return (trophy.linkedUserId, trophy.psContext, trophy.extra, trophy.createdAt);
    }
}