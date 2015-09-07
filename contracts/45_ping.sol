// Contracts can get non-constant return values from functions in other contracts. (Whereas you can't from web3/geth.)
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
            suicide(creator);  // kills this contract and sends remaining funds back to creator
    }
}


/*

var _pongAddress =  web3.toBigNumber( '0x4d6412ebac502b70776a902c03f8775b3007f70d') ;

var pingContract = web3.eth.contract([{
    "constant": false,
    "inputs": [],
    "name": "getAddress",
    "outputs": [{
        "name": "",
        "type": "address"
    }],
    "type": "function"
}, {
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
    "constant": true,
    "inputs": [],
    "name": "getPongvalConstant",
    "outputs": [{
        "name": "",
        "type": "int8"
    }],
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
        data: '60606040526000600060006101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055506040516020806104dd8339016040526060805190602001505b33600160006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908302179055507fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff600060016101000a81548160ff02191690837f010000000000000000000000000000000000000000000000000000000000000090810204021790555080600060026101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908302179055505b506103be8061011f6000396000f3006060604052361561007f576000357c01000000000000000000000000000000000000000000000000000000009004806338cc48311461008157806339df1608146100b85780633af94817146100cb57806340193d17146100d857806341c0e1b5146100fc578063fab43cb114610109578063fb5d5729146101405761007f565b005b61008c600450610272565b604051808273ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b6100c9600480359060200150610214565b005b6100d66004506102f8565b005b6100e36004506101f8565b604051808260000b815260200191505060405180910390f35b610107600450610164565b005b610114600450610243565b604051808273ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b61014b60045061027f565b604051808260000b815260200191505060405180910390f35b600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614156101f557600160009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16ff5b5b565b6000600060019054906101000a900460000b9050610211565b90565b80600060026101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908302179055505b50565b6000600060029054906101000a900473ffffffffffffffffffffffffffffffffffffffff16905061026f565b90565b600030905061027c565b90565b60007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff600060006101000a81548160ff02191690837f0100000000000000000000000000000000000000000000000000000000000000908102040217905550600060009054906101000a900460000b90506102f5565b90565b600060029054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1663fb5d5729604051817c01000000000000000000000000000000000000000000000000000000000281526004018090506020604051808303816000876161da5a03f1156100025750505060405151600060016101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055505b56',
        gas: 1000000
    },
    function(e, contract) {
        if (typeof contract.address != 'undefined') {
            console.log(e, contract);
            console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
        }
    });
    
> Contract mined! Address: 0x17368ba7a5e05d4204edc1692dc875fbacf90245
[object Object]
> 
> pong.getPongvalConstant();
-87		// pong knows its pongval									
> ping.getPongvalConstant();
-1		// ping doesn't know the new value yet
> ping.getPongvalRemote.sendTransaction({from:eth.coinbase,gas:1000000});
"0xaad73ff006032e59d8a84055528f1361e6cfe02a7cf44acf61fcaed334b3a097"
> ping.getPongvalConstant();
-87     // now ping knows the pongval from the transactional return value.
> 
    
    */