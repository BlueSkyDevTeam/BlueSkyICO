pragma solidity ^0.4.21;

import "./CappedCrowdsale.sol";
import "./RefundableCrowdsale.sol";
import "./MintedCrowdsale.sol";
import "./MintableToken.sol";



/**
 * @title BlueSkyToken
 * @dev ERC20 Token for the BlueSky project.
 * 
 */
contract BlueSkyToken is MintableToken {

  string public constant name = "BlueSky Token"; // solium-disable-line uppercase
  string public constant symbol = "BST"; // solium-disable-line uppercase
  uint8 public constant decimals = 18; // solium-disabl e-line uppercase


}


/**
 * @title BlueSkyICO
 * @dev This is the BlueSky ICO contract.
 * The BlueSky ICO contract uses the following extensions:
 *  - CappedCrowdsale - A cap is set as an upper limit for funds raised.
 *  - RefundableCrowdsale - Sets a minimum goal for funds raised. Refunds are enabled if goal is not reached.
 *  - MintedCrowdsale - Enables the minting of tokens. Tokens for Devs are minted on contract creation.
 *  - TimedCrowdsale - Sets the start and end time of the token sale. Also sets the project end time which is 
 *                     used to specify the maximum allowed time for project completion. 
 * 
 * 
 */
contract BlueSkyICO is CappedCrowdsale, MintedCrowdsale, RefundableCrowdsale {

  constructor(
    uint256 _openingTime,
    uint256 _closingTime,
    uint256 _rate,
    address _devWallet,
    uint256 _cap,
    uint256 _goal,
    uint256 _projectEndTime,
    uint256 _initialDevTokensWei
  )
    public
    Crowdsale(_rate, _devWallet, new BlueSkyToken(), _initialDevTokensWei)
    CappedCrowdsale(_cap)
    TimedCrowdsale(_openingTime, _closingTime, _projectEndTime)
    RefundableCrowdsale(_goal)
  {
    
    // Minimum goal needs to be less than the max cap.
    require(_goal <= _cap);
    // Opening time of token sale needs to be less than the closing time.
    require(_openingTime < _closingTime);
    // Closing time of taken sale needs to be less than the project end time.
    require(_closingTime < _projectEndTime);
    // Mint tokens for the developers. These tokens get delivered to the dev
    // wallet and cannot be refunded for ETH.
    _deliverTokens(_devWallet, _initialDevTokensWei);

    
  }



 
}

