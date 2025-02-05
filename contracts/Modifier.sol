// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ModifierExample
 * @dev A simple smart contract demonstrating the use of modifiers in Solidity.
 */
contract ModifierExample {
    
    // State variable to store a number
    uint256 public storedNumber;
    
    // Address of the contract owner
    address public owner;

    /**
     * @dev Sets the contract deployer as the initial owner.
     */
    constructor() {
        owner = msg.sender; // The deployer of the contract becomes the owner
    }

    /**
     * @dev Modifier to restrict access to only the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _; // This underscore represents the continuation of the function execution
    }

    /**
     * @dev Function to update the stored number, restricted to the owner.
     * @param _number The new number to store.
     */
    function updateNumber(uint256 _number) public onlyOwner {
        storedNumber = _number;
    }

    /**
     * @dev Function to change the owner, restricted to the current owner.
     * @param _newOwner The new owner's address.
     */
    function changeOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        owner = _newOwner;
    }

    /**
     * @dev Public function to get the stored number.
     * @return The stored number.
     */
    function getStoredNumber() public view returns (uint256) {
        return storedNumber;
    }
}
