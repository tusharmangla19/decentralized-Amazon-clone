// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Dappazon {
    address public owner;
    mapping(uint=>Item)public items;
    mapping(address=>uint)public orderCount;
    mapping(address=>mapping(uint=>Order))public orders;

    event List(string name,uint cost,uint quantity);
    event Buy(address buyer,uint orderId,uint itemId);
    constructor(){
        owner = msg.sender;
    }

    struct Item {
     uint id;
     string name;
     string category;
     string image;
     uint cost;
     uint rating;
     uint stock;
    }
    
    struct Order{
     uint time;
     Item item;
    }
    
    function list(uint id,
    string memory name,
     string memory category,
     string memory image,
     uint cost,
     uint rating,
     uint stock )
      public{
        require(msg.sender==owner,"You are not the owner");
        Item memory item = Item(id, name, category,image,cost,rating,stock);
        items[id]=item;
        emit List(name,cost,stock);
    }

    function buy(uint id) public payable{ 
        Item memory item = items[id];

        require(msg.value>=item.cost,"Send more money");
        require(item.stock>0,"Out of stock");

         Order memory order = Order(block.timestamp,item); 
         orderCount[msg.sender]++;
         orders[msg.sender][orderCount[msg.sender]]=order;

         items[id].stock=item.stock-1;

         emit Buy(msg.sender,orderCount[msg.sender],item.id);
    }

    function withdraw()public {
        require(msg.sender==owner,"You are not the owner");
        (bool success,)=owner.call{value:address(this).balance}("");
        require(success); 
    }
}
