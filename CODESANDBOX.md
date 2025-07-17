# OGA Platform - CodeSandbox Setup

## 🎮 Ownable Game Assets Platform
Transform your Xbox Live achievements into blockchain-verified NFTs on Stability Network.

## 🚀 Quick Start in CodeSandbox

1. **Upload these files:**
   - `package.json` (dependencies)
   - `server.js` (Xbox API proxy server)
   - `index.html` (complete frontend)

2. **Auto-install dependencies:**
   CodeSandbox will automatically install: express, cors, node-fetch

3. **Start the server:**
   - CodeSandbox will run `npm start` automatically
   - Server runs on port 3000 with Xbox API proxy at `/api/xbox/*`

## 🎯 Features

- **Real Xbox Live Integration** - Search and validate Xbox gamertags
- **Stability Blockchain** - Deploy smart contracts with zero gas fees
- **NFT Minting** - Transform achievements into OGA NFTs
- **Modern UI** - Responsive design with gaming aesthetics

## 🔧 Configuration

- **Xbox API Key**: Already configured (test key)
- **Blockchain**: Stability Network (testnet ready)
- **Contracts**: 
  - Gamer Profiles: `0x8719a45fDD1B7F419681ff85fBf0Ec2f8359d9B7`
  - Trophy NFT: `0x89AF63607260854c95156ED48f3416e33DD5AB11`

## 📡 API Endpoints

- `GET /` - Main application
- `GET /api/xbox/search/{gamertag}` - Xbox user search
- `GET /api/xbox/account/{xuid}` - Xbox profile details
- `GET /api/xbox/presence/{xuid}` - Xbox online status
- `GET /api/xbox/achievements/player/{xuid}` - Xbox achievements

## 🎮 Testing

Use these test gamertags:
- `MockGamer123`
- `TestUser001`
- `xTACTICSx`

## 🌐 Live Demo

Once deployed in CodeSandbox, your app will be available at the provided URL. 