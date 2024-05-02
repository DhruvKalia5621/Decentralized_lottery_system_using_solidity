// SPDX-License-Identifier: MIT

pragma solidity >= 0.5.0 < 0.9.0;


contract Lottery {

    // manager and participants entity

    // will store address of the manager
    address public manager;
    // it is of array type because there can be many participants.
    address payable[] public participants; 

    
    constructor(){

        manager = msg.sender; // manager address and global variable

    }

    // payable function will transfer some ether into this contract from participants.
    // special function -> recieve() one time use only
    receive() external payable {

        // with the require the participants must pay 1 ether to participant in the lottery.
        // require = if else , require is small and clean code.
        require(msg.value==1 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint){

        // with this require only manager will be able to see the balance.
        require(msg.sender==manager);
        return address(this).balance;
    }

    function random() public view returns (uint){
        // algorithm just like sha-256
        return uint(keccak256(abi.encodePacked(block.number, block.timestamp, participants.length)));
    }

    function selectWinner() public {

        require(msg.sender==manager);
        require(participants.length>=3);
        uint r = random();
        address payable winner;
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);

    }


}

