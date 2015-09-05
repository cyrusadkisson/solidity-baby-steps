// Supposedly, contracts can get non-constant return values from other contracts. (Whereas you can't from web3/geth.)
// These two contracts are meant to test this. Like so:

// 1. Deploy Pong with a pongval.
// 2. Deploy Ping, giving it the address of Pong.
// 3. Call Ping.getPongvalRemote() using a sendTransaction...
// 4. ... which retreives the value of pongval from Pong.
// 5. If successful Ping.getPongval() should return the value from step 1.

contract PongvalRetriever {
 	int8 pongval_tx_retrieval_attempted = 0;
	function getPongvalTransactional() public returns (int8){
		pongval_tx_retrieval_attempted = -1;
		return pongval_tx_retrieval_attempted;
	}
}

contract Ping is PongvalRetriever {

 	int8 pongval;
	PongvalRetriever pvr;
    address creator;

	/*********
 	 Step 2: Deploy Ping, giving it the address of Pong.
 	 *********/
    function Ping(PongvalRetriever _pongAddress) 
    {
        creator = msg.sender; 	
        pongval = -1;							
        pvr = _pongAddress;
    }

	/*********
     Step 3: Transactionally retrieve pongval from Pong. 
     *********/

	function getPongvalRemote() 
	{
		pongval = pvr.getPongvalTransactional();
	}
	
	/*********
     Step 5: Get pongval (which was previously retrieved from Pong via transaction)
     *********/
     
    function getPongvalConstant() constant returns (int8)
    {
    	return pongval;
    }
	
  
// -----------------------------------------------------------------------------------------------------------------	
	
	/*********
     Functions to get and set pongAddress just in case
     *********/
    
    function setPongAddress(PongvalRetriever _pongAddress)
	{
		pvr = _pongAddress;
	}
	
	function getPongAddress() constant returns (address)
	{
		return pvr;
	}
    
    /****
	 For double-checking this contract's address
	 ****/
	function getAddress() returns (address)
	{
		return this;
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


/*

var _pongAddress =0xc57e0801aee526cddf9ad4302c54cc2d23cf6b09;

var pingContract = web3.eth.contract([{
    "constant": false,
    "inputs": [{
        "name": "_pongAddress",
        "type": "address"
    }],
    "name": "setPongAddress",
    "outputs": [],
    "type": "function"
}, {
    "constant": false,
    "inputs": [],
    "name": "getPongvalRemote",
    "outputs": [],
    "type": "function"
}, {
    "constant": false,
    "inputs": [],
    "name": "kill",
    "outputs": [],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getPongval",
    "outputs": [{
        "name": "",
        "type": "int8"
    }],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getPongAddress",
    "outputs": [{
        "name": "",
        "type": "address"
    }],
    "type": "function"
}, {
    "constant": false,
    "inputs": [],
    "name": "getPongvalTransactional",
    "outputs": [{
        "name": "",
        "type": "int8"
    }],
    "type": "function"
}, {
    "inputs": [{
        "name": "_pongAddress",
        "type": "address"
    }],
    "type": "constructor"
}]);
var ping = pingContract.new(
    _pongAddress, {
        from: web3.eth.accounts[0],
        data: '',
        gas: 1000000
    },
    function(e, contract) {
        if (typeof contract.address != 'undefined') {
            console.log(e, contract);
            console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
        }
    })
    
    */