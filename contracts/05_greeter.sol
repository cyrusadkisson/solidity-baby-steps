pragma solidity ^0.4.0;


contract Greeter{
    address creator;
    string greeting;
    constructor(string _greeting) public {
        creator = msg.sender;
        greeting = _greeting;
    }
    
    function greet() constant public returns (string)          
    {
        return greeting;
    }

    function setGreeting(string _newgreeting) public{
        greeting = _newgreeting;
    }

    /**********
     Standard kill() function to recover funds 
     **********/
    
    function kill() public 
    { 
        if (msg.sender == creator)
            selfdestruct(creator);  // kills this contract and sends remaining funds back to creator
    }
}
