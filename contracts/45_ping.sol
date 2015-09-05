// Supposedly, contracts can get non-constant return values from other contracts. (Whereas you can't from web3/geth.)
// These two contracts are meant to test this. Like so:

// 1. Deploy Pong with a pongval.
// 2. Deploy Ping, giving it the address of Pong.
// 3. Call Ping.getPongvalRemote() using a sendTransaction...
// 4. ... which retreives the value of pongval from Pong.
// 5. If successful Ping.getPongval() should return the value from step 3.

contract PongvalRetriever {
	int8 public pongval;
}

contract Ping is PongvalRetriever {

	PongvalRetriever pvr;
    address creator;
    int8 public pongval = -1;

	/*********
 	 Step 2: Deploy Ping, giving it the address of Pong.
 	 *********/
    function Ping(PongvalRetriever _pongAddress) 
    {
        creator = msg.sender; 	
        pvr = _pongAddress;
    }

	/*********
     Step 3: Transactionally retrieve pongval from Pong. 
     *********/

	function getPongvalRemote() 
	{
		pongval = pvr.pongval();
	}
	
	/*********
     Step 5: Get pongval (which was previously retrieved from Pong via transaction)
     *********/
     
    function getPongval() constant returns (int8)
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

var _pongAddress = 0x73a1f27d7179ff28251dd87373b61218c7e3cb0a;

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
    "name": "pongval",
    "outputs": [{
        "name": "",
        "type": "int8"
    }],
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
    "inputs": [{
        "name": "_pongAddress",
        "type": "address"
    }],
    "type": "constructor"
}]);

var ping = pingContract.new(
    _pongAddress, {
        from: web3.eth.accounts[0],
        data: '60606040527fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff600160146101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055506040516020806104478339016040526060805190602001505b33600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908302179055507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff600160146101000a81548160ff02191690837f010000000000000000000000000000000000000000000000000000000000000090810204021790555080600060016101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908302179055505b506103098061013e6000396000f30060606040523615610074576000357c01000000000000000000000000000000000000000000000000000000009004806339df1608146100765780633af948171461008957806341c0e1b514610096578063809e9924146100a35780638bc889e7146100c7578063fab43cb1146100eb57610074565b005b610087600480359060200150610204565b005b610094600450610122565b005b6100a1600450610262565b005b6100ae6004506102f6565b604051808260000b815260200191505060405180910390f35b6100d26004506101e8565b604051808260000b815260200191505060405180910390f35b6100f6600450610233565b604051808273ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b600060019054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663809e9924604051817c01000000000000000000000000000000000000000000000000000000000281526004018090506020604051808303816000876161da5a03f1156100025750505060405151600160146101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055505b565b6000600160149054906101000a900460000b9050610201565b90565b80600060016101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908302179055505b50565b6000600060019054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905061025f565b90565b600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614156102f357600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16ff5b5b565b600160149054906101000a900460000b8156',
        gas: 1000000
    },
    function(e, contract) {
        if (typeof contract.address != 'undefined') {
            console.log(e, contract);
            console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
        }
    })
    
    */