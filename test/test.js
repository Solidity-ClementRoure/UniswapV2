// truffle test debug --network goerli_fork test/test.js

const IERC20 = artifacts.require("IERC20");
const ExerciceSolution = artifacts.require("ExerciceSolution");

contract("ExerciceSolution", (accounts)=>{

    const MY_TOKEN = "0x3a739647Cd105BB07eC9918A88D6E5DdA9D4898b"; // myToken

    const TOKEN_IN = "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6" // weth on goerli
    const TOKEN_OUT = "0x2aF483edaE4cce53186E6ed418FE92f8169Ad74E"; // dummyToken

    const AMOUNT_IN = web3.utils.toWei('10', 'ether'); // 10**18
    console.log(AMOUNT_IN);
    // const AMOUNT_IN = 1000;
    const AMOUNT_OUT_MIN = 1;

    const WHALE = "0x589563701c2270930f57fdCaa84aEdCBb891622A"; // from address but with ganache-cli unlock, can use all accounts I want
    const TO = "0x589563701c2270930f57fdCaa84aEdCBb891622A" // accounts[0]; // ganache account

    // it("Should swap eth", async()=>{

    //     const myTokenAddress = "0x3a739647Cd105BB07eC9918A88D6E5DdA9D4898b" 
    //     const wethAddress = "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6"

    //     const tokenIn = await IERC20.at(myTokenAddress);
    //     const tokenOut = await IERC20.at(wethAddress);
    //     const exerciceSolution = await ExerciceSolution.new();

    //     await tokenIn.approve(exerciceSolution.address, AMOUNT_IN,  {from: WHALE});

    //     const before_1 = await tokenOut.balanceOf(TO);
    //     console.log(parseFloat(web3.utils.fromWei(before_1, 'ether')).toFixed(3));
    //     const before_2 = await tokenIn.balanceOf(TO);
    //     console.log(parseFloat(web3.utils.fromWei(before_2, 'ether')).toFixed(3));

    //     // await exerciceSolution.swapYourTokenForEth();
    //     await exerciceSolution.swapYourTokenForEth(
    //         {
    //         from: WHALE,
    //         }
    //     );

    //     console.log()

    //     const after_1 = await tokenOut.balanceOf(TO);
    //     console.log(parseFloat(web3.utils.fromWei(after_1, 'ether')).toFixed(3));

    //     const after_2 = await tokenIn.balanceOf(TO);
    //     console.log(parseFloat(web3.utils.fromWei(after_2, 'ether')).toFixed(3));
    // });

    // it("Should swap dummy token", async()=>{

    //     const amount = web3.utils.toWei('1000', 'ether'); // 10**18

    //     const myTokenAddress = "0x3a739647Cd105BB07eC9918A88D6E5DdA9D4898b" ;
    //     const dummyAddress = "0x2aF483edaE4cce53186E6ed418FE92f8169Ad74E";

    //     const tokenIn = await IERC20.at(myTokenAddress);
    //     const tokenOut = await IERC20.at(dummyAddress);
    //     const exerciceSolution = await ExerciceSolution.new();

    //     await tokenIn.approve(exerciceSolution.address, amount,  {from: WHALE}); // this isnt called when on testnet

    //     const before_1 = await tokenOut.balanceOf(TO);
    //     console.log(parseFloat(web3.utils.fromWei(before_1, 'ether')).toFixed(3));
    //     const before_2 = await tokenIn.balanceOf(TO);
    //     console.log(parseFloat(web3.utils.fromWei(before_2, 'ether')).toFixed(3));

    //     // await exerciceSolution.swapYourTokenForEth();
    //     await exerciceSolution.swapYourTokenForEth(
    //         {
    //         from: WHALE,
    //         }
    //     );

    //     console.log()

    //     const after_1 = await tokenOut.balanceOf(TO);
    //     console.log(parseFloat(web3.utils.fromWei(after_1, 'ether')).toFixed(3));

    //     const after_2 = await tokenIn.balanceOf(TO);
    //     console.log(parseFloat(web3.utils.fromWei(after_2, 'ether')).toFixed(3));
    // });

    it("Should add liquidity", async () => {

        const exerciceSolution = await ExerciceSolution.new();

        const _weth = await IERC20.at(TOKEN_IN);
        await _weth.approve(exerciceSolution.address, web3.utils.toWei('0.01', 'ether'),  {from: WHALE});

        const myToken = await IERC20.at(MY_TOKEN);
        await myToken.approve(exerciceSolution.address, web3.utils.toWei('10', 'ether'),  {from: WHALE});

        await exerciceSolution.addLiquidity(
            {
            from: WHALE,
            // value: web3.utils.toWei('0.01', 'ether')
            }
        );
    });

    it("Should remove liquidity", async() => {

        const exerciceSolution = await ExerciceSolution.new();
        await exerciceSolution.withdrawLiquidity(
            {
            from: WHALE,
            }
        );
    });

    // it("Should swap eth", async () => {

    //     const tokenIn = await IERC20.at(TOKEN_IN);
    //     const tokenOut = await IERC20.at(TOKEN_OUT);
    //     const exerciceSolution = await ExerciceSolution.new();

    //     await tokenIn.approve(exerciceSolution.address, AMOUNT_IN,  {from: WHALE});

    //     console.log(`before ${await tokenOut.balanceOf(TO)}`); // balance before swap
    //     console.log(`before ${await tokenIn.balanceOf(WHALE)}`);

    //     // await exerciceSolution.swapYourTokenForEth();
    //     await exerciceSolution.swap(
    //        tokenIn.address,
    //        tokenOut.address,
    //        AMOUNT_IN,
    //        AMOUNT_OUT_MIN,
    //        TO,
    //        {
    //         from: WHALE,
    //        }
    //     );

    //     console.log()

    //     const after_1 = await tokenOut.balanceOf(TO);
    //     console.log(parseFloat(web3.utils.fromWei(after_1, 'ether')).toFixed(3));

    //     const after_2 = await tokenIn.balanceOf(TO);
    //     console.log(parseFloat(web3.utils.fromWei(after_2, 'ether')).toFixed(3));

    //     console.log()
    //     console.log(`after ${await tokenOut.balanceOf(TO)}`); // balance after swap
    //     console.log(`after ${await tokenIn.balanceOf(WHALE)}`);
    // });
});