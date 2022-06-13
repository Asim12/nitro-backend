const {expect}      =   require("chai");
const { concat }    =   require("ethers/lib/utils");
const {ethers}      =   require("hardhat");
const web3          =   require("web3")
require("@nomiclabs/hardhat-waffle");
describe("Working on withdraw function unit test", async() => {
    it('Widthraw function testing', async() => {
        const [owner]    = await ethers.getSigners();
        console.log('Owner of the contract is ', owner.address);
        const NFT = await ethers.getContractFactory("NFT");
        const nft = await NFT.deploy(
            "MyTest",
            "TST",
            "ipfs://QmXBjRRgHf8FEaJupiM3o7ttkzv6CTmuHq1iFXktDG1FBD/",
            "0x9642617Bbbd552FA363e04CD082703Be403fC25B" ,
            "1000" 
        );
        const contract = await nft.deployed();
        console.log("Contract deployed at:", contract.address);
        const widthrawFunctionTest = await contract.withdraw()
        console  
        expect(widthrawFunctionTest.confirmations).to.equal(1)
    });

    it('Mint function testing', async() => {
        const NFT = await ethers.getContractFactory("NFT");
        const nft = await NFT.deploy(
            "MyTest",
            "TST",
            "ipfs://QmXBjRRgHf8FEaJupiM3o7ttkzv6CTmuHq1iFXktDG1FBD/",
            "0x9642617Bbbd552FA363e04CD082703Be403fC25B" ,
            "1000" 
        );
        const contract = await nft.deployed();
        console.log("Contract deployed at:", contract.address);
        const mintNFT = await contract.createToken({value: web3.utils.toWei("0.025", "ether")})
        console.log('widthrawFunctionTest', mintNFT)
        expect(mintNFT.confirmations).to.equal(1)
    });

    it('Max Supply testing', async() => {
        const NFT = await ethers.getContractFactory("NFT");
        const nft = await NFT.deploy(
            "MyTest",
            "TST",
            "ipfs://QmXBjRRgHf8FEaJupiM3o7ttkzv6CTmuHq1iFXktDG1FBD/",
            "0x9642617Bbbd552FA363e04CD082703Be403fC25B" ,
            "1000"  
        );
        const contract = await nft.deployed();
        console.log('contract owner is ', contract.address);
        const getMaxSupply = await contract.getMaxLaunchpadSupply();
        console.log('Total max Supply are ', getMaxSupply)
        expect(getMaxSupply).to.equal(1000)
    });

    it('Current token id get', async() => {
        const NFT = await ethers.getContractFactory("NFT");
        const nft = await NFT.deploy(
            "MyTest",
            "TST",
            "ipfs://QmXBjRRgHf8FEaJupiM3o7ttkzv6CTmuHq1iFXktDG1FBD/",
            "0x9642617Bbbd552FA363e04CD082703Be403fC25B" ,
            "1000"   
        );
        const contract = await nft.deployed();
        console.log('contract owner is ', contract.address);
        const getCurrentTokenCount = await contract.getLaunchpadSupply();
        console.log("get current token count", getCurrentTokenCount);
        expect(getCurrentTokenCount).to.equal(0);
    });
})
