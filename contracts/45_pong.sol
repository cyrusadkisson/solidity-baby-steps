// Supposedly, contracts can get non-constant return values from other contracts. (Whereas you can't from web3/geth.)
// These two contracts are meant to test this. Like so:

// 1. Deploy Pong with a pongval.
// 2. Deploy Ping, giving it the address of Pong.
// 3. Call Ping.getPongvalRemote() using a sendTransaction...
// 4. ... which retreives the value of pongval from Pong.
// 5. If successful Ping.getPongval() should return the value from step 1.

contract PongvalRetriever {
	function getPongvalTransactional() public returns (int8){	// tells Ping how to interact with Pong.
		return -1;
	}
}

contract Pong is PongvalRetriever{

    address creator;
    int8 pongval;

	/*********
 	 Step 1: Deploy Pong
 	 *********/
    function Pong(int8 _pongval) 
    {
        creator = msg.sender; 
        pongval = _pongval;
    }
	
	/*********
	 Step 4. Transactionally return pongval, overriding PongvalRetriever
	 *********/	
	function getPongvalTransactional() public returns (int8)
    {
    	pongval_tx_retrieval_attempted = 1;
    	return pongval;
    }
    
// ----------------------------------------------------------------------------------------------------------------------------------------
    
    /*********
	 pongval getter/setter, just in case.
	 *********/
	function getPongvalConstant() public constant returns (int8)
    {
    	return pongval;
    } 
	 	
	function setPongval(int8 _pongval)
	{
		pongval = _pongval;
	}
	
	function getPongvalTxRetrievalAttempted() constant returns (int8)
	{
		return pongval_tx_retrieval_attempted;
	}
	
	/****
	 For double-checking this contract's address
	 ****/
	function getAddress() constant returns (address)
	{
		return this;
	}
	
    /**********
     Standard kill() function to recover funds 
     **********/
    
    function kill()
    { 
        if (msg.sender == creator)
            suicide(creator);  // kills this contract and sends remaining funds back to creator
    }
}

/*

var _pongval = -87 ;

// define the Pong contract w/ ABI

var pongContract = web3.eth.contract([{
    "constant": false,
    "inputs": [{
        "name": "_pongval",
        "type": "int8"
    }],
    "name": "setPongval",
    "outputs": [],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getAddress",
    "outputs": [{
        "name": "",
        "type": "address"
    }],
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
    "name": "getPongvalTxRetrievalAttempted",
    "outputs": [{
        "name": "",
        "type": "int8"
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
        "name": "_pongval",
        "type": "int8"
    }],
    "type": "constructor"
}]);

//  publish the contract

var pong = pongContract.new(
    _pongval, {
        from: web3.eth.accounts[0],
        data: '60606040526000600060006101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055506040516020806103818339016040526060805190602001505b33600060016101000a81548173ffffffffffffffffffffffffffffffffffffffff0219169083021790555080600060156101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055505b506102ad806100d46000396000f30060606040523615610074576000357c01000000000000000000000000000000000000000000000000000000009004806323a1c2711461007657806338cc48311461008957806340193d17146100c057806341c0e1b5146100e4578063a396541e146100f1578063fb5d57291461011557610074565b005b6100876004803590602001506101af565b005b61009460045061020c565b604051808273ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b6100cb600450610193565b604051808260000b815260200191505060405180910390f35b6100ef600450610219565b005b6100fc6004506101f0565b604051808260000b815260200191505060405180910390f35b610120600450610139565b604051808260000b815260200191505060405180910390f35b60006001600060006101000a81548160ff02191690837f0100000000000000000000000000000000000000000000000000000000000000908102040217905550600060159054906101000a900460000b9050610190565b90565b6000600060159054906101000a900460000b90506101ac565b90565b80600060156101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055505b50565b6000600060009054906101000a900460000b9050610209565b90565b6000309050610216565b90565b600060019054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614156102aa57600060019054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16ff5b5b56',
        gas: 1000000
    },
    function(e, contract) {
        if (!e) {
            if (!contract.address) {
                console.log('Contract transaction sent! TransactionHash: ' + contract.transactionHash + ' waiting to be mined...');
            } else {
                console.log('Contract mined! Address: ' + contract.address);
                console.log(contract);
            }
        }
    })
    
// Now deploy Ping with the address of Pong.
    
    
*/