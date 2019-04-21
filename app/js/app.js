const Promise = require("bluebird");
const truffleContract = require("truffle-contract");
const $ = require("jquery");

// Not to forget our built contract
const willJSON = require("../../build/contracts/Will.json");
require("file-loader?name=../index.html!../index.html");

const Web3 = require('web3');
// Supports Mist, and other wallets that provide 'web3'.
if (typeof web3 !== 'undefined') {
  // Use the Mist/wallet/Metamask provider.
  window.web3 = new Web3(web3.currentProvider);
} else {
  // Your preferred fallback.
  window.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
}

// Make a new contract object with the recepient's address.
const accountAddr = document.getElementById('AccountAddress').value;
var WillContract = new web3.eth.Contract(willJSON.abi, accountAddr);

// Deploy the contract with the deadline of 04/29/2019.
WillContract.deploy({
  data: willJSON.bytecode,
  arguments: [
    web3.eth.accounts[1],                              // Mr. Mark's account.
    web3.eth.accounts[2],                              // The NGO's account.
    web3.eth.accounts[3],                              // Jack's account.
    1000,                                              // The amount of ether to transfer.
    1556577099,                                        // Jack's withdrawal deadline unix timestamp (04/29/2019).
    document.getElementById('AttorneyPassword').value, // The attorney's password part.
    document.getElementById('Password').value          // Jack's password part.
  ]
});

web3.eth.getTransactionReceiptMined = require("./utils.js");
function sequentialPromise(promiseArray) {
  const result = promiseArray.reduce(
    (reduced, promise, index) => {
      reduced.results.push(undefined);
      return {
        chain: reduced.chain
          .then(() => promise)
          .then(result => reduced.results[index] = result),
        results: reduced.results
      };
    },
    {
      chain: Promise.resolve(),
      results: []
    });
  return result.chain.then(() => result.results);
}

sequentialPromise([
  Promise.resolve(web3.eth), Promise.resolve({ suffix: "Promise" })
]).then(console.log);

web3.eth.getAccountsPromise = function () {
  return new Promise(function (resolve, reject) {
    web3.eth.getAccounts(function (e, accounts) {
      if (e != null) {
        reject(e);
      } else {
        resolve(accounts);
      }
    });
  });
};

const Will = truffleContract(willJSON);
Will.setProvider(web3.currentProvider);
window.addEventListener('load', function () {
  $("button#withdraw").click(withdraw);
  return Will.deployed()
});

// Function that will be executed when button is pressed.
const withdraw = function () {
  WillContract.methods.withdraw().send({from: accountAddr}, function(error, transactionHash) {
    if (error !== null) {
      alert('Could not withdraw: ' + error);
    } else {
      alert('Success! Transaction Hash: ' + transactionHash);
    }
  });
};
