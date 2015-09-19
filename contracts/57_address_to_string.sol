/***
 *     _    _  ___  ______ _   _ _____ _   _ _____ 
 *    | |  | |/ _ \ | ___ \ \ | |_   _| \ | |  __ \
 *    | |  | / /_\ \| |_/ /  \| | | | |  \| | |  \/
 *    | |/\| |  _  ||    /| . ` | | | | . ` | | __ 
 *    \  /\  / | | || |\ \| |\  |_| |_| |\  | |_\ \
 *     \/  \/\_| |_/\_| \_\_| \_/\___/\_| \_/\____/
 *                                                 
 *   This contract DOES NOT WORK. It was/is an experiment
 *   to see if I could convert an address into its string equivalent. 
 *   (I couldn't because string concatenation is not implemented yet.)                                     
 */

contract Bytes2String {

    address creator;

    function Bytes2String() {
        creator = msg.sender;
    }

    function toString(address _a) public constant returns(string) {
        bytes20 b = bytes20(_a);
        uint128 bprime = uint128(b);
        uint x = 0;
        uint head = 0;
        uint prevhead = 0;
        uint tail = 0;
        uint digit = 0;
        byte[20] accumulator;
        while (x < 20) {
            tail = bprime % 16 * * (20 - x);
            digit = ((bprime - prevhead) - tail) / 16 * * (20 - x);
            //	accumulator = accumulator + getChar(digit);
            if (digit == 0)
                accumulator[x] = "0";
//            else if (digit == 1)
//                accumulator = accumulator + "1;
//            else if (digit == 2)
//                accumulator = accumulator + "2";
//            else if (digit == 3)
//                accumulator = accumulator + "3;
//            else if (digit == 4)
//                accumulator = accumulator + "4;
//            else if (digit == 5)
//                accumulator = accumulator + "5;
//            else if (digit == 6)
//                accumulator = accumulator + "6;
//            else if (digit == 7)
//                accumulator = accumulator + "7;
//            else if (digit == 8)
//                accumulator = accumulator + "8;
//            else if (digit == 9)
//                accumulator = accumulator + "9;
//            else if (digit == 0xa)
//                accumulator = accumulator + "a;
//            else if (digit == 0xb)
//                accumulator = accumulator + "b;
//            else if (digit == 0xc)
//                accumulator = accumulator + "c;
//            else if (digit == 0xd)
//                accumulator = accumulator + "d;
//            else if (digit == 0xe)
//                accumulator = accumulator + "e;
//            else if (digit == 0xf)
//                accumulator = accumulator + "f;
            prevhead = b - tail;
            x++;
        }
        return accumulator;
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