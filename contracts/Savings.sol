// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

interface IBEP20 {
    function transfer(address _to, uint256 _value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Savings {

    address public token;
    address public owner;
    uint256 public withdrawAmount;
    uint256 public lockedUntil;

    constructor () {
        // BUSD smart contract
        // (TestNet: 0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee)
        // (MainNet: 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56)
        token = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
        owner = msg.sender;
        withdrawAmount = 1;
        lockedUntil = 0;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "!Owner");
        _;
    }

    modifier canWithdraw {
        bool isLocked = false;
        uint256 _lockedUntil = lockedUntil;
        if ( _lockedUntil != 0 ) {
            isLocked = block.timestamp < _lockedUntil;
        }
        require(!isLocked, "Locked.");
        _;
    }

    function withdraw() external onlyOwner canWithdraw {
        uint256 _wei = toWei(withdrawAmount);
        IBEP20(token).transfer(owner, _wei);
        lockedUntil = block.timestamp + 30 days;
    }

    function getBalance() external view returns (uint256) {
        uint256 _wei = IBEP20(token).balanceOf(address(this));
        return toUsd(_wei);
    }

    function getWealth() external view returns (uint256) {
        uint256 _wei = IBEP20(token).balanceOf(address(this));
        return toUsd(_wei) / withdrawAmount;
    }

    function setWithdrawAmount(uint256 _amount) external onlyOwner {
        withdrawAmount = _amount;
    }

    function setLockedUntil(uint256 _lockedUntil) external onlyOwner {
        lockedUntil = _lockedUntil;
    }

    function toWei(uint256 _amount) internal pure returns (uint256) {
        return _amount * 10**18;
    }

    function toUsd(uint256 _amount) internal pure returns (uint256) {
        return _amount / 10**18;
    }
}
