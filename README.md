# OER Proof of Concept

This repository contains a clean, minimalist prototype for **One Earth Rising** (OER). It demonstrates how Xbox gamer profiles and achievements can be linked to blockchain assets.

## Core Components

| File | Purpose |
|------|---------|
| `GamerProfiles.sol` | Smart contract for registering Xbox profiles and managing gamer data |
| `TrophyNFT.sol` | ERC-721 NFT contract for minting achievement trophies |
| `index.html` | Complete web interface for registration, login, and profile management |
| `server.js` | Express server providing Xbox API proxy functionality |
| `package.json` | Node.js dependencies for the server |

## Quick Start

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Start the server:**
   ```bash
   npm start
   ```

3. **Open your browser:**
   Navigate to `http://localhost:3000` to explore the interface

## Architecture

- **Frontend**: Single-page HTML application with embedded CSS/JavaScript
- **Backend**: Minimal Express server for Xbox Live API proxying
- **Blockchain**: Solidity contracts deployed on Stability Network
- **Data**: Xbox Live integration via OpenXBL API

## Documentation

Additional documentation, test results, and development notes are available in the `Archive/` folder for reference.

## License

This project is released under the MIT License.

