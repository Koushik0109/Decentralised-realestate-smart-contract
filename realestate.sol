pragma solidity ^0.8.0;

contract RealEstate {
    struct Property {
        address owner;
        string name;
        string description;
        uint256 price;
    }
    mapping(uint256 => Property) public properties;
    uint256 public nextPropertyId;
    event NewProperty(uint256 propertyId, address creator, string name, string description, uint256 price);
    event PropertyTransfer(uint256 propertyId, address from, address to);

    constructor() public {
        nextPropertyId = 0;
    }

    function createProperty(string memory _name, string memory _description, uint256 _price) public {
        require(_price > 0, "Price should be greater than 0.");
        properties[nextPropertyId] = Property(msg.sender, _name, _description, _price);
        emit NewProperty(nextPropertyId, msg.sender, _name, _description, _price);
        nextPropertyId++;
    }

    function buyProperty(uint256 _propertyId) public payable {
        require(msg.value >= properties[_propertyId].price, "The value of msg.data should be greater than or equal to the price of the property.");
        require(properties[_propertyId].owner != address(0), "The property is already sold.");
        properties[_propertyId].owner.transfer(properties[_propertyId].price);
        properties[_propertyId].owner = msg.sender;
        emit PropertyTransfer(_propertyId, properties[_propertyId].owner, msg.sender);
    }

    function getProperty(uint256 _propertyId) public view returns (address, string memory, string memory, uint256) {
        return (properties[_propertyId].owner, properties[_propertyId].name, properties[_propertyId].description, properties[_propertyId].price);
    }
}
