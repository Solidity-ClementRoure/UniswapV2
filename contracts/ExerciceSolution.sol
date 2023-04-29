pragma solidity ^0.6.2;
import "./utils/IUniswapV2Router.sol";
import "./utils/IUniswapV2Pair.sol";
import "./utils/IUniswapV2Factory.sol";
import "./IExerciceSolution.sol";
import "./IERC20.sol";

contract ExerciceSolution is IExerciceSolution
{
    address private constant dummyToken = 0x2aF483edaE4cce53186E6ed418FE92f8169Ad74E;
    address private constant myToken = 0x3a739647Cd105BB07eC9918A88D6E5DdA9D4898b;

    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant UNISWAP_V2_FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;

    address private constant metamask = 0x589563701c2270930f57fdCaa84aEdCBb891622A;

    //address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant _WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6; // goerli

    uint public liquidity; // quantity of the pool this contract own

    constructor() public {}

    function addLiquidity() override external {

        IERC20(myToken).transferFrom(msg.sender, address(this), 10 ether);
        IERC20(_WETH).transferFrom(msg.sender, address(this), 0.01 ether);

        uint myWethAmount = IERC20(_WETH).balanceOf(address(this));
        uint myTokenAmount = IERC20(myToken).balanceOf(address(this));

        require(myTokenAmount >= 10 ether, "No token");
        require(myWethAmount >= 0.01 ether, "No weth");

        uint amountTokenDesired = myTokenAmount / 2;
        uint amountTokenMin = 1;
        // uint amountETHMin = 1;
        uint amountETHMin = getAmountOutMin(myToken, _WETH, amountTokenDesired);
        uint deadline = block.timestamp + 300;

        IERC20(_WETH).approve(address(UNISWAP_V2_ROUTER), amountTokenDesired);
        IERC20(myToken).approve(address(UNISWAP_V2_ROUTER), amountTokenDesired);

        (, , liquidity) = IUniswapV2Router(UNISWAP_V2_ROUTER).addLiquidity(myToken, _WETH, amountTokenDesired, amountETHMin, amountTokenMin, amountETHMin, address(this), deadline);
    }

    function withdrawLiquidity() override external {

        address myTokenAndWethPairAddress = IUniswapV2Factory(UNISWAP_V2_FACTORY).getPair(myToken, _WETH);

        uint liquidityToRemove = liquidity/2; //IERC20(myTokenAndWethPairAddress).balanceOf(address(this));
        uint deadline = block.timestamp + 300;

        IERC20(myTokenAndWethPairAddress).approve(address(UNISWAP_V2_ROUTER), liquidityToRemove);

        (uint256 amountA, uint256 amountB) = IUniswapV2Router(UNISWAP_V2_ROUTER).removeLiquidity(myToken, _WETH, liquidityToRemove, 1, 1, address(this), deadline);
    }

    function swapYourTokenForDummyToken() override external {  // 'ERC20: transfer amount exceeds balance' if called from Evaluator

        // IERC20(myToken).approve(address(this), 1000 ether); // doesnt work -> approve manually if on testnet

        IERC20(myToken).transferFrom(msg.sender, address(this), 1000 ether);

        IERC20(myToken).approve(address(UNISWAP_V2_ROUTER), 1000 ether);

        address[] memory path;
        path = new address[](3);
        path[0] = myToken;
        path[1] = _WETH;
        path[2] = dummyToken;

        IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(
            1000 ether,
            1,
            path,
            address(this),
            block.timestamp+300
        );
    }

    function swapYourTokenForEth() override external {

        IERC20(myToken).transferFrom(msg.sender, address(this), 10 ether);

        // Give permission to move tokens
        IERC20(myToken).approve(UNISWAP_V2_ROUTER, 10 ether);

        address[] memory path;
        // array des 2 addresses à swap
        path = new address[](2);
        path[0] = myToken;
        path[1] = _WETH;
        //path[1] = _UniswapV2Router02.WETH();

        // Swap
        IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(
            10 ether, // The amount of input tokens to send 
            1, // The minimum amount of output tokens that must be received for the transaction not to revert.
            path,
            address(this),
            block.timestamp+300
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


     function getAmountOutMin(address _tokenIn, address _tokenOut, uint256 _amountIn) public returns (uint256) {

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
        
        uint256[] memory amountOutMins = IUniswapV2Router(UNISWAP_V2_ROUTER).getAmountsOut(_amountIn, path);
        return amountOutMins[path.length -1];  
    }
}