// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    struct Config {
        address deployer; // Address of the deployer
        uint256 privateKey; // Private key for deployment
    }

    function getDeployerConfig() public view returns (address, uint256) {
        uint256 chainId = block.chainid;

        if (chainId == 11155111) {
            // Sepolia network
            uint256 privateKey = vm.envUint("SEPOLIA_PRIVATE_KEY");
            address deployer = vm.addr(privateKey);
            return (deployer, privateKey);
        } else if (chainId == 31337) {
            // Anvil local network
            uint256 privateKey = vm.envUint("ANVIL_PRIVATE_KEY");
            address deployer = vm.addr(privateKey);
            return (deployer, privateKey);
        } else {
            revert("Unsupported network");
        }
    }
}
