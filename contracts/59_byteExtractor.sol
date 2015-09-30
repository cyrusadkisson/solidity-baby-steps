/***
 *     _    _  ___  ______ _   _ _____ _   _ _____ 
 *    | |  | |/ _ \ | ___ \ \ | |_   _| \ | |  __ \
 *    | |  | / /_\ \| |_/ /  \| | | | |  \| | |  \/
 *    | |/\| |  _  ||    /| . ` | | | | . ` | | __ 
 *    \  /\  / | | || |\ \| |\  |_| |_| |\  | |_\ \
 *     \/  \/\_| |_/\_| \_\_| \_/\___/\_| \_/\____/
 *                                                 
 *   This contract DOES NOT WORK. It was/is an experiment
 *   to try and manually convert a fixed byte array (e.g. byte4)
 *   into byte[4] using hard maths. A strange thing happened: 
 *   Filling the byte[4] array doesn't work. See below. 9/20/2015
 *                                
 */

contract ByteExtractor {

    address creator;

    function ByteExtractor() {
        creator = msg.sender;
    }
    
    function getByteFromByte8(bytes8 _b8, uint8 byteindex) public constant returns(byte) {
    	uint numdigits = 16;
    	uint buint = uint(_b8);
    	uint upperpowervar = 16 ** (numdigits - (byteindex*2)); 		// @i=0 upperpowervar=16**64, @i=1 upperpowervar=16**62, @i upperpowervar=16**60
    	uint lowerpowervar = 16 ** (numdigits - 2 - (byteindex*2));		// @i=0 upperpowervar=16**62, @i=1 upperpowervar=16**60, @i upperpowervar=16**58
    	uint postheadchop = buint % upperpowervar; 				// @i=0 _b32=a1b2c3d4... postheadchop=a1b2c3d4, @i=1 postheadchop=b2c3d4, @i=2 postheadchop=c3d4
    	uint remainder = postheadchop % lowerpowervar; 			// @i=0 remainder=b2c3d4, @i=1 remainder=c3d4, @i=2 remainder=d4
    	uint evenedout = postheadchop - remainder; 				// @i=0 evenedout=a1000000, @i=1 remainder=b20000, @i=2 remainder=c300
    	uint b = evenedout / lowerpowervar; 					// @i=0 b=a1, @i=1 b=b2, @i=2 b=c3
    	return byte(b);
    }
    
    function getByteFromByte32(bytes32 _b32, uint8 byteindex) public constant returns(byte) {
    	uint numdigits = 64;
    	uint buint = uint(_b32);
    	uint upperpowervar = 16 ** (numdigits - (byteindex*2)); 		// @i=0 upperpowervar=16**64 (SEE EXCEPTION BELOW), @i=1 upperpowervar=16**62, @i upperpowervar=16**60
    	uint lowerpowervar = 16 ** (numdigits - 2 - (byteindex*2));		// @i=0 upperpowervar=16**62, @i=1 upperpowervar=16**60, @i upperpowervar=16**58
    	uint postheadchop;
    	if(byteindex == 0)
    		postheadchop = buint; 								//for byteindex 0, buint is just the input number. 16^64 is out of uint range, so this exception has to be made.
    	else
    		postheadchop = buint % upperpowervar; 				// @i=0 _b32=a1b2c3d4... postheadchop=a1b2c3d4, @i=1 postheadchop=b2c3d4, @i=2 postheadchop=c3d4
    	uint remainder = postheadchop % lowerpowervar; 			// @i=0 remainder=b2c3d4, @i=1 remainder=c3d4, @i=2 remainder=d4
    	uint evenedout = postheadchop - remainder; 				// @i=0 evenedout=a1000000, @i=1 remainder=b20000, @i=2 remainder=c300
    	uint b = evenedout / lowerpowervar; 					// @i=0 b=a1, @i=1 b=b2, @i=2 b=c3
    	return byte(b);
    }
    
    function getDigitFromByte32(bytes32 _b32, uint8 index) public constant returns(uint) {
    	uint numdigits = 64;
    	uint buint = uint(_b32);
    	uint upperpowervar = 16 ** (numdigits - index); 		// @i=0 upperpowervar=16**64, @i=1 upperpowervar=16**63, @i upperpowervar=16**62
    	uint lowerpowervar = 16 ** (numdigits - 1 - index);		// @i=0 upperpowervar=16**63, @i=1 upperpowervar=16**62, @i upperpowervar=16**61
    	uint postheadchop = buint % upperpowervar; 				// @i=0 _b32=a1b2c3d4... postheadchop=a1b2c3d4, @i=1 postheadchop=b2c3d4, @i=2 postheadchop=c3d4
    	uint remainder = postheadchop % lowerpowervar; 			// @i=0 remainder=b2c3d4, @i=1 remainder=c3d4, @i=2 remainder=d4
    	uint evenedout = postheadchop - remainder; 				// @i=0 evenedout=a1000000, @i=1 remainder=b20000, @i=2 remainder=c300
    	uint b = evenedout / lowerpowervar; 					// @i=0 b=a1, @i=1 b=b2, @i=2 b=c3
    	return b;
    }
    
    function getDigitFromUint(uint buint, uint8 index) public constant returns(uint) {
    	uint numdigits = 64;
    	uint upperpowervar = 10 ** (numdigits - index); 		// @i=0 upperpowervar=16**64, @i=1 upperpowervar=16**63, @i upperpowervar=16**62
    	uint lowerpowervar = 10 ** (numdigits - 1  -index);		// @i=0 upperpowervar=16**63, @i=1 upperpowervar=16**62, @i upperpowervar=16**61
    	uint postheadchop = buint % upperpowervar; 				// @i=0 _b32=a1b2c3d4... postheadchop=a1b2c3d4, @i=1 postheadchop=b2c3d4, @i=2 postheadchop=c3d4
    	uint remainder = postheadchop % lowerpowervar; 			// @i=0 remainder=b2c3d4, @i=1 remainder=c3d4, @i=2 remainder=d4
    	uint evenedout = postheadchop - remainder; 				// @i=0 evenedout=a1000000, @i=1 remainder=b20000, @i=2 remainder=c300
    	uint b = evenedout / lowerpowervar; 					// @i=0 b=a1, @i=1 b=b2, @i=2 b=c3
    	return b;
    }
    
    /**********
     Standard kill() function to recover funds 
     **********/

    function kill() {
        if (msg.sender == creator) {
            suicide(creator); // kills this contract and sends remaining funds back to creator
        }
    }
}