const Promise = require("bluebird");
const truffleContract = require("truffle-contract");
const $ = require("jquery");

// Not to forget our built contract
const willJson = require("../../build/contracts/Will.json");
require("file-loader?name=../index.html!../index.html");
import Web3 from 'web3';

// Supports Mist, and other wallets that provide 'web3'.
if (typeof web3 !== 'undefined') {
  // Use the Mist/wallet/Metamask provider.
  window.web3 = new Web3(web3.currentProvider);
} else {
  // Your preferred fallback.
  window.web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
}

// Make a new contract object with the recepient's address.
var Contract = new web3.eth.Contract(Will.json, document.getElementById('AccountAddress').value);

// Deploy the contract with the deadline of 04/29/2019.
Contract.deploy(web3.eth.accounts[1], web3.eth.accounts[2], web3.eth.accounts[3], 1000, 1556577099, document.getElementById('AttorneyPassword').value, document.getElementById('Password').value);


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

const Will = truffleContract(willJson);
Will.setProvider(web3.currentProvider);
window.addEventListener('load', function () {
  //vote is button id, votefunc is the function that will be executed when button is pressed
  $("button#will").click(willfunc);
  return Will.deployed()
});

//Function that will be executed when button is pressed
const willfunc = function () {
  alert("deez nuts");
  console.log("button was clicked");
};
