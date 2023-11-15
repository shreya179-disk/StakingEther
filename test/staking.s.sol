// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

import "src/Staking.sol";
  


// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite {

    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        // <instantiate contract>
       assert.equal(uint(1), uint(1), "1 should be equal to 1");
    }

    function checkSuccess() public {
        
        assert.ok(2 == 2, 'should be true');
        assert.greaterThan(uint(2), uint(1), "2 should be greater than to 1");
        assert.lesserThan(uint(2), uint(3), "2 should be lesser than to 3");
    }

    function checkSuccess2() public pure returns (bool) {
        // Use the return value (true or false) to test the contract
        return true;
    }
    
    function checkFailure() public {
        assert.notEqual(uint(1), uint(1), "1 should not be equal to 1");
    }

    
    /// #sender: account-1
    /// #value: 100
    function checkSenderAndValue() public payable {
        // account index varies 0-9, value is in wei
       assert.equal(msg.sender, TestsAccounts.getAccount(1), "Invalid sender");
      assert.equal(msg.value, 100, "Invalid value");
    }
}
    