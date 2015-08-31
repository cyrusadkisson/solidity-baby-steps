contract creatorBalanceChecker {

    address creator;
    uint creatorbalance;

    function creatorBalanceChecker() public 
    {
        creator = msg.sender; 								 // msg is a global variable
        creatorbalance = creator.balance;
    }

	function getContractAddress() constant returns (address) 
	{
		return this;
	}

	function getCreatorBalance() constant returns (uint)     // Will return the creator's balance AT THE TIME THIS CONTRACT WAS CREATED
	{
        return creatorbalance;
    }
    
    function getCreatorDotBalance() constant returns (uint)  // Will return creator's balance NOW
    {
        return creator.balance;
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