
  
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

uint256 constant TOTAL_TICKETS = 3;

contract Tickets {

  string[] public tokenURIs;
  mapping(uint256 => bool) _tokenURIExists;
  address public owner = msg.sender;


  struct Ticket {
    uint256 price;
    address owner;
    uint256 endTime;
  }

  Ticket[TOTAL_TICKETS] public tickets;
  Ticket[] public ticketss;

  constructor() {
    for (uint256 i = 0; i < TOTAL_TICKETS; i++) {
      tickets[i].price = 1e17*(i+1); // 0.1 ETH
      // tickets[i].owner = address(0x0); // not defined
      tickets[i].endTime = block.timestamp + ((i+1)* 1 days);
    }
  }

  function buyTicket(uint256 _index) external payable {
    require(_index < TOTAL_TICKETS && _index >= 0);
    // require(tickets[_index].owner == address(0x0));
    require(msg.value >= tickets[_index].price);
    tickets[_index].owner = msg.sender;
    _tokenURIExists[_index] = true;
  }
}