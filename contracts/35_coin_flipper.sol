contract CoinFlipper {

    address creator;
    uint contract_creation_value;	// original endowment
    int lastgainloss;
    string lastresult;
    uint lastblocknumberused;
    bytes32 lastblockhashused;
//	 uint8 numbetsmade; // this doesn't work


    function CoinFlipper() private 
    {
        creator = msg.sender; 								// msg is a global variable
        lastresult = "no wagers yet";
        lastgainloss = 0;
    }
	
    function getEndowmentBalance() constant returns (uint)
    {
    	return this.balance;
    }
    
    function sha(uint128 wager) constant private returns(uint256)  
    { 
        return uint256(sha3(block.difficulty, block.coinbase, now, wager));  // DISCLAIMER: I don't know if this is random enough.
    }
    
    function betAndFlip() public               
    {
   		//numbetsmade = (numbetsmade + 1); // compiles but doesn't work. 
    	if(msg.value > 340282366920938463463374607431768211455)                 // this number is 2^128 - 1 = uint128 limit
    	{
    		// if too large, return wager
    		lastresult = "wager too large";
    		lastgainloss = 0;
    		msg.sender.send(msg.value);
    		return;
    	}		  
    	else if((msg.value * 2) > this.balance) 			// contract has to have 2*wager funds to be able to pay out. (current balance INCLUDES the wager sent)
    	{
    		lastresult = "wager larger than contract's ability to pay";
    		lastgainloss = 0;
    		msg.sender.send(msg.value);
    		return;
    	}
    	else if (msg.value == 0)
    	{
    		lastresult = "wager was zero";
    		lastgainloss = 0;
    		// nothing wagered, nothing returned
    		return;
    	}
    		
    	uint128 wager = uint128(msg.value);          // limiting to uint128 guarantees that conversion to int256 will stay positive
    	
    	lastblocknumberused = block.number;
    	lastblockhashused = block.blockhash(block.number); // is returning 0x000... right now. Don't know why.
    	
	   	uint hash = sha(wager);
	    if( hash % 2 == 0 )
	   	{
	    	lastgainloss = int(wager) * -1;
	    	lastresult = "loss";
	    	// they lost. Return nothing.
	    	return;
	    }
	    else
	    {
	    	lastgainloss = wager;
	    	lastresult = "win";
	    	msg.sender.send(wager * 2);
	    } 		
    }
    
  //  numbetsmade isn't working. Don't know why 
  //  function getNumBetsMade() constant returns (uint8)
  //  {
  //  	return numbetsmade;
  //  }
    
  	function getLastBlockNumberUsed() constant returns (uint)
    {
        return lastblocknumberused;
    }
    
    function getLastBlockHashUsed() constant returns (bytes32)
    {
    	return lastblockhashused;
    }

    function getResultOfLastFlip() constant returns (string)
    {
    	return lastresult;
    }
    
    function getPlayerGainLossOnLastFlip() constant returns (int)
    {
    	return lastgainloss;
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

var coinflipperContract = web3.eth.contract([{
    "constant": true,
    "inputs": [],
    "name": "getPlayerGainLossOnLastFlip",
    "outputs": [{
        "name": "",
        "type": "int256"
    }],
    "type": "function"
}, {
    "constant": false,
    "inputs": [],
    "name": "betAndFlip",
    "outputs": [],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getLastBlockNumberUsed",
    "outputs": [{
        "name": "",
        "type": "uint256"
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
    "name": "getEndowmentBalance",
    "outputs": [{
        "name": "",
        "type": "uint256"
    }],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getLastBlockHashUsed",
    "outputs": [{
        "name": "",
        "type": "bytes32"
    }],
    "type": "function"
}, {
    "constant": true,
    "inputs": [],
    "name": "getResultOfLastFlip",
    "outputs": [{
        "name": "",
        "type": "string"
    }],
    "type": "function"
}, {
    "inputs": [],
    "type": "constructor"
}]);

var coinflipper = coinflipperContract.new({
    from: web3.eth.accounts[0],
    data: '60606040525b33600060006101000a81548173ffffffffffffffffffffffffffffffffffffffff02191690830217905550604060405190810160405280600d81526020017f6e6f2077616765727320796574000000000000000000000000000000000000008152602001506003600050908051906020019082805482825590600052602060002090601f0160209004810192821560b7579182015b8281111560b6578251826000505591602001919060010190609a565b5b50905060de919060c2565b8082111560da576000818150600090555060010160c2565b5090565b505060006002600050819055505b61090e806100fb6000396000f3006060604052361561007f576000357c0100000000000000000000000000000000000000000000000000000000900480630efafd011461008157806325d8dcf2146100a257806334dbe44d146100af57806341c0e1b5146100d05780635acce36b146100dd57806394c3fa2e146100fe578063cee6f93c1461011f5761007f565b005b61008c6004506107de565b6040518082815260200191505060405180910390f35b6100ad6004506101bc565b005b6100ba60045061073c565b6040518082815260200191505060405180910390f35b6100db6004506107f0565b005b6100e8600450610198565b6040518082815260200191505060405180910390f35b61010960045061074e565b6040518082815260200191505060405180910390f35b61012a600450610760565b60405180806020018281038252838181518152602001915080519060200190808383829060006004602084601f0104600302600f01f150905090810190601f16801561018a5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b60003073ffffffffffffffffffffffffffffffffffffffff163190506101b9565b90565b600060006fffffffffffffffffffffffffffffffff3411156102d657604060405190810160405280600f81526020017f776167657220746f6f206c6172676500000000000000000000000000000000008152602001506003600050908051906020019082805482825590600052602060002090601f01602090048101928215610262579182015b82811115610261578251826000505591602001919060010190610243565b5b50905061028d919061026f565b80821115610289576000818150600090555060010161026f565b5090565b505060006002600050819055503373ffffffffffffffffffffffffffffffffffffffff16600034604051809050600060405180830381858888f1935050505050610738566104ee565b3073ffffffffffffffffffffffffffffffffffffffff163160023402111561041c57606060405190810160405280602b81526020017f7761676572206c6172676572207468616e20636f6e747261637427732061626981526020017f6c69747920746f207061790000000000000000000000000000000000000000008152602001506003600050908051906020019082805482825590600052602060002090601f016020900481019282156103a8579182015b828111156103a7578251826000505591602001919060010190610389565b5b5090506103d391906103b5565b808211156103cf57600081815060009055506001016103b5565b5090565b505060006002600050819055503373ffffffffffffffffffffffffffffffffffffffff16600034604051809050600060405180830381858888f1935050505050610738566104ed565b60003414156104ec57604060405190810160405280600e81526020017f776167657220776173207a65726f0000000000000000000000000000000000008152602001506003600050908051906020019082805482825590600052602060002090601f016020900481019282156104af579182015b828111156104ae578251826000505591602001919060010190610490565b5b5090506104da91906104bc565b808211156104d657600081815060009055506001016104bc565b5090565b50506000600260005081905550610738565b5b5b34915043600460005081905550434060056000508190555061050f82610884565b9050600060028206141561061b577fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff826fffffffffffffffffffffffffffffffff1602600260005081905550604060405190810160405280600481526020017f6c6f7373000000000000000000000000000000000000000000000000000000008152602001506003600050908051906020019082805482825590600052602060002090601f016020900481019282156105e5579182015b828111156105e45782518260005055916020019190600101906105c6565b5b50905061061091906105f2565b8082111561060c57600081815060009055506001016105f2565b5090565b505061073856610737565b816fffffffffffffffffffffffffffffffff16600260005081905550604060405190810160405280600381526020017f77696e00000000000000000000000000000000000000000000000000000000008152602001506003600050908051906020019082805482825590600052602060002090601f016020900481019282156106c1579182015b828111156106c05782518260005055916020019190600101906106a2565b5b5090506106ec91906106ce565b808211156106e857600081815060009055506001016106ce565b5090565b50503373ffffffffffffffffffffffffffffffffffffffff166000600284026fffffffffffffffffffffffffffffffff16604051809050600060405180830381858888f19350505050505b5b5050565b6000600460005054905061074b565b90565b6000600560005054905061075d565b90565b60206040519081016040528060008152602001506003600050805480601f016020809104026020016040519081016040528092919081815260200182805480156107cf57820191906000526020600020905b8154815290600101906020018083116107b257829003601f168201915b505050505090506107db565b90565b600060026000505490506107ed565b90565b600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16141561088157600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16ff5b5b565b600044414284604051808581526020018473ffffffffffffffffffffffffffffffffffffffff166c01000000000000000000000000028152601401838152602001826fffffffffffffffffffffffffffffffff167001000000000000000000000000000000000281526010019450505050506040518091039020600190049050610909565b91905056',
    gas: 1000000,
    value: 1000000000000000000
}, function(e, contract) {
    if (typeof contract.address != 'undefined') {
        console.log(e, contract);
        console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
});

0x18487f6fa9c9d809940b0d6d2626f33f0c729e4c

// ********** after deployment

> coinflipper.getEndowmentBalance();
6000000000000000000
> coinflipper.betAndFlip.sendTransaction({from:eth.coinbase, value: 1000000000000000000}); // 1 ETH. Let's see what happens
"0xc78a24881c7f70d25a817dcfcdce3347ca0cd265b7ba30a60df61e5639482bcf"
> coinflipper.getResultOfLastFlip();
"no wagers yet"
> coinflipper.getResultOfLastFlip(); // has the tx been mined yet?
"no wagers yet"
> coinflipper.getResultOfLastFlip(); // has the tx been mined yet?
"no wagers yet"
> coinflipper.getResultOfLastFlip(); // has the tx been mined yet? I'm waiting...
"no wagers yet"
> coinflipper.getResultOfLastFlip(); // has the tx been mined yet? I'm waiting...
"win"
> coinflipper.getPlayerGainLossOnLastFlip();
1000000000000000000
> web3.fromWei(coinflipper.getPlayerGainLossOnLastFlip());
1
> coinflipper.getEndowmentBalance();
5000000000000000000
> coinflipper.betAndFlip.sendTransaction({from:eth.coinbase, value: 3000000000000000000}); // 3 ETH. Let's see what happens
"0xcae272652649e07c343674d15b40a086c559408d9c66d8022de3f54932bf3d9f"
> coinflipper.getResultOfLastFlip(); // has the tx been mined yet? I'm waiting...
"loss"
> coinflipper.getEndowmentBalance();
8000000000000000000
> web3.fromWei(coinflipper.getPlayerGainLossOnLastFlip());
-3
> web3.eth.getBalance(eth.coinbase);
1806931309200681965
> web3.fromWei(web3.eth.getBalance(eth.coinbase));
1.806931309200681965
> coinflipper.betAndFlip.sendTransaction({from:eth.coinbase, value: 1500000000000000000}); // 1.5 ETH. Let's see what happens
"0xc99add577b3180ca58b1a8219f2cd282f6b77edb63e1e384b05abc434753b1a1"
> coinflipper.getResultOfLastFlip(); // has the tx been mined yet? I'm waiting...
"win"
> web3.fromWei(web3.eth.getBalance(eth.coinbase));
3.304471659200681965
> web3.fromWei(web3.eth.getBalance(eth.coinbase));
> coinflipper.kill.sendTransaction({from:eth.coinbase});
"0xed9f9e49cca76965ba32acce2b2f0b17ada467e52d55b803c26cc7132ba108fa"
  
  
 // ************** after separate deployment with smaller endowment to test payout safety limit
 
  Contract mined! address: 0xb0824b45f4a4c1ee4df356378d555c7f4366fa4c transactionHash: 0x065580a137654a816abdeb27e690e6c96f59dce92a9e8064f6f8c3c49cf0b681

> coinflipper.getEndowmentBalance();   // 1 eth
1000000000000000000
> coinflipper.betAndFlip.sendTransaction({from:eth.coinbase, value: 3000000000000000000}); // 3 ETH, more than endowment can handle. Let's see what happens
"0x66b5ae12f215d1bcf1a1656f79ccedc69612dc891f35dce5dbd6ead8854f0cb1"
> coinflipper.getResultOfLastFlip(); // has the tx been mined yet? I'm waiting...
"no wagers yet"
> coinflipper.getResultOfLastFlip(); // has the tx been mined yet? I'm waiting...
"no wagers yet"
> coinflipper.getResultOfLastFlip(); // has the tx been mined yet? I'm waiting...
"no wagers yet"
> coinflipper.getResultOfLastFlip(); // has the tx been mined yet? I'm waiting...
"wager larger than contract's ability to pay"
> coinflipper.getEndowmentBalance();
1000000000000000000
> coinflipper.betAndFlip.sendTransaction({from:eth.coinbase, value: 500000000000000000}); // .5 ETH.
"0x16ef5f3f0778b1252dcfd3b55f09ab97382f23d8ad7489f1f1b45d88eb7588f5"
> coinflipper.getResultOfLastFlip(); // has the tx been mined yet? I'm waiting...
"loss"
  
  
  
 */