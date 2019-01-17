pragma solidity ^0.4.22;

contract Mortal {
  /* Define variable owner of the type address */
  address owner;

  /* This constructor is executed at initialization and sets the owner of the contract */
  constructor() public { owner = msg.sender; }

  /* Function to recover the funds on the contract */
  function kill() public { if (msg.sender == owner) selfdestruct(msg.sender); }
}

contract MsgValueToBytes20 is Mortal {

	uint initialval;
	uint80 uint80val;
	bytes20 finalval;

  function convertMsgValueToBytes20() {
  	initialval = msg.value;

		// 1 wei up to (2^80 - 1) wei is the valid uint80 range
  	if (msg.value > 0 || msg.value < 1208925819614629174706176) {
  		uint80val = uint80(msg.value);
  		finalval = bytes20(uint80val);
  	}
  }

  function getInitialval() constant returns (uint) {
  	return initialval;
  }

  function getUint80val() constant returns (uint80) {
  	return uint80val;
  }

  function getFinalval() constant returns (bytes20) {
  	return finalval;
  }

}


/*
	DEMO:

	> msgvaluetobytes20.convertMsgValueToBytes20.sendTransaction({from:eth.coinbase,value:web3.toWei(.001,"ether")});
	> msgvaluetobytes20.getInitialval();
	10000
	> msgvaluetobytes20.getUint80val();
	10000
	> msgvaluetobytes20.getFinalval();
	"0x0000000000000000000000000000000000002710"

*/
