// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

contract Transfer {
    //Difference between send() / transfer() / call() in Solidity
    

    function deposit(address payable _to) public payable {
        //Transfer 
        _to.transfer(msg.value);

        //Send
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");

        //Call
        (bool called, ) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}