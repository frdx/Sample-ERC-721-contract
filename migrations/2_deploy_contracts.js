const ERC721Contract = artifacts.require("ERC721Contract");

module.exports = async function (deployer) {
 await deployer.deploy(ERC721Contract);
};
