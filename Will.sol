pragma solidity >=0.5.0;

contract Will {
    uint private amount;
    uint private deadline;
    string private attorneyPass;
    string private receiverPass;
    address private attorney;
    address payable private jack;
    address payable private ngo;
    
    // Ensure the caller is Jack.
    modifier jackOnly {
        require(msg.sender == jack, "Jack's address invalid");
        _;
    }
    
    // Ensure the caller is NGO.
    modifier ngoOnly {
        require(msg.sender == ngo, "NGO's address invalid");
        _;
    }

    /**
     * Create a new Will contract.
     * @param _amount The amount of ethers to transfer.
     * @param _deadline The deadline by which Jack must withdraw the ethers.
     * @param _attorneyPass The attorney's password part.
     * @param _receiverPpass Jack or the NGO's password part.
     */
    constructor(uint _amount, uint _deadline, string memory _attorneyPass, string memory _receiverPpass) payable public {
        amount = _amount;
        deadline = _deadline;
        attorneyPass = _attorneyPass;
        receiverPass = _receiverPpass;
        // TODO: Set up addresses.
    }
    
    /**
     * Transfers the account balance to Jack only is the deadline has not passed.
     * @dev Only jack can perform this operation.
     */
    function withdraw() jackOnly public {
        if (before(deadline) && valid(receiverPass)) {
            jack.transfer(amount);
        }
    }
    
    /**
     * Transfers the account balance to NGO and cancels the contract
     * only after the deadline has passed.
     * @dev Only the NGO can perform this operation.
     */
    function cancelWithdrawal() ngoOnly public {
        if (!before(deadline) && valid(receiverPass)) {
            ngo.transfer(amount);
            selfdestruct(ngo);
        }
    }
    
    /**
     * Reports whether the deadline has passed.
     * @param _deadline The deadline to compare against.
     * @return True if the current time is later than the deadline.
     */
    function before(uint _deadline) view private returns(bool) {
        return now > _deadline;
    }

    /**
     * Check if the given password part is valid.
     * @param _receriverPass Jack or the NGO's password part.
     * @return True if the given password part combined with the attorney's
     * password part matches the master password.
     */
    function valid(string _receiverPass) view private returns(bool) {
        // TODO: check valid password
        // attorneyPass + _receiverPass == masterPass
        return false;
    }
}
