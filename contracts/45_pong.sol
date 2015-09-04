// Supposedly, contracts can get non-constant return values from other contracts. (Whereas you can't from web3/geth.)
// These two contracts are meant to test this. Like so:

// 1. Deploy Pong.
// 2. Deploy Ping, giving it the address of Pong.
// 3. Set a variable in Pong.
// 4. Retrieve the variable in Pong *through Ping*, using a sendTransaction from geth -> Ping -> Pong.
// 5. If successful Ping.getPongval() should return the value from step 3.


contract Pong {

    address creator;
	int8 pongval;

	/*********
 	 Step 1: Deploy Pong
 	 *********/
    function Pong() 
    {
        creator = msg.sender; 
    }
	
	/*********
	 Step 3. Set pongval.
	 *********/	
	function setPongval(int8 _pongval)
	{
		pongval = _pongval;
	}
	
	/*********
	 Step 4b. Transactionally return pongval.
	 *********/	
	function getPongval() returns (int8)
    {
    	return pongval;
    }
    
    function getPongvalConstant() constant returns (int8)
    {
    	return pongval;
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
    "constant": false,
    "inputs": [],
    "name": "kill",
    "outputs": [],
    "type": "function"
}, {
    "constant": false,
    "inputs": [],
    "name": "getPongval",
    "outputs": [{
        "name": "",
        "type": "int8"
    }],
    "type": "function"
}, {
    "inputs": [],
    "type": "constructor"
}]);

var pong = pongContract.new({
    from: web3.eth.accounts[0],
    data: '60606040525b33600060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908302179055505b610184806100406000396000f30060606040526000357c01000000000000000000000000000000000000000000000000000000009004806323a1c2711461004f57806341c0e1b5146100625780638bc889e71461006f5761004d565b005b610060600480359060200150610093565b005b61006d6004506100f0565b005b61007a6004506100d4565b604051808260000b815260200191505060405180910390f35b80600060146101000a81548160ff02191690837f01000000000000000000000000000000000000000000000000000000000000009081020402179055505b50565b6000600060149054906101000a900460000b90506100ed565b90565b600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16141561018157600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16ff5b5b56',
    gas: 1000000
}, function(e, contract) {
    if (typeof contract.address != 'undefined') {
        console.log(e, contract);
        console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
});

0x83e61a143f7b9e281948ce53f4c46c7124ec9dab

*/