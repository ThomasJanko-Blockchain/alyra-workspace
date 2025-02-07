// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0 ;

// (Contrat Parent)
contract One {
    uint256 public myVariable;

    function setValue(uint256 _myVariable) public {
        myVariable = _myVariable;
    }
}

// (Contrat Enfant)
contract Two is One {

    function getValue() public view returns (uint256) {
        return myVariable; // Get value from the real One contract
    }

     function setVariable(uint256 _number) public {
        setValue(_number); // Call setNumber in One
    }

}

// (Contrat Caller)
contract Three {
    Two cc = new Two();

    function callGetValue() public view returns (uint256) {
        return cc.getValue(); // Now retrieves from One
    }

    function callSetValue(uint256 _number) public {
        cc.setVariable(_number); // Calls setNumber in Two, which updates One
    }
    
}