pragma solidity ^0.4.23;

import "zeppelin-solidity/contracts/math/SafeMath.sol";

contract Vault {
  using SafeMath for uint256;
      
  event Deposited(address fromAddress,  uint256 amount);
  event Withdrawn(address from, address to, uint256 amount);

  constructor() public {
    
  }

  function deposit() public payable {
    uint256 amount = msg.value;
    emit Deposited(msg.sender,  amount);
  }

  function withdraw(uint256 seq, address from, address to, uint256 amount, uint8 v, bytes32 r, bytes32 s) public {
    bytes memory prefix = "\x19Ethereum Signed Message:\n32";
    bytes32 txhash = keccak256(seq, from, to, amount);
    bytes32 prefixedHash = keccak256(prefix, txhash);
    address vfrom = ecrecover(prefixedHash, v, r, s);

    require(vfrom == from);

    msg.sender.transfer(amount);
    emit Withdrawn(vfrom, msg.sender, amount);
  }

}
