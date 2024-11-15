// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HotelRoom {
    // Ether - pay smart contracts
    // Modifiers
    // Visibility
    // Events
    // Enums

    address payable public owner; // State variable, payment will be sent to owner from user
    Statuses public currentStatus;

    // Enum to track room status
    enum Statuses { vacant, occupied }

    // Events - allow external consumers to subscribe to them
    // like a smart lock that unlocks hotel room by listening to events on the blockchain
    event Occupy(address indexed _occupant, uint _value);

    // Modifier to check room status
    modifier onlyWhileVacant() {
        require(currentStatus == Statuses.vacant, "Currently occupied.");
        _; // Executes the function body
    }

    // Modifier to check payment amount
    modifier costs(uint _amount) {
        require(msg.value >= _amount, "Insufficient Ether provided.");
        _;
    }

    // Constructor to initialize owner and room status
    constructor() {
        owner = payable(msg.sender); // Owner is set to the contract deployer
        currentStatus = Statuses.vacant;
    }

    // Receive function, automatically invoked when Ether is sent to the contract
    receive() external payable onlyWhileVacant costs(3 ether) {
        owner.transfer(msg.value); // Transfers payment to the owner
        currentStatus = Statuses.occupied; // Updates room status
        emit Occupy(msg.sender, msg.value); // Emits the Occupy event
    }
}
