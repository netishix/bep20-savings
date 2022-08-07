const Savings = artifacts.require("Savings");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("Savings", function (/* accounts */) {
  it("should assert true", async function () {
    await Savings.deployed();
    return assert.isTrue(true);
  });
});
