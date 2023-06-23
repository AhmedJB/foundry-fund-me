// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

// https://youtu.be/sas02qSFZ74?t=7606
contract InteractionsTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");

    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GasPrice = 1;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        console.log("User is %s", USER);
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        console.log("Interaction address : %s", address(this));
        console.log("Test caller : %s", msg.sender);
        FundFundMe fundFundMe = new FundFundMe();
        //vm.prank(USER);
        fundFundMe.fundFundMe(payable(fundMe));
        address funder = fundMe.getFunder(0);
        assertEq(msg.sender, funder);
    }

    function testUserCanWithdrawInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();

        fundFundMe.fundFundMe(payable(fundMe));
        uint afterFund = msg.sender.balance;
        uint fundMeBalance = address(fundMe).balance;
        withdrawFundMe.withdrawFundme(payable(fundMe));
        uint afterWithdrawBalance = msg.sender.balance;
        assertEq(address(fundMe).balance, 0);
        assertEq(afterWithdrawBalance, afterFund + fundMeBalance);
    }
}
