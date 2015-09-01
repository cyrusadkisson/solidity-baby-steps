contract msgExaminer {

    address creator;
    address miner;
  
    bytes contract_creation_data;
    uint contract_creation_gas;
    uint contract_creation_value;
    uint contract_creation_tx_gasprice;
    address contract_creation_tx_origin;

    function msgExaminer() public 
    {
        creator = msg.sender; 								// msg is a global variable
       
        miner = 0x910561dc5921131ee5de1e9748976a4b9c8c1e80;
        contract_creation_data = msg.data;
        contract_creation_gas = msg.gas;
        contract_creation_value = msg.value;  				// the endowment of this contract in wei 
        
        contract_creation_tx_gasprice = tx.gasprice;
        contract_creation_tx_origin = tx.origin;
    }
	
	function getContractCreationData() constant returns (bytes) 		// return val should change depending on the input
    {										              			
    	return contract_creation_data;
    }
	
	function getContractCreationGas() constant returns (uint) 		// return val should change depending on the input
    {										              			
    	return contract_creation_gas;
    }
	
    function getContractCreationValue() constant returns (uint) 		// return val should change depending on the input
    {										              			
    	return contract_creation_value;
    }
    
    function getContractCreationTxGasprice() constant returns (uint) 	
    {											     	
    	return contract_creation_tx_gasprice;
    }
    
    function getContractCreationTxOrigin() constant returns (address) 
    {											     
    	return contract_creation_tx_origin;
    }
    
    bytes msg_data_before_creator_send;
    bytes msg_data_after_creator_send;
    uint msg_gas_before_creator_send;
    uint msg_gas_after_creator_send;
  	uint msg_value_before_creator_send;
    uint msg_value_after_creator_send;
    
    function sendOneEtherToMiner() returns (bool success)      	
    {						
    	msg_gas_before_creator_send = msg.gas;			// save msg values
    	msg_data_before_creator_send = msg.data;	
    	msg_value_before_creator_send = msg.value;			  
    	bool returnval = miner.send(1000000000000000000);				// do something gassy
    	msg_gas_after_creator_send = msg.gas;			// save them again
    	msg_data_after_creator_send = msg.data;
    	msg_value_after_creator_send = msg.value;		// did anything change? Use getters below.
    	return returnval;
    }
    
    function sendOneEtherToHome() returns (bool success)         	
    {						
    	msg_gas_before_creator_send = msg.gas;			// save msg values
    	msg_data_before_creator_send = msg.data;	
    	msg_value_before_creator_send = msg.value;			  
    	bool returnval = creator.send(1000000000000000000);				// do something gassy
    	msg_gas_after_creator_send = msg.gas;			// save them again
    	msg_data_after_creator_send = msg.data;
    	msg_value_after_creator_send = msg.value;		// did anything change? Use getters below.
    	return returnval;
    }
    
    
    function getMsgData() constant returns (bytes)			// "returns data sent with tx"? This one or the one that created the contract?
    {
    	return msg.data;
    }
    
    function getMsgDataBefore() constant returns (bytes)          
    {						
    	return msg_data_before_creator_send;							  
    }
    
    function getMsgDataAfter() constant returns (bytes)         
    {						
    	return msg_data_after_creator_send;							  
    }
    
    
    
    function getMsgGas() constant returns (uint)			// "remaining gas" Of what? This call or the contact?
    {
    	return msg.gas;
    }
    
    function getMsgGasBefore() constant returns (uint)          
    {						
    	return msg_gas_before_creator_send;							  
    }
    
    function getMsgGasAfter() constant returns (uint)         
    {						
    	return msg_gas_after_creator_send;							  
    }
    
   
   
    
    function getMsgValue() constant returns (uint)			// "returns amt of wei sent with the message" This call or the whole contract?
    {
    	return msg.value;
    }
    
    function getMsgValueBefore() constant returns (uint)          
    {						
    	return msg_value_before_creator_send;							  
    }
    
    function getMsgValueAfter() constant returns (uint)         
    {						
    	return msg_value_after_creator_send;							  
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
