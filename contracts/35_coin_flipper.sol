contract CoinFlipper {

    address creator;
    uint contract_creation_value;	// original endowment
    int lastgainloss;
    string lastresult;
    uint lastblocknumberused;
   // bytes32 lastblockhashused;

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
    
    function sha(uint128 wager) constant private returns(uint256)  // DISCLAIMER: This is pretty random... but not truly random.
    { 
        return uint256(sha3(block.difficulty, block.coinbase, now, wager));  
    }
    
    function betAndFlip() public               
    {
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
    	//lastblockhashused = block.blockhash(block.number - 1);
    	
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
    
  	function getLastBlockNumberUsed() constant returns (uint)
    {
        return lastblocknumberused;
    }
    
   // function getLastBlockHashUsed() constant returns (bytes32)
  //  {
  //  	return lastblockhashused;
   // }

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
    data: '60606040525b33600060006101000a81548173ffffffffffffffffffffffffffffffffffffffff02191690830217905550604060405190810160405280600d81526020017f6e6f2077616765727320796574000000000000000000000000000000000000008152602001506003600050908051906020019082805482825590600052602060002090601f0160209004810192821560b7579182015b8281111560b6578251826000505591602001919060010190609a565b5b50905060de919060c2565b8082111560da576000818150600090555060010160c2565b5090565b505060006002600050819055505b6108c5806100fb6000396000f30060606040523615610074576000357c0100000000000000000000000000000000000000000000000000000000900480630efafd011461007657806325d8dcf21461009757806334dbe44d146100a457806341c0e1b5146100c55780635acce36b146100d2578063cee6f93c146100f357610074565b005b610081600450610795565b6040518082815260200191505060405180910390f35b6100a2600450610190565b005b6100af600450610705565b6040518082815260200191505060405180910390f35b6100d06004506107a7565b005b6100dd60045061016c565b6040518082815260200191505060405180910390f35b6100fe600450610717565b60405180806020018281038252838181518152602001915080519060200190808383829060006004602084601f0104600302600f01f150905090810190601f16801561015e5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b60003073ffffffffffffffffffffffffffffffffffffffff1631905061018d565b90565b600060006fffffffffffffffffffffffffffffffff3411156102aa57604060405190810160405280600f81526020017f776167657220746f6f206c6172676500000000000000000000000000000000008152602001506003600050908051906020019082805482825590600052602060002090601f01602090048101928215610236579182015b82811115610235578251826000505591602001919060010190610217565b5b5090506102619190610243565b8082111561025d5760008181506000905550600101610243565b5090565b505060006002600050819055503373ffffffffffffffffffffffffffffffffffffffff16600034604051809050600060405180830381858888f1935050505050610701566104c2565b3073ffffffffffffffffffffffffffffffffffffffff16316002340211156103f057606060405190810160405280602b81526020017f7761676572206c6172676572207468616e20636f6e747261637427732061626981526020017f6c69747920746f207061790000000000000000000000000000000000000000008152602001506003600050908051906020019082805482825590600052602060002090601f0160209004810192821561037c579182015b8281111561037b57825182600050559160200191906001019061035d565b5b5090506103a79190610389565b808211156103a35760008181506000905550600101610389565b5090565b505060006002600050819055503373ffffffffffffffffffffffffffffffffffffffff16600034604051809050600060405180830381858888f1935050505050610701566104c1565b60003414156104c057604060405190810160405280600e81526020017f776167657220776173207a65726f0000000000000000000000000000000000008152602001506003600050908051906020019082805482825590600052602060002090601f01602090048101928215610483579182015b82811115610482578251826000505591602001919060010190610464565b5b5090506104ae9190610490565b808211156104aa5760008181506000905550600101610490565b5090565b50506000600260005081905550610701565b5b5b349150436004600050819055506104d88261083b565b905060006002820614156105e4577fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff826fffffffffffffffffffffffffffffffff1602600260005081905550604060405190810160405280600481526020017f6c6f7373000000000000000000000000000000000000000000000000000000008152602001506003600050908051906020019082805482825590600052602060002090601f016020900481019282156105ae579182015b828111156105ad57825182600050559160200191906001019061058f565b5b5090506105d991906105bb565b808211156105d557600081815060009055506001016105bb565b5090565b505061070156610700565b816fffffffffffffffffffffffffffffffff16600260005081905550604060405190810160405280600381526020017f77696e00000000000000000000000000000000000000000000000000000000008152602001506003600050908051906020019082805482825590600052602060002090601f0160209004810192821561068a579182015b8281111561068957825182600050559160200191906001019061066b565b5b5090506106b59190610697565b808211156106b15760008181506000905550600101610697565b5090565b50503373ffffffffffffffffffffffffffffffffffffffff166000600284026fffffffffffffffffffffffffffffffff16604051809050600060405180830381858888f19350505050505b5b5050565b60006004600050549050610714565b90565b60206040519081016040528060008152602001506003600050805480601f0160208091040260200160405190810160405280929190818152602001828054801561078657820191906000526020600020905b81548152906001019060200180831161076957829003601f168201915b50505050509050610792565b90565b600060026000505490506107a4565b90565b600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16141561083857600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16ff5b5b565b600044414284604051808581526020018473ffffffffffffffffffffffffffffffffffffffff166c01000000000000000000000000028152601401838152602001826fffffffffffffffffffffffffffffffff1670010000000000000000000000000000000002815260100194505050505060405180910390206001900490506108c0565b91905056',
    gas: 1000000,
    value: 6000000000000000000 // start with endowment of 6 ETH
}, function(e, contract) {
    if (typeof contract.address != 'undefined') {
        console.log(e, contract);
        console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
});

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