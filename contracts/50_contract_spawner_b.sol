// Spawn a secondary contract from a contract

contract ContractSpawnerB {

    address creator;

    function ContractSpawnerB() 
    {
        creator = msg.sender;
         
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