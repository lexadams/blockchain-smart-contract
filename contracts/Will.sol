pragma solidity >=0.5.0;

/**
 * CSC 4700 Project 1
 *
 * @author Mason Walton, Michael Christian, Lex Adams
 */
contract Will {
    uint private amount;           // The amount of ether to transfer to the recipient.
    uint private deadline;         // The deadline by which Jack must withdraw the ethers.
    address payable private ngo;   // The NGO's address.
    address payable private jack;  // Jack's address.
  	bytes32 private attorneyPass;  // The attorney's password part.
    bytes32 private recipientPass; // The recipient's password part.
    
    // Ensure the sender is Jack.
    modifier onlyJack {
      	require(msg.sender == jack, "Sender must be Jack");
        _;
    }
    
    // Ensure the sender is NGO.
    modifier onlyNGO {
      	require(msg.sender == ngo, "Sender must be NGO");
        _;
    }
  
  	// Ensure it is before the deadline.
    modifier beforeDeadline {
      	require(now < deadline, "Must be before deadline");
        _;
    }
  
  	// Ensure it is after the deadline.
    modifier afterDeadline {
      	require(now >= deadline, "Must be after deadline");
        _;
    }
  
  	// Ensure the password parts are valid.
    modifier validPass {
      	require(attorneyPass == "hello", "Invalid attorney password");
      	require(recipientPass == "world", "Invalid recipient password");
    	_;
    }

    /**
     * Create a new Will contract.
     * @param _ngo The NGO's address.
     * @param _jack Jack's address.
     * @param _amount The amount of ethers to transfer.
     * @param _deadline The deadline by which Jack must withdraw the ethers.
     * @param _attorneyPass The attorney's password part.
     * @param _recipientPass Jack or the NGO's password part.
     */
    constructor(address payable _ngo, address payable _jack, uint _amount, uint _deadline, bytes32 _attorneyPass, bytes32 _recipientPass) public payable {
        ngo = _ngo;
        jack = _jack;
        amount = _amount;
        deadline = _deadline;
        attorneyPass = _attorneyPass;
        recipientPass = _recipientPass;
    }
    
    /**
     * Transfers the account balance to Jack.
     *
     * @dev Only Jack can perform this operation, and only if it is before the
     * deadline and his password part is valid.
     */
    function withdraw() public payable onlyJack beforeDeadline validPass {
        jack.transfer(amount);
    }
    
    /**
     * Transfers the account balance to NGO and cancels the contract.
     *
     * @dev Only the NGO can perform this operation, and only if it is after the
     * deadline and their password part is valid.
     */
    function cancelWithdraw() public payable onlyNGO afterDeadline validPass {
        ngo.transfer(amount);
        selfdestruct(ngo);
    }
}
