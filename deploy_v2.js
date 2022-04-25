const { utils } = require("ethers");
const { ethers, upgrades } = require("hardhat");

async function main() {
    const baseTokenURI = "<<IPFS BASE URL>>";
    const proxyAddress = '<<ADDRESS OF THE PROXY>>';
    // Get owner/deployer's wallet address
    const [owner] = await hre.ethers.getSigners();

    // Get contract that we want to deploy
    const contractFactoryV2 = await hre.ethers.getContractFactory("NFTCollectibleV2");
	console.log("Deploying NFTCollectible Version 2...");
	
	//{Replace the below with upgrade.deploy} 
    // Deploy contract with the correct constructor arguments
   // const contract = await contractFactory.deploy(baseTokenURI); 
	const contract = await upgrades.upgradeProxy(proxyAddress,contractFactoryV2);
	 

    // Wait for this transaction to be mined
   // await contract.deployed();

    // Get contract address
    console.log("Contract upgraded to:", contract.address);

    // Reserve NFTs
   // let txn = await contract.reserveNFTs();
    //await txn.wait();
    //console.log("10 NFTs have been reserved");

    // Mint 3 NFTs by sending 0.03 ether
   // txn = await contract.mintNFTs(3, { value: utils.parseEther('0.03') });
    //await txn.wait()

    // Get all token IDs of the owner
    let tokens = await contract.tokensOfOwner(owner.address)
   console.log("Owner has tokens: ", tokens);

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
