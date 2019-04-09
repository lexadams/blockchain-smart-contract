pragma solidity >=0.5.0;

import "../contracts/Will.sol";
import "../node_modules/truffle/build/Assert.sol";

contract TestWill {
    
    function withdrawNotJack() public {
        Will will = new Will(1 ether, now, "hello", "world");
        will.withdraw();
    }
    
    function withdrawAfterDeadline() public {
        Will will = new Will(1 ether, now, "hello", "world");
        will.withdraw();
    }
    
    function withdrawInvalidPass() public {
        Will will = new Will(1 ether, now, "hello", "darkness my old friend");
        will.withdraw();
    }
    
    function testWithdraw() public {
        bool r;
        
        Assert.equal();

        (r, ) = address(this).call(abi.encodePacked(this.withdrawNotJack.selector));
        Assert.isFalse(r, "Expected not Jack");
        
        (r, ) = address(this).call(abi.encodePacked(this.withdrawAfterDeadline.selector));
        Assert.isFalse(r, "Expected after deadline");
        
        (r, ) = address(this).call(abi.encodePacked(this.withdrawInvalidPass.selector));
        Assert.isFalse(r, "Expected invalid password");
    }
    
}