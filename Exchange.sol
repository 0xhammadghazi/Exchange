pragma solidity ^0.8.0;

contract Exchange{
    
    //ledger for buy orders
    uint256[] public buyOrder;  
    
    //ledger for sell orders
    uint256[] public sellOrder;
    

    function placeOrder(string memory _side, uint256 _price) public{
        
        //revert if _side is neither buy nor sell
       require(keccak256(abi.encodePacked(_side)) == keccak256(abi.encodePacked("buy")) || keccak256(abi.encodePacked(_side)) == keccak256(abi.encodePacked("sell")),"Invalid Input");
            
            //comparing string by hashing, if _side is "buy" then the hash of _side and "buy" would be same. Hence, execute the block.
            if(keccak256(abi.encodePacked(_side)) == keccak256(abi.encodePacked("buy"))){
                
                //entry of price in buyOrder ledger
            buyOrder.push(_price);
            
            //only call matchOrder when there is an element in sellOrder
            if(sellOrder.length>0){
                //Since a new buyOrder is placed. Hence, checking sellOrder ledger for same price order.
                matchOrder("sell",_price);
            }
        }
        else if (keccak256(abi.encodePacked(_side)) == keccak256(abi.encodePacked("sell"))){
            sellOrder.push(_price);
            if(buyOrder.length!=0){
                matchOrder("buy",_price);
            }
        }
    }
    
    function matchOrder(string memory _side, uint256 _price) private{
        
        //comparing string, this block will get executed everytime a new buyOrder is placed
        if(keccak256(abi.encodePacked(_side)) == keccak256(abi.encodePacked("sell"))){
            //looping through sell order ledger
            for(uint i=0;i<sellOrder.length;i++){
                
                //comparing price of newly created buyOrder with each price in sellOrder ledger
                //In this block, _price contains the price of newly created buyOrder
                //if same price order exists then the following block will be executed
                if(sellOrder[i]==_price){
                
                /*Moving the last element of sellOrder ledger to the index where sellOrder ledger price is equal to newly created buyOrder price, 
                i.e. deleting sellOrder entry where price of sellOrder is equal to newly created buyOrder*/
                sellOrder[i]=sellOrder[sellOrder.length-1];
                //Removing last element, as I have already moved it to the deleted spot
                sellOrder.pop();
                //Removing the last element of buyOrder because a sellOrder exists for same price
                buyOrder.pop();
                break;
                }
            }
        }
        else if(keccak256(abi.encodePacked(_side)) == keccak256(abi.encodePacked("buy"))){
            for(uint i=0;i<buyOrder.length;i++){
                if(buyOrder[i]==_price){
                buyOrder[i]=buyOrder[buyOrder.length-1];
                buyOrder.pop();
                sellOrder.pop();
                break;
                }
            }
        }
    }
}
  