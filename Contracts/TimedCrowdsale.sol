pragma solidity ^0.4.21;

import "./SafeMath.sol";
import "./Crowdsale.sol";


/**
 * @title TimedCrowdsale
 * @dev Crowdsale accepting contributions only within a time frame.
 * Contributions allowed between opening and closing. Also provides
 * control for the project end time, which allows refunds
 * until the project end time is reached. These refunds are seperate
 * to the normal refund feature that is enabled when the goal is not
 * reached.
 */
contract TimedCrowdsale is Crowdsale {
  using SafeMath for uint256;

  uint256 public openingTime;
  uint256 public closingTime;
  uint256 public projectEndTime;

  /**
   * @dev Reverts if not in crowdsale time range.
   */
  modifier onlyWhileOpen {
    
    // require(block.timestamp >= openingTime && block.timestamp <= closingTime);
    require(isCrowdsaleOpen());
    _;
  }

  /**
   * @dev Constructor, takes crowdsale opening and closing times.
   * @param _openingTime Crowdsale opening time
   * @param _closingTime Crowdsale closing time
   */
  constructor(uint256 _openingTime, uint256 _closingTime, uint256 _projectEndTime) public {
   
    require(_openingTime >= block.timestamp);
    require(_closingTime >= _openingTime);
    require(_projectEndTime >= _closingTime);

    openingTime = _openingTime;
    closingTime = _closingTime;
    projectEndTime = _projectEndTime;

    
  }

  /**
   * @dev Checks whether the period in which the crowdsale is open has already elapsed.
   * @return Whether crowdsale period has elapsed
   */
  function hasCrowdsaleClosed() public view returns (bool) {
    
    return block.timestamp > closingTime;
  }
  
   /**
   * @dev Checks whether the crowdsale has passed the open time.
   * @return Whether crowdsale has opened.
   */
  function hasCrowdsaleOpened() public view returns (bool) {
   
    return block.timestamp > openingTime;
  }
  
/**
   * @dev Checks whether the crowdsale is currently open.
   * @return Whether crowdsale is open.
   * this is also used in the onlyWhileOpen modifier.
   */
  function isCrowdsaleOpen() public view returns (bool) {
   
    return block.timestamp >= openingTime && block.timestamp <= closingTime;
  }
  
  
  /**
   * @dev Calculates the number of seconds before the crowdsale opens.
   * @return number of seconds until open, or 0 if already open.
   * 
   */
  function getSecondsUntilOpen() public view returns (uint256) {
    
    if (block.timestamp >= openingTime)
    {
        return 0;
    }
    else
    {
        return SafeMath.sub(openingTime,block.timestamp);
    }
    
  }
  
  
    
  
  

/**
   * @dev Checks whether the period of the total project allowed time has already elapsed.
   * @return Whether ICO project total allowed period has elapsed
   */
  function hasProjectEnded() public view returns (bool) {
   
    return block.timestamp > projectEndTime;
  }

  /**
   * @dev Extend parent behavior requiring to be within contributing period
   * @param _beneficiary Token purchaser
   * @param _weiAmount Amount of wei contributed
   */
  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) view internal onlyWhileOpen {
    super._preValidatePurchase(_beneficiary, _weiAmount);
    
  }

}
