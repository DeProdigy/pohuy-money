pragma solidity >=0.6.0 <0.7.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import 'base64-sol/base64.sol';

import './HexStrings.sol';
import './ToColor.sol';

//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721

// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract YourCollectible is ERC721, Ownable {
  using Strings for uint256;
  using HexStrings for uint160;
  using ToColor for bytes3;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() public ERC721("Loogies", "LOOG") {
    // RELEASE THE LOOGIES!
  }

  mapping (uint256 => bytes3) public color;
  mapping (uint256 => bytes3) public eyeColor;
  mapping (uint256 => uint256) public chubbiness;

  uint256 mintDeadline = block.timestamp + 24 hours;

  function mintItem()
      public
      returns (uint256)
  {
      require( block.timestamp < mintDeadline, "DONE MINTING");
      _tokenIds.increment();

      uint256 id = _tokenIds.current();
      _mint(msg.sender, id);

      bytes32 predictableRandom = keccak256(abi.encodePacked( blockhash(block.number-1), msg.sender, address(this) ));
      color[id] = bytes2(predictableRandom[0]) | ( bytes2(predictableRandom[1]) >> 8 ) | ( bytes3(predictableRandom[2]) >> 16 );
      eyeColor[id] = bytes2(predictableRandom[3]) | ( bytes2(predictableRandom[4]) >> 8 ) | ( bytes3(predictableRandom[5]) >> 16 );
      chubbiness[id] = 35+((55*uint256(uint8(predictableRandom[3])))/255);

      return id;
  }

  function tokenURI(uint256 id) public view override returns (string memory) {
      require(_exists(id), "not exist");
      string memory name = string(abi.encodePacked('Loogie #',id.toString()));
      string memory description = string(abi.encodePacked('This Loogie is the color #',color[id].toColor(),' with a chubbiness of ',uint2str(chubbiness[id]),'!!!'));
      string memory image = Base64.encode(bytes(generateSVGofTokenById(id)));

      return
          string(
              abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                          abi.encodePacked(
                              '{"name":"',
                              name,
                              '", "description":"',
                              description,
                              '", "external_url":"https://burnyboys.com/token/',
                              id.toString(),
                              '", "attributes": [{"trait_type": "color", "value": "#',
                              color[id].toColor(),
                              '"},{"trait_type": "chubbiness", "value": ',
                              uint2str(chubbiness[id]),
                              '}], "owner":"',
                              (uint160(ownerOf(id))).toHexString(20),
                              '", "image": "',
                              'data:image/svg+xml;base64,',
                              image,
                              '"}'
                          )
                        )
                    )
              )
          );
  }

  function generateSVGofTokenById(uint256 id) internal view returns (string memory) {

    string memory svg = string(abi.encodePacked(
      '<svg xmlns="http://www.w3.org/2000/svg" width="520" height="840" viewBox="0 0 520 840" fill="none"><rect x="480" y="80" width="40" height="40" fill="#7020C4"/>',
          generateHead(id),
          '<rect x="440" y="120" width="40" height="40" fill="#7020C4"/>',
          '<rect x="440" y="80" width="40" height="40" fill="#7020C4"/>',
          '<rect x="440" y="160" width="40" height="40" fill="#7020C4"/>',
          '<rect x="440" y="200" width="40" height="40" fill="#7020C4"/>',
          '<rect x="440" y="240" width="40" height="40" fill="#7020C4"/>',
          '<rect x="440" y="280" width="40" height="40" fill="#7020C4"/>',
          '<rect x="440" y="320" width="40" height="40" fill="black"/>',
          '<rect x="440" y="360" width="40" height="40" fill="black"/>',
          '<rect x="440" y="400" width="40" height="40" fill="black"/>',
          '<rect x="440" y="440" width="40" height="40" fill="black"/>',
          '<rect x="440" y="480" width="40" height="40" fill="black"/>',
          '<rect x="440" y="520" width="40" height="40" fill="black"/>',
          '<rect x="440" y="560" width="40" height="40" fill="black"/>',
          '<rect x="400" y="600" width="40" height="40" fill="black"/>',
          '<rect x="360" y="640" width="40" height="40" fill="black"/>',
          '<rect x="320" y="680" width="40" height="40" fill="black"/>',
          '<rect x="280" y="680" width="40" height="40" fill="black"/>',
          '<rect x="280" y="720" width="40" height="40" fill="black"/>',
          '<rect x="280" y="760" width="40" height="40" fill="black"/>',
          '<rect x="280" y="800" width="40" height="40" fill="black"/>',
          '<rect x="240" y="680" width="40" height="40" fill="black"/>',
          '<rect x="200" y="640" width="40" height="40" fill="black"/>',
          '<rect x="480" y="200" width="40" height="40" fill="#7020C4"/>',
          '<rect x="400" y="80" width="40" height="40" fill="#7020C4"/>',
          '<rect x="400" y="120" width="40" height="40" fill="#7020C4"/>',
          '<rect x="400" y="160" width="40" height="40" fill="#7020C4"/>',
          '<rect x="400" y="200" width="40" height="40" fill="#7020C4"/>',
          '<rect x="400" y="40" width="40" height="40" fill="#7020C4"/>',
          '<rect x="400" width="40" height="40" fill="#7020C4"/>',
          '<rect x="360" y="80" width="40" height="40" fill="#7020C4"/>',
          '<rect x="360" y="160" width="40" height="40" fill="#7020C4"/>',
          '<rect x="360" y="120" width="40" height="40" fill="#7020C4"/>',
          '<rect x="360" y="40" width="40" height="40" fill="#7020C4"/>',
          '<rect x="320" y="80" width="40" height="40" fill="#7020C4"/>',
          '<rect x="320" y="120" width="40" height="40" fill="#7020C4"/>',
          '<rect x="320" y="40" width="40" height="40" fill="#7020C4"/>',
          '<rect x="320" width="40" height="40" fill="#7020C4"/>',
          '<rect x="280" y="80" width="40" height="40" fill="#7020C4"/>',
          '<rect x="280" y="120" width="40" height="40" fill="#7020C4"/>',
          '<rect x="280" y="200" width="40" height="40" fill="#7020C4"/>',
          '<rect x="280" y="160" width="40" height="40" fill="#7020C4"/>',
          '<rect x="280" y="240" width="40" height="40" fill="#7020C4"/>',
          '<rect x="280" y="40" width="40" height="40" fill="#7020C4"/>',
          '<rect x="280" width="40" height="40" fill="#7020C4"/>',
          '<rect x="240" y="80" width="40" height="40" fill="#7020C4"/>',
          '<rect x="240" y="120" width="40" height="40" fill="#7020C4"/>',
          '<rect x="240" y="160" width="40" height="40" fill="#7020C4"/>',
          '<rect x="240" y="40" width="40" height="40" fill="#7020C4"/>',
          '<rect x="240" width="40" height="40" fill="#7020C4"/>',
          '<rect x="200" y="80" width="40" height="40" fill="#7020C4"/>',
          '<rect x="200" y="120" width="40" height="40" fill="#7020C4"/>',
          '<rect x="200" y="160" width="40" height="40" fill="#7020C4"/>',
          '<rect x="200" y="40" width="40" height="40" fill="#7020C4"/>',
          '<rect x="200" width="40" height="40" fill="#7020C4"/>',
          '<rect x="160" y="120" width="40" height="40" fill="#7020C4"/>',
          '<rect x="160" y="80" width="40" height="40" fill="#7020C4"/>',
          '<rect x="160" y="160" width="40" height="40" fill="#7020C4"/>',
          '<rect x="160" y="200" width="40" height="40" fill="#7020C4"/>',
          '<rect x="160" y="40" width="40" height="40" fill="#7020C4"/>',
          '<rect x="160" width="40" height="40" fill="#7020C4"/>',
          '<rect x="120" y="80" width="40" height="40" fill="#7020C4"/>',
          '<rect x="120" y="120" width="40" height="40" fill="#7020C4"/>',
          '<rect x="120" y="160" width="40" height="40" fill="#7020C4"/>',
          '<rect x="120" y="40" width="40" height="40" fill="#7020C4"/>',
          '<rect x="120" width="40" height="40" fill="#7020C4"/>',
          '<rect x="80" y="80" width="40" height="40" fill="#7020C4"/>',
          '<rect x="80" y="200" width="40" height="40" fill="#7020C4"/>',
          '<rect x="40" y="200" width="40" height="40" fill="#7020C4"/>',
          '<rect y="200" width="40" height="40" fill="#7020C4"/>',
          '<rect x="80" y="120" width="40" height="40" fill="#7020C4"/>',
          '<rect x="80" y="240" width="40" height="40" fill="#7020C4"/>',
          '<rect x="120" y="240" width="40" height="40" fill="#7020C4"/>',
          '<rect x="80" y="280" width="40" height="40" fill="#7020C4"/>',
          '<rect x="80" y="160" width="40" height="40" fill="#7020C4"/>',
          '<rect x="40" y="320" width="40" height="40" fill="#7020C4"/>',
          '<rect x="40" y="360" width="40" height="40" fill="#7020C4"/>',
          '<rect y="400" width="40" height="40" fill="#7020C4"/>',
          '<rect x="80" y="400" width="40" height="40" fill="black"/>',
          '<rect x="80" y="440" width="40" height="40" fill="black"/>',
          '<rect x="40" y="440" width="40" height="40" fill="#7020C4"/>',
          '<rect x="80" y="480" width="40" height="40" fill="black"/>',
          '<rect x="80" y="520" width="40" height="40" fill="black"/>',
          '<rect x="80" y="560" width="40" height="40" fill="black"/>',
          '<rect x="120" y="600" width="40" height="40" fill="black"/>',
          '<rect x="120" y="640" width="40" height="40" fill="black"/>',
          '<rect x="120" y="680" width="40" height="40" fill="black"/>',
          '<rect x="120" y="720" width="40" height="40" fill="black"/>',
          '<rect x="120" y="760" width="40" height="40" fill="black"/>',
          '<rect x="120" y="800" width="40" height="40" fill="black"/>',
          '<rect x="80" y="40" width="40" height="40" fill="#7020C4"/>',
          '<rect x="40" y="80" width="40" height="40" fill="#7020C4"/>',
          '<rect x="40" y="120" width="40" height="40" fill="#7020C4"/>',
          '<rect y="120" width="40" height="40" fill="#7020C4"/>',
          '<rect x="40" y="160" width="40" height="40" fill="#7020C4"/>',
          '<rect x="280" y="480" width="40" height="40" fill="black"/>',
          '<rect x="320" y="560" width="40" height="40" fill="#703E21"/>',
          '<rect x="240" y="560" width="40" height="40" fill="#703E21"/>',
          '<rect x="280" y="560" width="40" height="40" fill="#703E21"/>',
          '<rect x="160" y="320" width="40" height="40" fill="#703E21"/>',
          '<rect x="200" y="320" width="40" height="40" fill="#703E21"/>',
          '<rect x="360" y="320" width="40" height="40" fill="#703E21"/>',
          '<rect x="400" y="320" width="40" height="40" fill="#703E21"/>',
          '<rect x="200" y="360" width="40" height="40" fill="#AD8A64"/>',
          '<rect x="400" y="360" width="40" height="40" fill="#AD8A64"/>',
          generateEyes(id),
        '</svg>'
    ));
    return svg;
  }

  function generateHead(uint256 id) public view returns (string memory) {
    string memory render = string(abi.encodePacked(
      '<rect x="80" y="160" width="360" height="400" fill="#',
          color[id].toColor(),
      '"/>'
    ));

    return render;
  }

  function generateEyes(uint256 id) public view returns (string memory) {
    string memory render = string(abi.encodePacked(
      '<rect x="160" y="360" width="40" height="40" fill="#',
        eyeColor[id].toColor(),
      '"/>',
      '<rect x="360" y="360" width="40" height="40" fill="#',
        eyeColor[id].toColor(),
      '"/>'
    ));

    return render;
  }

  function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
      if (_i == 0) {
          return "0";
      }
      uint j = _i;
      uint len;
      while (j != 0) {
          len++;
          j /= 10;
      }
      bytes memory bstr = new bytes(len);
      uint k = len;
      while (_i != 0) {
          k = k-1;
          uint8 temp = (48 + uint8(_i - _i / 10 * 10));
          bytes1 b1 = bytes1(temp);
          bstr[k] = b1;
          _i /= 10;
      }
      return string(bstr);
  }
}
