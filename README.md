# OER Proof of Concept

This repository contains a prototype for **One Earth Rising** (OER). It explores how gamer profiles and in-game achievements can be linked to blockchain assets. The project includes Solidity smart contracts, early HTML mockups and several documents describing the API and testing.

## Contents

| File/Folder | Purpose |
|-------------|---------|
| `GamerProfiles.sol` | Contract for registering PlayStation/Xbox IDs and basic social features |
| `TrophyNFT.sol` | ERC‑721 contract that mints trophies linked to gamer profiles |
| `CONTRACT_API_DOCUMENTATION.md` | Detailed reference for the contract API |
| `CONTRACT_TEST_RESULTS.md` | Log of manual tests with notes about issues |
| `XBOX_API_INSTRUCTIONS.md` | How to query Xbox Live via the OpenXBL API |
| `index.html`, `index2.html`, `index3.html` | Static UI mockups demonstrating registration and profile screens |
| `Project_overview.md` | Initial planning notes and architecture outline |

## Getting Started

The HTML files are standalone prototypes. Open `index.html` (or the alternate versions) in a browser to explore the proposed interface. No build step is required.

The Solidity contracts target `pragma solidity ^0.8.24` and rely on OpenZeppelin libraries. Use a tool such as Hardhat or Foundry if you wish to compile or test them locally.

## Notes

* `CONTRACT_TEST_RESULTS.md` describes partial functionality—profile lookups and some mappings currently do not work correctly.
* `XBOX_API_INSTRUCTIONS.md` includes an example API key for demonstration only. Replace it with your own key for real requests.

## License

This project is released under the MIT License.

