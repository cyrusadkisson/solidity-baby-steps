contract greeter {
    address owner;
    string greeting;

    function greeter(string _greeting) public {
        owner = msg.sender; 
        greeting = _greeting;
    }
    
    /* Function to recover the funds on the contract */
    function kill() { if (msg.sender == owner) suicide(owner); }

    /* main function */
    function greet() constant returns (string) {
        return greeting;
    }
    
    function getBlockNumber() constant returns (uint) {
        return block.number;
    }
    
    function setGreeting(string _newgreeting) {
        greeting = _newgreeting;
    }
    
     /**********
     Standard kill() function to recover funds 
     **********/
    
    function kill() returns (bool) 
    { 
        if (msg.sender == creator)
        {
            suicide(creator);  // kills this contract and sends remaining funds back to creator
            return true;
        }
        else
        {
            return false;
        }
    }

}