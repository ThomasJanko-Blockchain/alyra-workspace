// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Systeme de loterie
//L'administrateur définit un mot à trouver
//Les joueurs peuvent proposer un mot

import "@openzeppelin/contracts/access/Ownable.sol";

error UserHasAlreadyPlayed(address user);
error GameIsFinished();

contract Indice is Ownable {

    string private word;
    string private hint;
    address winner;

    mapping(address => bool) hasPlayed;

    event GameWon(address indexed _winner);

    constructor() Ownable(msg.sender) {

    }

    function guess(string memory _word) external returns(bool) {
        if (hasPlayed[msg.sender]) revert UserHasAlreadyPlayed(msg.sender);
        if (winner != address(0)) revert GameIsFinished();
        hasPlayed[msg.sender] = true;
        if(compareWords(word, _word)) {
            winner = msg.sender;
            emit GameWon(msg.sender);
            return true;
        }
        return false;
    }

    function setWordAndHint(string calldata _word, string calldata _hint) external onlyOwner {
        word = _word;
        hint = _hint;   
    }

    function compareWords(string memory _string1, string memory _string2) private pure returns(bool) {
        return keccak256(bytes(_string1)) == keccak256(bytes(_string2));
    }

    function getHint() external view returns(string memory) {
        return hint;
    }

    function getWinner() external view returns(address) {
        return winner;
    }





}