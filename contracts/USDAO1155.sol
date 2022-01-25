// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract USDAO1155 is ERC1155 {
    address public owner;
    uint256 public totalSupply;
    uint256 public totalSupplyCap;
    string public name;
    string public symbol;
    mapping(uint256 => string) private _tokenURI;

    enum Category {
        COMMON,
        RAREORANGE,
        RAREPURPLE,
        RAREVIOLET,
        RAREYELLOW,
        UNIQUEOATA,
        UNIQUELEGENDARY,
        UNIQUEGOLDEN,
        UNIQUEDIAMOND,
        UNIQUESILVER
    }

    mapping(uint256 => Category) public tokenCategory;
    // total supplies of different token categories
    mapping(Category => uint256) public categorySupply;
    // supply caps of different token categories
    mapping(Category => uint256) public categorySupplyCap;

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "only owner has the permission to access this function!!!"
        );
        _;
    }

    constructor() ERC1155("") {
        totalSupply = 0;
        owner = msg.sender;
        totalSupplyCap = 1001;
        name = "USDAO NFT Collection";
        symbol = "USDAO-NFT";
        categorySupplyCap[Category.COMMON] = 870;
        categorySupplyCap[Category.RAREORANGE] = 5;
        categorySupplyCap[Category.RAREPURPLE] = 10;
        categorySupplyCap[Category.RAREVIOLET] = 25;
        categorySupplyCap[Category.RAREYELLOW] = 40;
        categorySupplyCap[Category.UNIQUEOATA] = 1;
        categorySupplyCap[Category.UNIQUELEGENDARY] = 5;
        categorySupplyCap[Category.UNIQUEGOLDEN] = 10;
        categorySupplyCap[Category.UNIQUEDIAMOND] = 20;
        categorySupplyCap[Category.UNIQUESILVER] = 15;
    }

    function totalRareSupply() external view returns (uint256) {
        return (categorySupply[Category.RAREORANGE] +
            categorySupply[Category.RAREPURPLE] +
            categorySupply[Category.RAREVIOLET] +
            categorySupply[Category.RAREYELLOW]);
    }

    function totalUniqueSupply() external view returns (uint256) {
        return (categorySupply[Category.UNIQUEOATA] +
            categorySupply[Category.UNIQUELEGENDARY] +
            categorySupply[Category.UNIQUEGOLDEN] +
            categorySupply[Category.UNIQUEDIAMOND] +
            categorySupply[Category.UNIQUESILVER]);
    }

    function totalCommonSupply() external view returns (uint256) {
        return categorySupply[Category.COMMON];
    }

    function rareSupplyCap() external view returns (uint256) {
        return (categorySupplyCap[Category.RAREORANGE] +
            categorySupplyCap[Category.RAREPURPLE] +
            categorySupplyCap[Category.RAREVIOLET] +
            categorySupplyCap[Category.RAREYELLOW]);
    }

    function uniqueSupplyCap() external view returns (uint256) {
        return (categorySupplyCap[Category.UNIQUEOATA] +
            categorySupplyCap[Category.UNIQUELEGENDARY] +
            categorySupplyCap[Category.UNIQUEGOLDEN] +
            categorySupplyCap[Category.UNIQUEDIAMOND] +
            categorySupplyCap[Category.UNIQUESILVER]);
    }

    function commonSupplyCap() external view returns (uint256) {
        return categorySupplyCap[Category.COMMON];
    }

    function uri(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        return _tokenURI[_tokenId];
    }

    function increaseTotalSupplyCap(uint256 _newSupplyCap) public onlyOwner {
        require(
            _newSupplyCap > totalSupplyCap,
            "new supply cap should be more than the old supply cap!!!"
        );
        totalSupplyCap = _newSupplyCap;
    }

    function changeCategorySupplyCap(Category _category, uint256 _newSupplyCap)
        public
        onlyOwner
    {
        categorySupplyCap[_category] = _newSupplyCap;
    }

    function mintNFT(
        address minter,
        string memory _uri,
        Category _category
    ) external {
        //this will only mint single copy of an nft
        require(totalSupply < totalSupplyCap, "cannot mint more NFTs!!!");
        require(uint256(_category) < 10, "Invalid category provided!!!");
        require(
            categorySupply[_category] < categorySupplyCap[_category],
            "cannot mint more NFTs in this category!!!"
        );
        categorySupply[_category]++;
        totalSupply++;
        _setURI(_uri);
        emit URI(_uri, totalSupply);
        _mint(minter, totalSupply, 1, "");
        _tokenURI[totalSupply] = _uri;
        tokenCategory[totalSupply] = _category;
    }
}
