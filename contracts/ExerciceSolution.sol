pragma solidity ^0.6.2;
import "./utils/IUniswapV2Router.sol";
import "./utils/IUniswapV2Pair.sol";
import "./IExerciceSolution.sol";
import "./IERC20.sol";

contract ExerciceSolution is IExerciceSolution
{
    address private constant dummyToken = 0x2aF483edaE4cce53186E6ed418FE92f8169Ad74E;
    address private constant myToken = 0x3a739647Cd105BB07eC9918A88D6E5DdA9D4898b;

    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    //address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant _WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6; // goerli

    constructor() public {}

    function addLiquidity() override external {

      
    }


    function withdrawLiquidity() override external {


    }

    function swapYourTokenForDummyToken() override external {

        IERC20(myToken).transferFrom(msg.sender, address(this), 0.001 ether);

        IERC20(myToken).approve(address(UNISWAP_V2_ROUTER), 0.001 ether);

        address[] memory path;
        path = new address[](3);
        path[0] = myToken;
        path[1] = _WETH;
        path[2] = dummyToken;

        IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(
            1000 wei,
            10 wei,
            path,
            address(this),
            block.timestamp
        );
    }

    function swapYourTokenForEth() override external {

        IERC20(myToken).transferFrom(msg.sender, address(this), 0.001 ether);

        // Give permission to move tokens
        IERC20(myToken).approve(UNISWAP_V2_ROUTER, 0.001 ether);

        address[] memory path;
        // array des 2 addresses à swap
        path = new address[](2);
        path[0] = myToken;
        path[1] = _WETH;
        //path[1] = _UniswapV2Router02.WETH();

        // Swap
        IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(
            0.001 ether,
            10 wei,
            path,
            address(this),
            block.timestamp
        );
    }

    
    function swap(
        address _tokenIn,
        address _tokenOut,
        uint256 _amountIn,
        uint256 _amountOutMin,
        address _to
    ) external {

        //first we need to transfer the amount in tokens from the msg.sender to this contract
        //this contract will have the amount of in tokens
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);

        //next we need to allow the uniswapv2 router to spend the token we just sent to this contract
        //by calling IERC20 approve you allow the uniswap contract to spend the tokens in this contract 
        IERC20(_tokenIn).approve(UNISWAP_V2_ROUTER, _amountIn); 

        //path is an array of addresses.
        //this path array will have 3 addresses [tokenIn, WETH, tokenOut]
        //the if statement below takes into account if token in or token out is WETH.  then the path is only 2 addresses
        address[] memory path;
        if (_tokenIn == _WETH || _tokenOut == _WETH) {
            path = new address[](2);
            path[0] = _tokenIn;
            path[1] = _tokenOut;
        } else {
            path = new address[](3);
            path[0] = _tokenIn;
            path[1] = _WETH;
            path[2] = _tokenOut;
        }

        //then we will call swapExactTokensForTokens
        //for the deadline we will pass in block.timestamp
        //the deadline is the latest time the trade is valid for
        IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(
            _amountIn,
            _amountOutMin,
            path,
            _to,
            block.timestamp
        );
    }
}