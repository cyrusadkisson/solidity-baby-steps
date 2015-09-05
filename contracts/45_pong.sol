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

contract Pong is PongvalRetriever{

    address creator;

	/*********
 	 Step 1: Deploy Pong
 	 *********/
    function Pong(int8 _pongval) 
    {
        creator = msg.sender; 
        pongval = _pongval;
    }
	
	/*********
	 Step 4. Transactionally return pongval.
	 *********/	
//	function getPongvalTransactional() public returns (int8)
//    {
//    	return pongval;
//    }
    
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

var _pongval = -56;

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
    "constant": true,
    "inputs": [],
    "name": "pongval",
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
        data: '606060405260405160208061025c8339016040526060805190602001505b33600060016101000a81548173ffffffffffffffffffffffffffffffffffffffff0219169083021790555080600060156101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055505b506101c6806100966000396000f30060606040526000357c01000000000000000000000000000000000000000000000000000000009004806323a1c2711461005a57806340193d171461006d57806341c0e1b514610091578063809e99241461009e57610058565b005b61006b6004803590602001506100f1565b005b6100786004506100d5565b604051808260000b815260200191505060405180910390f35b61009c600450610132565b005b6100a96004506100c2565b604051808260000b815260200191505060405180910390f35b600060009054906101000a900460000b81565b6000600060159054906101000a900460000b90506100ee565b90565b80600060156101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055505b50565b600060019054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614156101c357600060019054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16ff5b5b56',
        gas: 1000000
    },
    function(e, contract) {
        if (typeof contract.address != 'undefined') {
            console.log(e, contract);
            console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
        }
    })
*/