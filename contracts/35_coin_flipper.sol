contract CoinFlipper {

    address creator;
    uint contract_creation_value;	// original endowment
    uint lastmaxpayoutpossible;
    int lastgainloss;
    string lastresult;

    function CoinFlipper() public 
    {
        creator = msg.sender; 								// msg is a global variable
        contract_creation_value = msg.value;  				// the endowment of this contract in wei 
        lastmaxpayoutpossible = 0;
        lastresult = "no wagers yet";
        lastgainloss = 0;
    }
	
    function getContractCreationValue() constant returns (uint) // returns the original endowment of the contract
    {										              		// set at creation time with "value: <someweivalue>"	
    	return contract_creation_value;                         // this is now the "balance" of the contract
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
    	lastmaxpayoutpossible = this.balance * 2;
    	
    	if(msg.value > 340282366920938463463374607431768211455)                 // this number is 2^128 - 1 = uint128 limit
    	{
    		// if too large, return wager
    		lastresult = "wager too large";
    		lastgainloss = 0;
    		msg.sender.send(msg.value);
    		return;
    	}		  
    	else if(msg.value > lastmaxpayoutpossible) 			// contract has to have 2x funds to be able to pay out.
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
    
    function getLastMaxPayoutPossible() constant returns (uint)
    {
    	return lastmaxpayoutpossible;
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
    "name": "getContractCreationValue",
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
    "constant": true,
    "inputs": [],
    "name": "getLastMaxPayoutPossible",
    "outputs": [{
        "name": "",
        "type": "uint256"
    }],
    "type": "function"
}, {
    "inputs": [],
    "type": "constructor"
}]);

var coinflipper = coinflipperContract.new({
    from: web3.eth.accounts[0],
    data: '60606040525b33600060006101000a81548173ffffffffffffffffffffffffffffffffffffffff02191690830217905550346001600050819055506000600260005081905550604060405190810160405280600d81526020017f6e6f2077616765727320796574000000000000000000000000000000000000008152602001506004600050908051906020019082805482825590600052602060002090601f016020900481019282156100cf579182015b828111156100ce5782518260005055916020019190600101906100b0565b5b5090506100fa91906100dc565b808211156100f657600081815060009055506001016100dc565b5090565b505060006003600050819055505b610908806101176000396000f3006060604052361561007f576000357c0100000000000000000000000000000000000000000000000000000000900480630efafd011461008157806325d8dcf2146100a257806341c0e1b5146100af5780635acce36b146100bc5780636c6f1d93146100dd578063cee6f93c146100fe578063efa6358f146101775761007f565b005b61008c6004506107d8565b6040518082815260200191505060405180910390f35b6100ad6004506101ce565b005b6100ba6004506107ea565b005b6100c76004506101aa565b6040518082815260200191505060405180910390f35b6100e8600450610198565b6040518082815260200191505060405180910390f35b61010960045061075a565b60405180806020018281038252838181518152602001915080519060200190808383829060006004602084601f0104600302600f01f150905090810190601f1680156101695780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b610182600450610748565b6040518082815260200191505060405180910390f35b600060016000505490506101a7565b90565b60003073ffffffffffffffffffffffffffffffffffffffff163190506101cb565b90565b6000600060023073ffffffffffffffffffffffffffffffffffffffff1631026002600050819055506fffffffffffffffffffffffffffffffff34111561030c57604060405190810160405280600f81526020017f776167657220746f6f206c6172676500000000000000000000000000000000008152602001506004600050908051906020019082805482825590600052602060002090601f01602090048101928215610298579182015b82811115610297578251826000505591602001919060010190610279565b5b5090506102c391906102a5565b808211156102bf57600081815060009055506001016102a5565b5090565b505060006003600050819055503373ffffffffffffffffffffffffffffffffffffffff16600034604051809050600060405180830381858888f19350505050506107445661050f565b60026000505434111561043d57606060405190810160405280602b81526020017f7761676572206c6172676572207468616e20636f6e747261637427732061626981526020017f6c69747920746f207061790000000000000000000000000000000000000000008152602001506004600050908051906020019082805482825590600052602060002090601f016020900481019282156103c9579182015b828111156103c85782518260005055916020019190600101906103aa565b5b5090506103f491906103d6565b808211156103f057600081815060009055506001016103d6565b5090565b505060006003600050819055503373ffffffffffffffffffffffffffffffffffffffff16600034604051809050600060405180830381858888f19350505050506107445661050e565b600034141561050d57604060405190810160405280600e81526020017f776167657220776173207a65726f0000000000000000000000000000000000008152602001506004600050908051906020019082805482825590600052602060002090601f016020900481019282156104d0579182015b828111156104cf5782518260005055916020019190600101906104b1565b5b5090506104fb91906104dd565b808211156104f757600081815060009055506001016104dd565b5090565b50506000600360005081905550610744565b5b5b34915061051b8261087e565b90506000600282061415610627577fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff826fffffffffffffffffffffffffffffffff1602600360005081905550604060405190810160405280600481526020017f6c6f7373000000000000000000000000000000000000000000000000000000008152602001506004600050908051906020019082805482825590600052602060002090601f016020900481019282156105f1579182015b828111156105f05782518260005055916020019190600101906105d2565b5b50905061061c91906105fe565b8082111561061857600081815060009055506001016105fe565b5090565b505061074456610743565b816fffffffffffffffffffffffffffffffff16600360005081905550604060405190810160405280600381526020017f77696e00000000000000000000000000000000000000000000000000000000008152602001506004600050908051906020019082805482825590600052602060002090601f016020900481019282156106cd579182015b828111156106cc5782518260005055916020019190600101906106ae565b5b5090506106f891906106da565b808211156106f457600081815060009055506001016106da565b5090565b50503373ffffffffffffffffffffffffffffffffffffffff166000600284026fffffffffffffffffffffffffffffffff16604051809050600060405180830381858888f19350505050505b5b5050565b60006002600050549050610757565b90565b60206040519081016040528060008152602001506004600050805480601f016020809104026020016040519081016040528092919081815260200182805480156107c957820191906000526020600020905b8154815290600101906020018083116107ac57829003601f168201915b505050505090506107d5565b90565b600060036000505490506107e7565b90565b600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16141561087b57600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16ff5b5b565b600044414284604051808581526020018473ffffffffffffffffffffffffffffffffffffffff166c01000000000000000000000000028152601401838152602001826fffffffffffffffffffffffffffffffff167001000000000000000000000000000000000281526010019450505050506040518091039020600190049050610903565b91905056',
    gas: 1000000,
    value: 6000000000000000000 /// ENDOW WITH 6 ETHER
}, function(e, contract) {
    if (typeof contract.address != 'undefined') {
        console.log(e, contract);
        console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
});


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
  
  
 */