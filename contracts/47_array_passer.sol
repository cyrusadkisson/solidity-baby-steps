/***
 *     _    _  ___  ______ _   _ _____ _   _ _____ 
 *    | |  | |/ _ \ | ___ \ \ | |_   _| \ | |  __ \
 *    | |  | / /_\ \| |_/ /  \| | | | |  \| | |  \/
 *    | |/\| |  _  ||    /| . ` | | | | . ` | | __ 
 *    \  /\  / | | || |\ \| |\  |_| |_| |\  | |_\ \
 *     \/  \/\_| |_/\_| \_\_| \_/\___/\_| \_/\____/
 *                                                 
 *   This contract DOES NOT WORK                                   
 */

contract Descriptor {
    
	function getDescription() constant returns (uint16[3]){	
		uint16[3] somevar;
		somevar[0] = 34;
		somevar[1] = 76;
		somevar[2] = 48;
		return somevar;
	}
}

contract ArrayPasser {

    address creator;
    
    /***
     * 1. Declare a 3x3 map of Tiles
     ***/
    uint8 mapsize = 3;
    Tile[3][3] tiles; 

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
    function ArrayPasser(uint8[9] incmap) 
    {
        creator = msg.sender;
        uint8 counter = 0;
        for(uint8 y = 0; y < mapsize; y++)
       	{
           	for(uint8 x = 0; x < mapsize; x++)
           	{
           		tiles[x][y].elevation = incmap[counter]; 
           		counter = counter + 1;
           	}	
        }	
    }
   
    /***
     * 4. After contract mined, check the map elevations
     ***/
    function getElevations() constant returns (uint8[3][3])
    {
        uint8[3][3] memory elevations;
        for(uint8 y = 0; y < mapsize; y++)
        {
        	for(uint8 x = 0; x < mapsize; x++)
        	{
        		elevations[x][y] = tiles[x][y].elevation; 
        	}	
        }	
    	return elevations;
    }
   
   /***
     * 5. Load descriptors
     ***/
     
    function loadDescriptors() 
    {
        Descriptor d = new Descriptor();
        for(uint8 y = 0; y < mapsize; y++)
       	{
           	for(uint8 x = 0; x < mapsize; x++)
           	{
           	    tiles[x][y].descriptor = d;
           	}	
        }	
    } 
    
   /*** 
    * 6. get Description of a tile at x,y
    ***/ 
    uint16[3] anothervar;
    function getTileDescription(uint8 x, uint8 y)
    {
    	Descriptor desc = tiles[x][y].descriptor;       // get the descriptor for this tile
    	anothervar = desc.getDescription();  // get the description from the descriptor
    	
    	// TODO validate the description
    	// TODO convert it to JSON
    	// save it to a variable for constant retrieval elsewhere
    	
    	return; 
    }
    
    /*** 
    * 7. retrieve it
    ***/ 
    
    function retrieveAnothervar() constant returns (uint16[3])
    {
        return anothervar;
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