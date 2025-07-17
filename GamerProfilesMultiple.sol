// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract GamerProfilesMultiple {
    /// Auto-incrementing primary key
    uint256 public nextUserId = 1;

    /// Core profile data
    struct Gamer {
        uint256  id;          // internal numeric id
        string   psId;        // PlayStation Network ID  
        string   xboxId;      // Xbox Gamertag  
        string   data;        // arbitrary JSON / URI / blob  
        address  account;     // wallet that "owns" this profile
        uint256  createdAt;  
        uint256  updatedAt;  
    }

    /// Storage
    mapping(uint256  => Gamer)   public  users;          // userId → profile  
    mapping(string   => uint256) public  xboxIdToUserId; // xboxId → userId (for lookups)
    mapping(uint256  => uint256[]) public friends;       // userId → array of friend userIds

    /// Events
    event Registered   (uint256 indexed userId, address indexed account, string xboxId);
    event ProfileUpdated(uint256 indexed userId);
    event FriendAdded  (uint256 indexed userId, uint256 indexed friendId);

    // ------------------------------------------------------------------------------------------------
    //  Public mutators - ALLOWS MULTIPLE PROFILES PER ADDRESS
    // ------------------------------------------------------------------------------------------------
    function register(
        string calldata _psId,
        string calldata _xboxId,
        string calldata _data
    ) external returns (uint256 userId) {
        // Check if this Xbox gamertag already exists
        require(xboxIdToUserId[_xboxId] == 0, "Xbox gamertag already registered");

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

        xboxIdToUserId[_xboxId] = userId;
        emit Registered(userId, msg.sender, _xboxId);
    }

    function updateProfile(
        uint256 _userId,
        string calldata _psId,
        string calldata _xboxId,
        string calldata _data
    ) external {
        require(users[_userId].id != 0, "User does not exist");
        require(users[_userId].account == msg.sender, "Not authorized");

        Gamer storage g = users[_userId];
        g.psId   = _psId;
        g.xboxId = _xboxId;
        g.data   = _data;
        g.updatedAt = block.timestamp;

        emit ProfileUpdated(_userId);
    }

    function addFriend(uint256 userId, uint256 friendId) external {
        require(users[userId].id != 0 && users[friendId].id != 0, "User(s) not found");
        require(users[userId].account == msg.sender, "Not authorized");

        friends[userId].push(friendId);
        emit FriendAdded(userId, friendId);
    }

    // ------------------------------------------------------------------------------------------------
    //  Views
    // ------------------------------------------------------------------------------------------------
    function getProfile(uint256 userId) external view returns (Gamer memory) {
        return users[userId];
    }

    function getProfileByXboxId(string calldata xboxId) external view returns (Gamer memory) {
        uint256 userId = xboxIdToUserId[xboxId];
        require(userId != 0, "Xbox gamertag not found");
        return users[userId];
    }

    function getUserIdByXboxId(string calldata xboxId) external view returns (uint256) {
        return xboxIdToUserId[xboxId];
    }

    function listFriends(uint256 userId) external view returns (uint256[] memory) {
        return friends[userId];
    }

    function isXboxIdRegistered(string calldata xboxId) external view returns (bool) {
        return xboxIdToUserId[xboxId] != 0;
    }
} 