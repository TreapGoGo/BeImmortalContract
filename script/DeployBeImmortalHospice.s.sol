// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BeImmortalHospice} from "../src/BeImmortalHospice.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployBeImmortalContract is Script {
    function run() external {
        // Load configuration based on chainId
        HelperConfig helperConfig = new HelperConfig();
        (address deployer, uint256 privateKey) = helperConfig
            .getDeployerConfig();

        vm.startBroadcast(privateKey);

        // Deploy the BeImmortalHospice contract
        BeImmortalHospice hospice = new BeImmortalHospice();

        console.log("BeImmortalHospice deployed at:", address(hospice));

        vm.stopBroadcast();
    }
}
