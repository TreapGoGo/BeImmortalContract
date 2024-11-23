// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BeImmortalHospice {
    struct Legacy {
        string ownerName; // 逝者姓名
        address ownerAddress; // 逝者钱包地址
        uint256 birthDate; // 出生日期
        string lastWords; // 遗言内容
        address witnessAddress; // 见证者钱包地址
        bool isPassedAway; // 是否确认死亡
        string[] comments; // 评论区
    }

    mapping(address => Legacy) public legacies;

    // Custom Errors
    error Unauthorized();
    error LegacyAlreadyExists();
    error LegacyNotFound();
    error InvalidAddress();

    // Events
    event LegacyCreated(address indexed ownerAddress, string ownerName);
    event LegacyUpdated(address indexed ownerAddress, string newLastWords);
    event CommentAdded(address indexed ownerAddress, string comment);
    event DeathConfirmed(address indexed ownerAddress);

    // Modifiers
    modifier onlyOwnerOrWitness(address ownerAddress) {
        if (
            msg.sender != ownerAddress &&
            msg.sender != legacies[ownerAddress].witnessAddress
        ) {
            revert Unauthorized();
        }
        _;
    }

    modifier onlyOwner(address ownerAddress) {
        if (msg.sender != ownerAddress) {
            revert Unauthorized();
        }
        _;
    }

    modifier legacyExists(address ownerAddress) {
        if (legacies[ownerAddress].ownerAddress == address(0)) {
            revert LegacyNotFound();
        }
        _;
    }

    // Functions
    function createLegacy(
        string memory ownerName,
        address ownerAddress,
        uint256 birthDate,
        string memory lastWords,
        address witnessAddress
    ) external {
        if (legacies[ownerAddress].ownerAddress != address(0)) {
            revert LegacyAlreadyExists();
        }
        if (ownerAddress == address(0)) {
            revert InvalidAddress();
        }

        legacies[ownerAddress] = Legacy({
            ownerName: ownerName,
            ownerAddress: ownerAddress,
            birthDate: birthDate,
            lastWords: lastWords,
            witnessAddress: witnessAddress,
            isPassedAway: false,
            comments: new string[](0)
        });

        emit LegacyCreated(ownerAddress, ownerName);
    }

    function updateLegacy(
        address ownerAddress,
        string memory newLastWords
    ) external legacyExists(ownerAddress) onlyOwnerOrWitness(ownerAddress) {
        legacies[ownerAddress].lastWords = newLastWords;
        emit LegacyUpdated(ownerAddress, newLastWords);
    }

    function deleteLegacy()
        external
        onlyOwner(msg.sender) // 先检查权限
        legacyExists(msg.sender) // 再检查是否存在记录
    {
        delete legacies[msg.sender];
    }

    function addComment(
        address ownerAddress,
        string memory comment
    ) external legacyExists(ownerAddress) {
        legacies[ownerAddress].comments.push(comment);
        emit CommentAdded(ownerAddress, comment);
    }

    function confirmDeath(
        address ownerAddress
    ) external legacyExists(ownerAddress) {
        if (msg.sender != legacies[ownerAddress].witnessAddress) {
            revert Unauthorized();
        }
        legacies[ownerAddress].isPassedAway = true;
        emit DeathConfirmed(ownerAddress);
    }

    function getLegacy(
        address ownerAddress
    )
        external
        view
        legacyExists(ownerAddress)
        returns (
            string memory,
            address,
            uint256,
            string memory,
            address,
            bool,
            string[] memory
        )
    {
        Legacy storage lg = legacies[ownerAddress];
        return (
            lg.ownerName,
            lg.ownerAddress,
            lg.birthDate,
            lg.lastWords,
            lg.witnessAddress,
            lg.isPassedAway,
            lg.comments
        );
    }

    function getOwnerName(
        address ownerAddress
    ) external view legacyExists(ownerAddress) returns (string memory) {
        return legacies[ownerAddress].ownerName;
    }

    function getOwnerAddress(
        address ownerAddress
    ) external view legacyExists(ownerAddress) returns (address) {
        return legacies[ownerAddress].ownerAddress;
    }

    function getBirthDate(
        address ownerAddress
    ) external view legacyExists(ownerAddress) returns (uint256) {
        return legacies[ownerAddress].birthDate;
    }

    function getLastWords(
        address ownerAddress
    ) external view legacyExists(ownerAddress) returns (string memory) {
        return legacies[ownerAddress].lastWords;
    }

    function getWitnessAddress(
        address ownerAddress
    ) external view legacyExists(ownerAddress) returns (address) {
        return legacies[ownerAddress].witnessAddress;
    }

    function isPassedAway(
        address ownerAddress
    ) external view legacyExists(ownerAddress) returns (bool) {
        return legacies[ownerAddress].isPassedAway;
    }

    function getComments(
        address ownerAddress
    ) external view legacyExists(ownerAddress) returns (string[] memory) {
        return legacies[ownerAddress].comments;
    }

    function getLifeStatus(
        address ownerAddress
    ) external view legacyExists(ownerAddress) returns (bool) {
        return legacies[ownerAddress].isPassedAway;
    }
}
