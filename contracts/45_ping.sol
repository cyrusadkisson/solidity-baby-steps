// Supposedly, contracts can get non-constant return values from other contracts. (Whereas you can't from web3/geth.)
// These two contracts are meant to test this. Like so:

// 1. Deploy Pong.       (SEE PONG CONTRACT)
// 2. Deploy Ping, giving it the address of Pong.
// 3. Set a variable in Pong. 			   (SEE PONG CONTRACT)			
// 4a/b. Retrieve the variable in Pong *through Ping*, using a sendTransaction from geth -> Ping -> Pong.       (SEE PONG CONTRACT)
// 5. If successful Ping.getPongval() should return the value from step 3.

contract Ping {

    address creator;
    address pongAddress;
    int8 pongval;

	/*********
 	 Step 2: Deploy Ping, giving it the address of Pong.
 	 *********/
    function Ping(address _pongAddress) 
    {
        creator = msg.sender; 								
        pongval = -1;
        pongAddress = _pongAddress;
    }

	/*********
     Step 4a: Transactionally retrieve pongval from Pong. 
     *********/

	function getPongvalRemote() 
	{
		pongval = pongAddress.call("getPongval");
	}
	
	/*********
     Step 5: Get pongval (which was previously retrieved from Pong via transaction)
     *********/
     
    function getPongval() constant returns (uint8)
    {
    	return pongval;
    }
	
    /*********
     Functions to get and set pongAddress in case the constructor doesn't work.
     *********/
    
    function setPongAddress(address _pongAddress)
	{
		pongAddress = _pongAddress;
	}
	
	function getPongAddress() constant return (address)
	{
		return pongAddress;
	}
    
    /*********
     Standard kill() function to recover funds 
     *********/
    
    function kill()
    { 
        if (msg.sender == creator)
        {
            suicide(creator);  // kills this contract and sends remaining funds back to creator
        }
    }
}
