// SPDX‑License‑Identifier: MIT
pragma solidity ^0.8.24;

contract GamerProfiles {
    /// Auto‑incrementing primary key --------------------------------------------------------------
    uint256 public nextUserId = 1;

    /// Core profile data --------------------------------------------------------------------------
    struct Gamer {
        uint256  id;          // internal numeric id (handy for referencing)  
        string   psId;        // PlayStation Network ID  
        string   xboxId;      // Xbox Gamertag  
        string   data;        // arbitrary JSON / URI / blob  
        address  account;     // wallet that “owns” this profile (= msg.sender on registration)  
        uint256  createdAt;  
        uint256  updatedAt;  
    }

    /// Storage ------------------------------------------------------------------------------------
    mapping(address  => uint256) public  addrToUserId;   // wallet → userId  
    mapping(uint256  => Gamer)   public  users;          // userId → profile  
    mapping(uint256  => uint256[]) public friends;       // userId → array of friend userIds

    /// Events (front‑end can filter logs instead of indexing off‑chain) ---------------------------
    event Registered   (uint256 indexed userId, address indexed account);
    event ProfileUpdated(uint256 indexed userId);
    event FriendAdded  (uint256 indexed userId, uint256 indexed friendId);

    // ------------------------------------------------------------------------------------------------
    //  Public mutators
    // ------------------------------------------------------------------------------------------------
    function register(
        string calldata _psId,
        string calldata _xboxId,
        string calldata _data
    ) external returns (uint256 userId) {
        require(addrToUserId[msg.sender] == 0, "Already registered");

        userId = nextUserId++;
        users[userId] = Gamer({
            id:        userId,
            psId:      _psId,
            xboxId:    _xboxId,
            data:      _data,
            account:   msg.sender,
            createdAt: block.timestamp,
            updatedAt: block.timestamp
        });

        addrToUserId[msg.sender] = userId;
        emit Registered(userId, msg.sender);
    }

    function updateProfile(
        string calldata _psId,
        string calldata _xboxId,
        string calldata _data
    ) external {
        uint256 id = addrToUserId[msg.sender];
        require(id != 0, "Not registered");

        Gamer storage g = users[id];
        g.psId   = _psId;
        g.xboxId = _xboxId;
        g.data   = _data;
        g.updatedAt = block.timestamp;

        emit ProfileUpdated(id);
    }

    /// friendId must already exist
    function addFriend(uint256 friendId) external {
        uint256 id = addrToUserId[msg.sender];
        require(id != 0 && users[friendId].id != 0, "User(s) not found");

        friends[id].push(friendId);
        emit FriendAdded(id, friendId);
    }

    // ------------------------------------------------------------------------------------------------
    //  Pure views (all public for easy FE consumption)
    // ------------------------------------------------------------------------------------------------
    function getProfileByAddress(address a) external view returns (Gamer memory) {
        return users[addrToUserId[a]];
    }

    function listFriends(uint256 userId) external view returns (uint256[] memory) {
        return friends[userId];
    }
}