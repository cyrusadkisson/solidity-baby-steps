contract Descriptor {
    
	function getDescription() constant returns (int16[10]){	
		int16[10] somevar;
		somevar[0] = 0; somevar[1] = 1; somevar[2] = 2; somevar[3] = 3; somevar[4] = 4;
		somevar[5] = 5; somevar[6] = 6; somevar[7] = 7; somevar[8] = 8; somevar[9] = 9; 
		return somevar;
	}
}

contract ArrayPasser {

    address creator;
    
    /***
     * 1. Declare a 9x9 map of Tiles
     ***/
    uint8 mapsize = 9;
    Tile[9][9] tiles; 

    struct Tile 
    {
        /***
         * 2. A tile is comprised of the owner, elevation and a pointer to a 
         *      contract that explains what the tile looks like
         ****/
        address owner;
        uint8 elevation;
        Descriptor descriptor;
    }
    
    /***
     * 3. Upon construction, initialize the internal map elevations.
     *      The Descriptors start uninitialized.
     ***/
    function ArrayPasser(uint8[] incmap) 
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
    
   /*** 
    * 4. get Description of a tile at x,y
    ***/ 
    function getTileDescription(uint8 x, uint8 y)
    {
    	Descriptor desc = tiles[x][y].descriptor;       // get the descriptor for this tile
    	int16[10] memory description = desc.getDescription();  // get the description from the descriptor *** THIS IS THE PROBLEMATIC LINE ***
    	
    	// TODO validate the description
    	// TODO convert it to JSON
    	// save it to a variable for constant retrieval elsewhere
    	
    	return; 
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