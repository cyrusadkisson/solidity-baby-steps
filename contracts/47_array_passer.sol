pragma solidity ^0.4.22;

contract Mortal {
  /* Define variable owner of the type address */
  address owner;

  /* This constructor is executed at initialization and sets the owner of the contract */
  constructor() public { owner = msg.sender; }

  /* Function to recover the funds on the contract */
  function kill() public { if (msg.sender == owner) selfdestruct(msg.sender); }
}

// contract Descriptor {

// 	function getDescription() constant returns (uint16[3]){
// 		uint16[3] somevar;
// 		return somevar;
// 	}
// }

contract ArrayPasser is Mortal {

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
        uint8 elevation;
        //Descriptor descriptor;
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
}
