// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Staking{
   address public owner;

   struct Position{
    uint PositionId;
    address WalletAddress;
    uint CreateDate;
    uint UnlockDate;
    uint PercentInterest;
    uint WeiStaked;
    uint WeiInterest;
    bool open;// IF THE FUNDS ARE Withdrawn
   }
   
   uint public CurrentPositionId;
   mapping(address => uint[])  PositionIdbyAddress;//query purposes
   mapping (uint => Position) positions;// new position is added here
   mapping(uint => uint) tier;// no of days and interest rates data
   uint[] public LockedPeriods;

   constructor()payable {// deployer to send some eth 
      owner = msg.sender;
      CurrentPositionId = 0;

      tier[0] = 600;
      tier[30] = 700;
      tier[60] = 800;
      tier[100] = 1200;

      LockedPeriods.push(0);
      LockedPeriods.push(30);
      LockedPeriods.push(60);
      LockedPeriods.push(100);
   }
   function StakeEther(uint Numdays) public payable {
   require(Numdays > 0, "Notenough days");
   Position  memory CurrentPosition= Position(
      CurrentPositionId,
      msg.sender,
      block.timestamp,
      block.timestamp + (Numdays + 1 days),
      tier[Numdays],
      msg.value,
      CalculateInterest(tier[Numdays], msg.value),
      true
   );

   positions[CurrentPositionId] = CurrentPosition;
   CurrentPositionId++;
   }
   function CalculateInterest(uint basicpoints, uint weiAmount) 
   private pure returns(uint){
      return  basicpoints * weiAmount / 10000;
   }

   function GetLockedPeriods()
   external view returns (uint[] memory){
      return LockedPeriods;
   }

   function GetInterestRate(uint Numdays) 
   external view returns (uint){
      return tier[Numdays];
   }

   function GetPositionByID(uint PositionId) 
   external view returns(Position memory){
      return positions[PositionId];
   }

   function getPositionIdsForAddress (address walletAddress)
   external view returns(uint[]memory){
   return PositionIdbyAddress [walletAddress];
   }

   function closePosition(uint positionId) external {
      require(positions [positionId].WalletAddress == msg.sender, "Only position creator may modify position");
      require(positions [positionId].open ==true,"Position is closed");
      positions [positionId].open = false;
      uint amount = positions [positionId].WeiStaked + positions[positionId].WeiInterest;
      (bool success,) = payable(msg.sender).call{value: amount}("");
      require(success, "Transfer failed.");
   }
}