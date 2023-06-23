// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {FunWithStorage} from "../../src/StorageTest/FunWithStorage.sol";
import {DeployStorageFun} from "../../script/DeployStorageFun.s.sol";

contract FunWithStorageTest is Test {
    address USER = makeAddr("user");
    uint256 constant FundAmount = 10 ether;

    FunWithStorage funWithStorage;
    DeployStorageFun deployer;

    function setUp() external {
        vm.deal(USER, FundAmount);
        deployer = new DeployStorageFun();
        funWithStorage = deployer.run();
    }

    function test_printingStorageData() external view {
        deployer.printStorageData(address(funWithStorage));
    }
}
