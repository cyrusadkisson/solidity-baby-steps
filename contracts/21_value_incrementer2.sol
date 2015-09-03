contract Incrementer2 {

    address creator;
    int iteration;
    string whathappened;

    function Incrementer2() 
    {
        creator = msg.sender; 								
        iteration = 0;
        whathappened = "constructor executed";
    }

// call this in geth like so: > incrementer2.increment.sendTransaction(3, {from:eth.coinbase});  // where 3 is the howmuch parameter
    function increment(int howmuch) 
    {
    	if(howmuch == 0)
    	{
    		iteration = iteration + 1;
    		whathappened = "howmuch was zero. Incremented by 1.";
    	}
    	else
    	{
        	iteration = iteration + howmuch;
        	whathappened = "howmuch was nonzero. Incremented by its value.";
        }
        return;
    }
    
    function getWhatHappened() constant returns (string)
    {
    	return whathappened;
    }
    
    function getIteration() constant returns (int) 
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