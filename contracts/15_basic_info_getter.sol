contract basicInfoGetter {

    address creator;

    function basicInfoGetter() public 
    {
        creator = msg.sender; 								      // msg is a global variable
    }
	
	function getCurrentMinerAddress() constant returns (address) // get CURRENT block miner's address, 
	{														     // not necessarily the address of the miner when this block was born
		return block.coinbase;
	}
	
	function getCurrentDifficulty() constant returns (uint)
	{
		return block.difficulty;
	}
	
	function getCurrentGaslimit() constant returns (uint)  // the most gas that can be spent on any given transaction right now
	{													   // or the most gas that can be spent, globally, on each block?
		return block.gaslimit;
	}
	
	function getCurrentBlockNumber() constant returns (uint)
	{
		return block.number;
	}

// this should work according to Contract Tutorial, but solidity compiler doesn't like it.	
//	function getBlockhash(uint) constant returns (bytes32)
//	{
//		return block.blockhash;
//  }
    
    function getBlockTimestamp() constant returns (uint)   // returns current block timestamp in SECONDS (not ms) from epoch
    {													
    	return block.timestamp; // also "now" == "block.timestamp", as in "return now;"
    }
    
    function getMsgData() constant returns (bytes) 		  // UNSURE: this always returns "0xc8e7ca2e" for me, regardless of account/computer I'm requesting from.
    {										              // adding an input parameter would probably change it with each diff call?
    	return msg.data;
    }
    
    function getMsgGas() constant returns (uint)          // UNSURE: returns gas remaining on this contract? Always returns 49978451 for me.
    {													  // would adding an input parameter change this value?
    	return msg.gas;
    }
    
    function getMsgSender() constant returns (address)    // returns the address of whomever made this call
    {													  // not necessarily the creator of the contract
    	return msg.sender;
    }
    
    function getMsgValue() constant returns (uint)		// returns amt of wei sent with this call
    {
    	return msg.value;
    }
    
    function getTxGasprice() constant returns (uint) // returns gasprice of this transaction
    {											   // Does tx exist on constant functions?
    	return tx.gasprice;
    }
    
    function getTxOrigin() constant returns (address) // returns sender of the transaction
    {											   // What if there is a chain of calls?
    	return tx.origin;
    }
    
	function getContractAddress() constant returns (address) 
	{
		return this;
	}
    
    function getContractBalance() constant returns (uint) // how is this different from gas?
    {
    	return this.balance;
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


/*

var abi = [{
    "constant": true,
    "inputs": [],
    "name": "getContractAddress",
    "outputs": [{
        "name": "",
        "type": "address"
    }],
    "type": "function"
}, {
    "constant": false,
    "inputs": [],
    "name": "kill",
    "outputs": [{
        "name": "",
        "type": "bool"
    }],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getContractBalance",
    "outputs": [{
        "name": "",
        "type": "uint256"
    }],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getCurrentBlockNumber",
    "outputs": [{
        "name": "",
        "type": "uint256"
    }],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getTxGasprice",
    "outputs": [{
        "name": "",
        "type": "uint256"
    }],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getBlockTimestamp",
    "outputs": [{
        "name": "",
        "type": "uint256"
    }],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getMsgSender",
    "outputs": [{
        "name": "",
        "type": "address"
    }],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getCurrentGaslimit",
    "outputs": [{
        "name": "",
        "type": "uint256"
    }],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getMsgGas",
    "outputs": [{
        "name": "",
        "type": "uint256"
    }],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getCurrentDifficulty",
    "outputs": [{
        "name": "",
        "type": "uint256"
    }],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getMsgValue",
    "outputs": [{
        "name": "",
        "type": "uint256"
    }],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getTxOrigin",
    "outputs": [{
        "name": "",
        "type": "address"
    }],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getMsgData",
    "outputs": [{
        "name": "",
        "type": "bytes"
    }],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getCurrentMinerAddress",
    "outputs": [{
        "name": "",
        "type": "address"
    }],
    "type": "function"
}, {
    "inputs": [],
    "type": "constructor"
}];
*/