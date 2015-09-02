/* 
	The following is an extremely basic example of a solidity contract. 
*/

contract Greeter 										// The contract definition. A constructor of the same name will be automatically called on contract creation. 
{
    address owner;										// At first, an empty "address"-type variable of the name "owner". Will be set in the constructor.
    string greeting;									// At first, an empty "string"-type variable of the name "greeting". Will be set in constructor and can be changed.

    function Greeter(string _greeting) public 			// The constructor. It accepts a string input and saves it to the contract's "greeting" variable.
    {
        owner = msg.sender; 							// Records who created this contract.
        greeting = _greeting;
    }

    function greet() constant returns (string)          
    {
        return greeting;
    }
    
    function getBlockNumber() constant returns (uint) 
    {
        return block.number;
    }
    
    function setGreeting(string _newgreeting) 
    {
        greeting = _newgreeting;
    }
    
     /**********
     Standard kill() function to recover funds 
     **********/
    
    function kill()
    { 
        if (msg.sender == creator)
        {
            suicide(creator);  // kills this contract and sends remaining funds back to creator
        }
    }

}