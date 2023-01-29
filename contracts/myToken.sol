pragma solidity ^0.6.2;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract myToken is ERC20 {

    constructor() public ERC20("FRNvl","FRNvl"){
	  
      _mint(msg.sender, 45040603000000000000000000);
	}
}
