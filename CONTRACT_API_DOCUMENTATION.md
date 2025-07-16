# GameTrophyPlatform Contract API Documentation

**Contract Address:** `0xddd15cFe442b81fEf0662BD566C8b033BcCBB3c5`  
**Network:** Stability Blockchain  

## 📋 Overview

The GameTrophyPlatform is a unified smart contract that combines gamer profile management with trophy NFT functionality. Users can register gaming profiles (PlayStation/Xbox) and mint/collect trophy NFTs linked to their achievements.

---

## 🔧 Write Functions (State-Changing)

### 🎮 Gamer Profile Functions

#### `register(string _psId, string _xboxId, string _data) → uint256 userId`
**Purpose:** Register a new gamer profile  
**Parameters:**
- `_psId` - PlayStation Network ID
- `_xboxId` - Xbox Gamertag  
- `_data` - Custom JSON metadata
**Returns:** `userId` - Unique user ID assigned
**Requirements:** Address must not already be registered
**Gas:** ~200,000

#### `updateProfile(string _psId, string _xboxId, string _data)`
**Purpose:** Update existing gamer profile  
**Parameters:** Same as register
**Requirements:** Must be already registered
**Gas:** ~100,000

#### `addFriend(uint256 friendId)`
**Purpose:** Add another user as a friend  
**Parameters:**
- `friendId` - User ID of the friend to add
**Requirements:** Both users must exist
**Gas:** ~50,000

### 🏆 Trophy NFT Functions

#### `mintTrophy(address to, uint256 userId, string psContext, string extra) → uint256 tokenId`
**Purpose:** Mint a new trophy NFT  
**Parameters:**
- `to` - Address to receive the trophy
- `userId` - User ID the trophy is linked to
- `psContext` - PlayStation game/trophy context
- `extra` - Additional metadata
**Returns:** `tokenId` - Unique token ID of minted trophy
**Requirements:** User must exist
**Gas:** ~150,000

#### `approve(address to, uint256 tokenId)`
**Purpose:** Approve another address to transfer a specific NFT  
**Parameters:**
- `to` - Address to approve
- `tokenId` - Token to approve
**Requirements:** Must own token or be approved operator
**Gas:** ~50,000

#### `setApprovalForAll(address operator, bool approved)`
**Purpose:** Approve/revoke operator for all your NFTs  
**Parameters:**
- `operator` - Address to set as operator
- `approved` - True to approve, false to revoke
**Gas:** ~50,000

#### `transferFrom(address from, address to, uint256 tokenId)`
**Purpose:** Transfer an NFT  
**Parameters:**
- `from` - Current owner address
- `to` - Recipient address
- `tokenId` - Token to transfer
**Requirements:** Must be owner or approved
**Gas:** ~80,000

#### `safeTransferFrom(address from, address to, uint256 tokenId)`
**Purpose:** Safe transfer an NFT (checks if recipient can handle NFTs)  
**Parameters:** Same as transferFrom
**Gas:** ~100,000

#### `safeTransferFrom(address from, address to, uint256 tokenId, bytes data)`
**Purpose:** Safe transfer with custom data  
**Parameters:** Same as above plus custom data
**Gas:** ~120,000

---

## 📖 Read Functions (View Only)

### 🎮 Gamer Profile Views

#### `nextUserId() → uint256`
**Purpose:** Get the next user ID that will be assigned
**Returns:** Next available user ID

#### `addrToUserId(address) → uint256`
**Purpose:** Get user ID by wallet address
**Parameters:** Wallet address
**Returns:** User ID (0 if not registered)

#### `users(uint256) → Gamer struct`
**Purpose:** Get complete user profile by ID
**Parameters:** User ID
**Returns:** Gamer struct with all profile data

#### `friends(uint256, uint256) → uint256`
**Purpose:** Get friend ID by user ID and index
**Parameters:** User ID, friend array index
**Returns:** Friend's user ID

#### `getProfileByAddress(address) → Gamer struct`
**Purpose:** Get complete profile by wallet address
**Parameters:** Wallet address
**Returns:** Complete Gamer profile

#### `listFriends(uint256) → uint256[]`
**Purpose:** Get all friends of a user
**Parameters:** User ID
**Returns:** Array of friend user IDs

#### `getUserIdByAddress(address) → uint256`
**Purpose:** Helper to get user ID from address
**Parameters:** Wallet address
**Returns:** User ID

### 🏆 Trophy NFT Views

#### `name() → string`
**Purpose:** Get NFT collection name
**Returns:** "Stability Trophy"

#### `symbol() → string`
**Purpose:** Get NFT collection symbol
**Returns:** "TROPHY"

#### `nextTokenId() → uint256`
**Purpose:** Get the next token ID that will be minted
**Returns:** Next available token ID

#### `totalSupply() → uint256`
**Purpose:** Get total number of trophies minted
**Returns:** Total supply count

#### `balanceOf(address) → uint256`
**Purpose:** Get number of trophies owned by address
**Parameters:** Owner address
**Returns:** Number of trophies owned

#### `ownerOf(uint256) → address`
**Purpose:** Get owner of specific trophy
**Parameters:** Token ID
**Returns:** Owner address

#### `getApproved(uint256) → address`
**Purpose:** Get approved address for a token
**Parameters:** Token ID
**Returns:** Approved address (0x0 if none)

#### `isApprovedForAll(address, address) → bool`
**Purpose:** Check if operator is approved for all tokens
**Parameters:** Owner address, operator address
**Returns:** True if approved

#### `trophyInfo(uint256) → TrophyData struct`
**Purpose:** Get trophy metadata by token ID
**Parameters:** Token ID
**Returns:** TrophyData struct

#### `getTrophyDetails(uint256) → TrophyData struct`
**Purpose:** Same as trophyInfo but with existence check
**Parameters:** Token ID
**Returns:** TrophyData struct

#### `trophiesOf(address) → uint256[]`
**Purpose:** Get all trophy token IDs owned by address
**Parameters:** Owner address
**Returns:** Array of token IDs

#### `supportsInterface(bytes4) → bool`
**Purpose:** Check if contract supports specific interface
**Parameters:** Interface ID
**Returns:** True if supported

---

## 📊 Data Structures

### Gamer Struct
```solidity
struct Gamer {
    uint256 id;          // Unique user ID
    string psId;         // PlayStation Network ID
    string xboxId;       // Xbox Gamertag
    string data;         // Custom JSON metadata
    address account;     // Wallet address
    uint256 createdAt;   // Registration timestamp
    uint256 updatedAt;   // Last update timestamp
}
```

### TrophyData Struct
```solidity
struct TrophyData {
    uint256 linkedUserId;  // User ID trophy belongs to
    string psContext;      // PlayStation game context
    string extra;          // Additional metadata
    uint256 createdAt;     // Mint timestamp
}
```

---

## 🎯 Events

### Profile Events
- `Registered(uint256 indexed userId, address indexed account)`
- `ProfileUpdated(uint256 indexed userId)`
- `FriendAdded(uint256 indexed userId, uint256 indexed friendId)`

### NFT Events (ERC721 Standard)
- `Transfer(address indexed from, address indexed to, uint256 indexed tokenId)`
- `Approval(address indexed owner, address indexed approved, uint256 indexed tokenId)`
- `ApprovalForAll(address indexed owner, address indexed operator, bool approved)`

### Trophy Events
- `TrophyMinted(uint256 indexed tokenId, uint256 indexed userId, address indexed to)`

---

## 🔒 Access Control

- **Public Functions:** All read functions, register, updateProfile, addFriend, mintTrophy
- **Owner-Only Functions:** None (fully decentralized)
- **Token-Gated Functions:** NFT transfer functions require ownership or approval

---

## 💡 Usage Examples

### Register and Get Profile
```javascript
// Register
const tx1 = await contract.register("MyPSN_ID", "MyXboxTag", '{"level": 50}');
const userId = tx1.events.Registered.returnValues.userId;

// Get profile
const profile = await contract.getProfileByAddress(userAddress);
```

### Mint and Transfer Trophy
```javascript
// Mint trophy
const tx2 = await contract.mintTrophy(userAddress, userId, "God of War", '{"platinum": true}');
const tokenId = tx2.events.TrophyMinted.returnValues.tokenId;

// Check ownership
const trophies = await contract.trophiesOf(userAddress);
```

### Social Features
```javascript
// Add friend
await contract.addFriend(friendUserId);

// Get friends list
const friends = await contract.listFriends(userId);
``` 