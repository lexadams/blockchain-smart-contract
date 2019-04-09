pragma solidity >=0.5.0;

/**
 * CSC 4700 Project 1
 *
 * @author Mason Walton, Michael Christian, Lex Adams
 */
contract Will {
    uint private amount;           // The amount of ether to transfer to the receiver.
    uint private deadline;         // The deadline for Jack to withdraw the ethers.
    address private attorney;      // The attorney's address.
    address payable private jack;  // Jack's address.
    address payable private ngo;   // The NGO's address.
  	bytes32 private attorneyPass;  // The attorney's password part.
    bytes32 private recipientPass; // The recipient's password part.
    
    // Ensure the caller is Jack.
    modifier jackOnly {
      	require(msg.sender == jack, "Permission Denied: Must be Jack");
        _;
    }
    
    // Ensure the caller is NGO.
    modifier ngoOnly {
      	require(msg.sender == ngo, "Permission Denied: Must be NGO");
        _;
    }
  
  	// Ensure it is before the deadline.
    modifier beforeDeadline {
      	require(deadline > now, "Permission Denied: After deadline");
        _;
    }
  
  	// Ensure it is after the deadline.
    modifier afterDeadline {
      	require(now > deadline, "Permission Denied: Before deadline");
        _;
    }
  
  	// Ensure the password parts are valid.
    modifier validPass {
      	require(attorneyPass == "hello", "Permission Denied: Invalid attorney password part");
      	require(recipientPass == "world", "Permission Denied: Invalid recipient password part");
    	_;
    }

    /**
     * Create a new Will contract.
     * @param _amount The amount of ethers to transfer.
     * @param _deadline The deadline by which Jack must withdraw the ethers.
     * @param _attorneyPass The attorney's password part.
     * @param _recipientPass Jack or the NGO's password part.
     */
    constructor(uint _amount, uint _deadline, bytes32 _attorneyPass, bytes32 _recipientPass) payable public {
        amount = _amount;
        deadline = _deadline;
        attorneyPass = _attorneyPass;
        recipientPass = _recipientPass;
        // TODO: Set up addresses.
    }
    
    /**
     * Transfers the account balance to Jack only is the deadline has not passed.
     * @dev Only jack can perform this operation.
     */
    function withdraw() jackOnly beforeDeadline validPass public {
    	jack.transfer(amount);
    }
    
    /**
     * Transfers the account balance to NGO and cancels the contract
     * only after the deadline has passed.
     * @dev Only the NGO can perform this operation.
     */
    function cancelWithdraw() ngoOnly afterDeadline validPass public {
    	ngo.transfer(amount);
        selfdestruct(ngo);
    }
}
