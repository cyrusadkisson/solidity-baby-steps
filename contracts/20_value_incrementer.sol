contract incrementer {

    address creator;
    uint iteration;

    function incrementer() public 
    {
        creator = msg.sender; 
        iteration = 0;
    }

    function increment() 
    {
        iteration = iteration + 1;
    }
    
    function getIteration() constant returns (uint) 
    {
        return iteration;
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