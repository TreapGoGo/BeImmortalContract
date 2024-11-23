// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/BeImmortalHospice.sol";

contract BeImmortalHospiceTest is Test {
    BeImmortalHospice hospice;

    address owner = address(0x123);
    address witness = address(0x456);

    function setUp() public {
        hospice = new BeImmortalHospice();
    }

    function testCreateLegacy() public {
        vm.prank(owner); // 模拟调用者为 owner
        hospice.createLegacy(
            "Alexander the Great",
            owner,
            356, // 出生公元前356年，用简单年份代替
            "To the strongest!",
            witness
        );

        (
            string memory name,
            address ownerAddress,
            uint256 birthDate,
            string memory lastWords,
            address witnessAddress,
            bool isPassedAway,
            string[] memory comments
        ) = hospice.getLegacy(owner);

        assertEq(name, "Alexander the Great");
        assertEq(ownerAddress, owner);
        assertEq(birthDate, 356);
        assertEq(lastWords, "To the strongest!");
        assertEq(witnessAddress, witness);
        assertEq(isPassedAway, false);
        assertEq(comments.length, 0);
    }

    function testAddComment() public {
        vm.prank(owner);
        hospice.createLegacy(
            "Alexander the Great",
            owner,
            356,
            "To the strongest!",
            witness
        );

        vm.prank(address(0x789)); // 模拟第三方用户
        hospice.addComment(owner, "Rest in peace, great conqueror!");

        string[] memory comments = hospice.getComments(owner);
        assertEq(comments.length, 1);
        assertEq(comments[0], "Rest in peace, great conqueror!");
    }

    function testUpdateLegacy() public {
        vm.prank(owner);
        hospice.createLegacy(
            "Alexander the Great",
            owner,
            356,
            "To the strongest!",
            witness
        );

        vm.prank(owner);
        hospice.updateLegacy(owner, "Let the empire thrive forever!");

        (, , , string memory updatedLastWords, , , ) = hospice.getLegacy(owner);
        assertEq(updatedLastWords, "Let the empire thrive forever!");
    }

    function testConfirmDeath() public {
        vm.prank(owner);
        hospice.createLegacy(
            "Alexander the Great",
            owner,
            356,
            "To the strongest!",
            witness
        );

        vm.prank(witness);
        hospice.confirmDeath(owner);

        bool isPassedAway = hospice.getLifeStatus(owner);
        assertEq(isPassedAway, true);
    }

    function testOnlyOwnerCanDeleteLegacy() public {
        // Owner 创建遗言，确保 legacyExists 条件满足
        vm.prank(owner);
        hospice.createLegacy(
            "Alexander the Great",
            owner,
            356,
            "To the strongest!",
            witness
        );

        // Owner 成功删除遗言，验证正确权限
        vm.prank(owner);
        hospice.deleteLegacy();

        // 确认遗言已被删除，检查 legacyExists 触发 LegacyNotFound 错误
        vm.expectRevert(BeImmortalHospice.LegacyNotFound.selector);
        hospice.getLegacy(owner);
    }
}
