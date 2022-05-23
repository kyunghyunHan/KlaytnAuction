const Tickets = artifacts.require("Tickets");

module.exports = async function (deployer3, network, accounts) {
  await deployer3.deploy(Tickets);
};
