// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import 
'https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary/blob/master/contracts/BokkyPooBahsDateTimeLibrary.sol';

interface IBEP20 {
    function transfer(address _to, uint256 _value) external returns 
(bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Savings {

    address public token;
    address public owner;
    uint256 public withdrawAmount;
    uint256 public lastWithdraw;

    constructor () {
        token = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56; // BUSD smart 
contract
        owner = msg.sender;
        withdrawAmount = 10;
        lastWithdraw = 0;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "!Owner");
        _;
    }

    modifier canWithdraw {
        bool isLocked = false;
        uint256 _lastWithdraw = lastWithdraw;
        if ( _lastWithdraw != 0 ) {
            uint256 _currentMonth = 
BokkyPooBahsDateTimeLibrary.getMonth(block.timestamp);
            uint256 _lastMonth = 
BokkyPooBahsDateTimeLibrary.getMonth(_lastWithdraw);
            isLocked = _currentMonth == _lastMonth;
        }
        require(!isLocked, "Locked.");
        _;
    }

    function withdraw() external onlyOwner canWithdraw {
        IBEP20(token).transfer(owner, withdrawAmount);
        lastWithdraw = block.timestamp;
    }

    function getWealth() external view onlyOwner returns (uint256) {
        uint256 _balance = IBEP20(token).balanceOf(address(this));
        return _balance / withdrawAmount;
    }

    function setWithdrawAmount(uint256 _amount) external onlyOwner {
        withdrawAmount = _amount;
    }

    function setLastWithdraw(uint256 _lastWithdraw) external onlyOwner {
        lastWithdraw = _lastWithdraw;
    }
}
