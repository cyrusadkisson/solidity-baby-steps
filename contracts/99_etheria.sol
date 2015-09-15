
contract Descriptor {
	function getDescription() public returns (int16[]){	// tells Etheria how to interact with Descriptor contracts
		int16[] placeholders;
		return placeholders;
	}
}

contract Etheria is Descriptor {

    address creator;
//    uint8 mapsize = 33;
//    Tile[33][33] tiles; 
    uint8 mapsize = 9;
    Tile[9][9] tiles; 
    
//    struct Block
//    {
//    	uint8 which;
//    	uint8[12] coords; // [w,x0,y0,z0,x1,y1,z1,x2,y2,z2,x3,y3,z3];
//    	//uint8[32] paint; // [t0,b0,tr0,r0,br0,bl0,l0,tl0,t1,b1,tr1,r1,br1,bl1,l1,tl1,t2,b2,tr2,r2,br2,bl2,l2,tl2,t3,b3,tr3,r3,br3,bl3,l3,tl3];
//    }
    
    struct Tile 
    {
        address owner;
        Descriptor descriptor;
        uint8 elevation;
        uint8[136] blocks;
    }
    
    function Etheria(uint8[] incmap) 
    {
        creator = msg.sender;
        uint counter = 0;
        Descriptor nothing;
        for(uint8 y = 0; y < mapsize; y++)
       	{
           	for(uint8 x = 0; x < mapsize; x++)
           	{
           	    tiles[x][y].descriptor = nothing;
           		tiles[x][y].elevation = incmap[counter]; 
           	}	
        }	
    }
    
    // required functions
    // - Trade tiles
    // - Trade blocks
    
    function setOwner(uint8 x, uint8 y, address newowner)
    {
    	// WARNING: A check should be performed to make sure newowner is a "normal" address, but it's not currently possible in Solidity.
    	if(msg.sender == tiles[x][y].owner)
    		tiles[x][y].owner = newowner;
    	return;
    }
    
    function setDescriptor(uint8 x, uint8 y, Descriptor newdescriptor)
    {
    	// WARNING: A check should be performed to make sure newdescriptor is a "contract" address, but it's not currently possible in Solidity.
    	if(msg.sender == tiles[x][y].owner)
    		tiles[x][y].descriptor = newdescriptor;
    	return;
    }
    
    // - getOwner of a tile - DONE
    // - getDescriptor of a tile - DONE
    // - getElevation of a tile - DONE
    // - getBlocks of a tile - DONE
        
    function getOwner(uint8 x, uint8 y) constant returns (address)
    {
    	return tiles[x][y].owner;
    }
    
    function getDescriptor(uint8 x, uint8 y) constant returns (address)
    {
    	return tiles[x][y].descriptor;
    }
    
    function getElevation(uint8 x, uint8 y) constant returns (uint8)
    {
    	return tiles[x][y].elevation;
    }
    
    function getBlocks(uint8 x, uint8 y) constant returns (uint8[136])
    {
    	return tiles[x][y].blocks;
    }
    
    // get Description of block layout from Descriptor
    function getDescription(uint8 x, uint8 y) returns(int16[13])
    {
    	Descriptor desc = tiles[x][y].descriptor;
    	int16[] description = desc.getDescription();
    	
    	// validate the description
    	// convert it to JSON
    	int16[13] returnarray;
    	//= {0,0,0,0,0,1,0,0,2,0,0,3,0};
    	return returnarray; // a single left-to-right bar in the middle of the tile 
    										// [w,x0,y0,z0,x1,y1,z1,x2,y2,z2,x3,y3,z3...]
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