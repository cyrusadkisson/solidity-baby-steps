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
        {
            suicide(creator);  // kills this contract and sends remaining funds back to creator
        }
    }
}

/*

var _pongval = 80 ;

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
var pong = pongContract.new(
    _pongval, {
        from: web3.eth.accounts[0],
        data: '60606040526040516020806102658339016040526060805190602001505b33600060006101000a81548173ffffffffffffffffffffffffffffffffffffffff0219169083021790555080600060146101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055505b506101cf806100966000396000f30060606040526000357c01000000000000000000000000000000000000000000000000000000009004806323a1c2711461005a57806340193d171461006d57806341c0e1b514610091578063fb5d57291461009e57610058565b005b61006b60048035906020015061018e565b005b610078600450610172565b604051808260000b815260200191505060405180910390f35b61009c6004506100c2565b005b6100a9600450610156565b604051808260000b815260200191505060405180910390f35b600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16141561015357600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16ff5b5b565b6000600060149054906101000a900460000b905061016f565b90565b6000600060149054906101000a900460000b905061018b565b90565b80600060146101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055505b5056',
        gas: 1000000
    },
    function(e, contract) {
        if (typeof contract.address != 'undefined') {
            console.log(e, contract);
            console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
        }
    })
*/