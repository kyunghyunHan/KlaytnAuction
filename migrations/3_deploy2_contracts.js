const ImageNFTMarketplace = artifacts.require("ImageMarketplace");

module.exports = async function (deployer2, network, accounts) {
  await deployer2.deploy(ImageNFTMarketplace);
};
