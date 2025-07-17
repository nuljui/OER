# OGA Platform - CodeSandbox Setup

🎮 **Xbox Live + Blockchain NFT Platform** with **NO CORS Issues!**

## Quick Setup in CodeSandbox

### Option 1: Import from GitHub
1. Go to [codesandbox.io](https://codesandbox.io)
2. Click "Import from GitHub"
3. Paste your repository URL
4. Choose **Node.js** template (not Static)
5. CodeSandbox will automatically run `npm start`

### Option 2: Manual Upload
1. Create new **Node.js** sandbox
2. Upload these files:
   - `server.js`
   - `index.html` 
   - `package.json`
   - All Solidity contracts (`.sol`)
3. CodeSandbox will auto-install dependencies

## How It Works

### No CORS Issues! 🎉
- **Frontend**: Your HTML served from CodeSandbox domain
- **Proxy**: Xbox API calls go through `/api/xbox/*` endpoints  
- **Same Origin**: No browser CORS blocking!

### Architecture
```
Browser → CodeSandbox Domain → Your Server → Xbox API
  ✅ Same origin        ✅ Server-to-server (no CORS)
```

## Real Xbox API Calls

Try any real Xbox gamertag:
- Your own Xbox gamertag
- `MajorNelson` (Microsoft's Xbox team lead)
- `Chief123` (demo account)

All will pull **live data** from Xbox Live API!

## Features That Work
✅ **Real Xbox profiles** - Live gamerscore, achievements, etc.  
✅ **Blockchain integration** - Stability Network smart contracts  
✅ **NFT minting** - Turn Xbox achievements into blockchain trophies  
✅ **No setup required** - Works immediately for all users  

## Development
- **Local**: `npm start` → http://localhost:3000
- **CodeSandbox**: Automatically runs on save
- **Live sharing**: Send CodeSandbox URL to anyone

## Files Structure
```
/
├── server.js          # Node.js server + Xbox API proxy
├── index.html         # Frontend application  
├── package.json       # Dependencies
├── GamerProfiles.sol  # Smart contract
└── TrophyNFT.sol      # NFT contract
```

🚀 **Perfect for demos, sharing, and development!** 