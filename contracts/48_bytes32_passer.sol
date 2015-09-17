// In addition to testing contract-to-contract variable passing, 
// this contract tests assignment of a string to a bytes32 type. 
// the result of "savedvar" is "0x1a09254100000000000000000000000000000000000000000000000000000000"
// but I don't currently understand why, and would like to know how to 
// convert that hex back into "tencharsme"

contract Descriptor {
    
	function getDescription() constant returns (bytes32){	
		bytes32 somevar;
		somevar = "tencharsme"; 
		return somevar;
	}
}

contract Bytes32Passer {

    address creator;
    bytes32 savedvar;
    string savedstring;
    Descriptor descriptor;

    function Bytes32Passer() 
    {
        creator = msg.sender;
    }
    
    function getTileDescription(uint8 x, uint8 y)
    {
    	savedvar = descriptor.getDescription();  // get the description from the descriptor
    	savedstring = string(savedvar);
    	return; 
    }
    
    function getSavedVar() constant returns (bytes32)
    {
    	return savedvar;
    }
    
    function getSavedString() constant returns (string)
    {
    	return savedstring;
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
