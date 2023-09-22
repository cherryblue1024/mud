// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { WorldContextProvider } from "../../WorldContext.sol";
import { ROOT_NAMESPACE, ROOT_NAMESPACE_ID } from "../../constants.sol";
import { Module } from "../../Module.sol";

import { IBaseWorld } from "../../interfaces/IBaseWorld.sol";

import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { ResourceIds } from "@latticexyz/store/src/codegen/tables/ResourceIds.sol";
import { ResourceId, WorldResourceIdLib, WorldResourceIdInstance } from "../../WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "../../worldResourceTypes.sol";

import { NamespaceOwner } from "../../tables/NamespaceOwner.sol";
import { ResourceAccess } from "../../tables/ResourceAccess.sol";
import { InstalledModules } from "../../tables/InstalledModules.sol";
import { Delegations } from "../../tables/Delegations.sol";

import { CoreSystem } from "./CoreSystem.sol";
import { CORE_MODULE_NAME, CORE_SYSTEM_ID } from "./constants.sol";

import { Systems } from "./tables/Systems.sol";
import { FunctionSelectors } from "./tables/FunctionSelectors.sol";
import { SystemHooks } from "./tables/SystemHooks.sol";
import { SystemRegistry } from "./tables/SystemRegistry.sol";
import { Balances } from "./tables/Balances.sol";

import { AccessManagementSystem } from "./implementations/AccessManagementSystem.sol";
import { BalanceTransferSystem } from "./implementations/BalanceTransferSystem.sol";
import { CallBatchSystem } from "./implementations/CallBatchSystem.sol";
import { ModuleInstallationSystem } from "./implementations/ModuleInstallationSystem.sol";
import { StoreRegistrationSystem } from "./implementations/StoreRegistrationSystem.sol";
import { WorldRegistrationSystem } from "./implementations/WorldRegistrationSystem.sol";

/**
 * The CoreModule registers internal World tables, the CoreSystem, and its function selectors.

 * Note:
 * This module only supports `installRoot` (via `World.registerRootSystem`),
 * because it needs to install root tables, systems and function selectors.
 */
contract CoreModule is Module {
  // Since the CoreSystem only exists once per World and writes to
  // known tables, we can deploy it once and register it in multiple Worlds.
  address immutable coreSystem = address(new CoreSystem());

  function getName() public pure returns (bytes16) {
    return CORE_MODULE_NAME;
  }

  function installRoot(bytes memory) public override {
    _registerCoreTables();
    _registerCoreSystem();
    _registerFunctionSelectors();
  }

  function install(bytes memory) public pure {
    revert NonRootInstallNotSupported();
  }

  /**
   * Register core tables in the World
   */
  function _registerCoreTables() internal {
    StoreCore.registerCoreTables();
    NamespaceOwner.register();
    Balances.register();
    InstalledModules.register();
    Delegations.register();
    ResourceAccess.register();
    Systems.register();
    FunctionSelectors.register();
    SystemHooks.register();
    SystemRegistry.register();

    ResourceIds._setExists(ResourceId.unwrap(ROOT_NAMESPACE_ID), true);
    NamespaceOwner._set(ResourceId.unwrap(ROOT_NAMESPACE_ID), _msgSender());
    ResourceAccess._set(ResourceId.unwrap(ROOT_NAMESPACE_ID), _msgSender(), true);
  }

  /**
   * Register the CoreSystem in the World
   */
  function _registerCoreSystem() internal {
    // Use the CoreSystem's `registerSystem` implementation to register itself on the World.
    WorldContextProvider.delegatecallWithContextOrRevert({
      msgSender: _msgSender(),
      msgValue: 0,
      target: coreSystem,
      callData: abi.encodeCall(WorldRegistrationSystem.registerSystem, (CORE_SYSTEM_ID, CoreSystem(coreSystem), true))
    });
  }

  /**
   * Register function selectors for all CoreSystem functions in the World
   */
  function _registerFunctionSelectors() internal {
    bytes4[17] memory functionSelectors = [
      // --- AccessManagementSystem ---
      AccessManagementSystem.grantAccess.selector,
      AccessManagementSystem.revokeAccess.selector,
      AccessManagementSystem.transferOwnership.selector,
      // --- BalanceTransferSystem ---
      BalanceTransferSystem.transferBalanceToNamespace.selector,
      BalanceTransferSystem.transferBalanceToAddress.selector,
      // --- CallBatchSystem ---
      CallBatchSystem.callBatch.selector,
      // --- ModuleInstallationSystem ---
      ModuleInstallationSystem.installModule.selector,
      // --- StoreRegistrationSystem ---
      StoreRegistrationSystem.registerTable.selector,
      StoreRegistrationSystem.registerStoreHook.selector,
      StoreRegistrationSystem.unregisterStoreHook.selector,
      // --- WorldRegistrationSystem ---
      WorldRegistrationSystem.registerNamespace.selector,
      WorldRegistrationSystem.registerSystemHook.selector,
      WorldRegistrationSystem.unregisterSystemHook.selector,
      WorldRegistrationSystem.registerSystem.selector,
      WorldRegistrationSystem.registerFunctionSelector.selector,
      WorldRegistrationSystem.registerRootFunctionSelector.selector,
      WorldRegistrationSystem.registerDelegation.selector
    ];

    for (uint256 i = 0; i < functionSelectors.length; i++) {
      // Use the CoreSystem's `registerRootFunctionSelector` to register the
      // root function selectors in the World.
      WorldContextProvider.delegatecallWithContextOrRevert({
        msgSender: _msgSender(),
        msgValue: 0,
        target: coreSystem,
        callData: abi.encodeCall(
          WorldRegistrationSystem.registerRootFunctionSelector,
          (CORE_SYSTEM_ID, functionSelectors[i], functionSelectors[i])
        )
      });
    }
  }
}
