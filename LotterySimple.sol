// SPDX-License-Identifier: MIT
pragma solidity 0.8.27; // stating version type


contract SimpleLottery {

    
    enum LotteryState {
        Open, //0
        Closed //1
    }

    address public owner;
    address[] public players;
    uint256 public lotteryId;
    uint256 constant TICKET_PRICE = 0.001 ether;
    uint256 public contractFund;
    uint256 constant MAX_NUMBER = 25;
    uint256 public totalTicketSold;
    uint256 public startTime;
    LotteryState public lotteryState;

    //Mapping of lottery ID to the mapping of their chosen number and list of addresses that bought that number
    mapping(uint256 => mapping(uint256 => address[])) tickets;
    //Mapping of lotteryId to winning number
    mapping(uint256 => uint256) public lotteryWinningNumber;

    constructor() {
        owner = msg.sender;
        lotteryState = LotteryState.Open;
        startTime = block.timestamp;
        lotteryId += 1;
    }

    function buyTicket(uint256 _number) external payable {
        require(msg.value == TICKET_PRICE, "insufficient fund");
        require(_number <= MAX_NUMBER, "You must number between max number");
        
        contractFund += msg.value;
        tickets[lotteryId][_number].push(msg.sender);
        totalTicketSold += 1;
        players.push(msg.sender);
    }

    function getRandomNumber() private view returns (uint16) {
        return uint16(uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, players.length))) % MAX_NUMBER);
    }

   function calculatePrize() external {
        require(lotteryState == LotteryState.Open, "Lottery is already closed");
        require(players.length >= 3, "Not enough players");
        lotteryState = LotteryState.Closed;
        uint16 winningNumber = getRandomNumber();
        lotteryWinningNumber[lotteryId] = winningNumber;
        address[] memory winners = tickets[lotteryId][winningNumber];

        if (winners.length > 0) {
            uint256 prize = contractFund / winners.length;
        
            for (uint256 i = 0; i < winners.length; i++) {
                (bool success, ) = payable(winners[i]).call{value: prize}("");
                require(success, "Transfer failed");
        }
        contractFund = 0;
        } else {
            lotteryState = LotteryState.Open;
            startTime = block.timestamp;
            totalTicketSold = 0;
            lotteryId += 1;
        }
    }

    function reopenLottery() external {
    require(msg.sender == owner, "Only the owner can reopen the lottery");
    require(lotteryState == LotteryState.Closed, "Lottery is already open");

    lotteryState = LotteryState.Open;
    startTime = block.timestamp;
    lotteryId += 1;
    }

}
    
