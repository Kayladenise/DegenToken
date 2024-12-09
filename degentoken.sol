// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GlamToken is ERC20, Ownable {
    mapping(string => uint256) public itemCost;
    mapping(address => string[]) public playerInventory;

    constructor() ERC20("Glam", "GLM") Ownable(msg.sender) {
        itemCost["Dress"] = 10;
        itemCost["Jewelry"] = 25;
        itemCost["Shoes"] = 20;
        itemCost["Handbag"] = 15;
    }

    function mint(uint256 amount) external onlyOwner {
        _mint(msg.sender, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function transferToken(address destination, uint256 amount) public {
        _transfer(msg.sender, destination, amount);
    }

    function checkBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function redeemItem(string memory item) external {
        uint256 cost = itemCost[item];
        require(cost > 0, "Invalid item");
        require(balanceOf(msg.sender) >= cost, "Insufficient balance to redeem item");
        _burn(msg.sender, cost);
        playerInventory[msg.sender].push(item);
    }

    function viewInventory() public view returns (string[] memory) {
        return playerInventory[msg.sender];
    }

    function addItem(string memory item, uint256 cost) external onlyOwner {
        require(cost > 0, "Item cost must be greater than zero");
        itemCost[item] = cost;
    }

    function updateItemCost(string memory item, uint256 newCost) external onlyOwner {
        require(itemCost[item] > 0, "Item does not exist");
        require(newCost > 0, "New cost must be greater than zero");
        itemCost[item] = newCost;
    }
}
