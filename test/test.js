// truffle test debug --network goerli_fork test/test.js

const IERC20 = artifacts.require("IERC20");
const ExerciceSolution = artifacts.require("ExerciceSolution");

contract("ExerciceSolution", (accounts)=>{

    //const TOKEN_IN = "0x3a739647Cd105BB07eC9918A88D6E5DdA9D4898b"; // myToken

    const TOKEN_IN = "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6" // weth on goerli
    const TOKEN_OUT = "0x2aF483edaE4cce53186E6ed418FE92f8169Ad74E"; // dummyToken

    const AMOUNT_IN = web3.utils.toWei('0.01', 'ether'); // 10**18
    console.log(AMOUNT_IN);
    // const AMOUNT_IN = 1000;
    const AMOUNT_OUT_MIN = 1;

    const WHALE = "0x589563701c2270930f57fdCaa84aEdCBb891622A"; // from address but with ganache-cli unlock, can use all accounts I want
    const TO = "0x589563701c2270930f57fdCaa84aEdCBb891622A" // accounts[0]; // ganache account

    it("Should swap eth", async () => {

        const tokenIn = await IERC20.at(TOKEN_IN);
        const tokenOut = await IERC20.at(TOKEN_OUT);
        const exerciceSolution = await ExerciceSolution.new();

        await tokenIn.approve(exerciceSolution.address, AMOUNT_IN,  {from: WHALE});

        console.log(`before ${await tokenOut.balanceOf(TO)}`); // balance before swap
        console.log(`before ${await tokenIn.balanceOf(WHALE)}`);

        // await exerciceSolution.swapYourTokenForEth();
        await exerciceSolution.swap(
           tokenIn.address,
           tokenOut.address,
           AMOUNT_IN,
           AMOUNT_OUT_MIN,
           TO,
           {
            from: WHALE,
           }
        );

        console.log()

        const after_1 = await tokenOut.balanceOf(TO);
        console.log(parseFloat(web3.utils.fromWei(after_1, 'ether')).toFixed(3));

        const after_2 = await tokenIn.balanceOf(TO);
        console.log(parseFloat(web3.utils.fromWei(after_2, 'ether')).toFixed(3));

        console.log()
        console.log(`after ${await tokenOut.balanceOf(TO)}`); // balance after swap
        console.log(`after ${await tokenIn.balanceOf(WHALE)}`);
    });
});