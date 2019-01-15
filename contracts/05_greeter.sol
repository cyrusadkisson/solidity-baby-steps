/*
	The following is an extremely basic example of a solidity contract.
	It takes a string upon creation and then repeats it when greet() is called.
*/

pragma solidity ^0.4.23;

/// @title Greeter
/// @author Cyrus Adkisson
// The contract definition. A constructor of the same name will be automatically called on contract creation.
contract Greeter {

    // At first, an empty "address"-type variable of the name "creator". Will be set in the constructor.
    address creator;
    // At first, an empty "string"-type variable of the name "greeting". Will be set in constructor and can be changed.
    string greeting;

    // The constructor. It accepts a string input and saves it to the contract's "greeting" variable.
    function constuctor(string _greeting) public {
        creator = msg.sender;
        greeting = _greeting;
    }

    function greet() public constant returns (string) {
        return greeting;
    }

    // this doesn't have anything to do with the act of greeting
    // just demonstrating return of some global variable
    function getBlockNumber() public constant returns (uint) {
        return block.number;
    }

    function setGreeting(string _newgreeting) public {
        greeting = _newgreeting;
    }

     /**********
     Standard kill() function to recover funds
     **********/

    function kill() public {
        if (msg.sender == creator)
        // only allow this action if the account sending the signal is the creator
            selfdestruct(creator);
            // kills this contract and sends remaining funds back to creator
    }
}
