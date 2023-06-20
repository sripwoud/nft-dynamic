// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ChainBattles.sol";
import "openzeppelin/token/ERC721/IERC721Receiver.sol";

/// @dev Expose internal methods for testing
contract PublicChainBattles is ChainBattles {
    function pubGenerateTokenURI(uint256 tokenId) public view returns (string memory) {
        return super.generateTokenURI(tokenId);
    }
}

contract ChainBattlesTest is Test, IERC721Receiver {
    PublicChainBattles public chainBattles;

    // addresses that receives ERC721 tokens need to implement this interface
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4)
    {
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }

    function setUp() public {
        chainBattles = new PublicChainBattles();
    }

    function testInit() public {
        assertEq(chainBattles.name(), "ChainBattles");
        assertEq(chainBattles.symbol(), "CBTLS");
        assertEq(chainBattles.totalSupply(), 0);
    }

    function testGenerateTokenURI() public {
        assertEq(
            chainBattles.pubGenerateTokenURI(0),
            "data:application/json;base64,eyJuYW1lIjogIkNoYWluIEJhdHRsZXMgIzAiLCJkZXNjcmlwdGlvbiI6ICJCYXR0bGVzIG9uIGNoYWluIiwiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCNGJXeHVjejBpYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNpSUhCeVpYTmxjblpsUVhOd1pXTjBVbUYwYVc4OUluaE5hVzVaVFdsdUlHMWxaWFFpSUhacFpYZENiM2c5SWpBZ01DQXpOVEFnTXpVd0lqNDhjM1I1YkdVK0xtSmhjMlVnZXlCbWFXeHNPaUIzYUdsMFpUc2dabTl1ZEMxbVlXMXBiSGs2SUhObGNtbG1PeUJtYjI1MExYTnBlbVU2SURFMGNIZzdJSDA4TDNOMGVXeGxQanh5WldOMElIZHBaSFJvUFNJeE1EQWxJaUJvWldsbmFIUTlJakV3TUNVaUlHWnBiR3c5SW1Kc1lXTnJJaUF2UGp4MFpYaDBJSGc5SWpVd0pTSWdlVDBpTkRBbElpQmpiR0Z6Y3owaVltRnpaU0lnWkc5dGFXNWhiblF0WW1GelpXeHBibVU5SW0xcFpHUnNaU0lnZEdWNGRDMWhibU5vYjNJOUltMXBaR1JzWlNJK1YyRnljbWx2Y2p3dmRHVjRkRDQ4ZEdWNGRDQjRQU0kxTUNVaUlIazlJalV3SlNJZ1kyeGhjM005SW1KaGMyVWlJR1J2YldsdVlXNTBMV0poYzJWc2FXNWxQU0p0YVdSa2JHVWlJSFJsZUhRdFlXNWphRzl5UFNKdGFXUmtiR1VpUGt4bGRtVnNjem9nTUR3dmRHVjRkRDQ4TDNOMlp6ND0ifQ=="
        );
    }

    function testGetLevel() public {
        assertEq(chainBattles.getLevel(0), "0");
    }

    function testGenerateCharacter() public {
        assertEq(
            chainBattles.generateCharacter(0),
            "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHByZXNlcnZlQXNwZWN0UmF0aW89InhNaW5ZTWluIG1lZXQiIHZpZXdCb3g9IjAgMCAzNTAgMzUwIj48c3R5bGU+LmJhc2UgeyBmaWxsOiB3aGl0ZTsgZm9udC1mYW1pbHk6IHNlcmlmOyBmb250LXNpemU6IDE0cHg7IH08L3N0eWxlPjxyZWN0IHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGZpbGw9ImJsYWNrIiAvPjx0ZXh0IHg9IjUwJSIgeT0iNDAlIiBjbGFzcz0iYmFzZSIgZG9taW5hbnQtYmFzZWxpbmU9Im1pZGRsZSIgdGV4dC1hbmNob3I9Im1pZGRsZSI+V2FycmlvcjwvdGV4dD48dGV4dCB4PSI1MCUiIHk9IjUwJSIgY2xhc3M9ImJhc2UiIGRvbWluYW50LWJhc2VsaW5lPSJtaWRkbGUiIHRleHQtYW5jaG9yPSJtaWRkbGUiPkxldmVsczogMDwvdGV4dD48L3N2Zz4="
        );
    }

    function testMint() public {
        chainBattles.mint();
        assertEq(chainBattles.totalSupply(), 1);
        assertEq(chainBattles.ownerOf(0), address(this));
        assertEq(chainBattles.balanceOf(address(this)), 1);
        assertEq(chainBattles.tokenOfOwnerByIndex(address(this), 0), 0);
        assertEq(chainBattles.tokenByIndex(0), 0);
        assertEq(
            chainBattles.pubGenerateTokenURI(0),
            "data:application/json;base64,eyJuYW1lIjogIkNoYWluIEJhdHRsZXMgIzAiLCJkZXNjcmlwdGlvbiI6ICJCYXR0bGVzIG9uIGNoYWluIiwiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCNGJXeHVjejBpYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNpSUhCeVpYTmxjblpsUVhOd1pXTjBVbUYwYVc4OUluaE5hVzVaVFdsdUlHMWxaWFFpSUhacFpYZENiM2c5SWpBZ01DQXpOVEFnTXpVd0lqNDhjM1I1YkdVK0xtSmhjMlVnZXlCbWFXeHNPaUIzYUdsMFpUc2dabTl1ZEMxbVlXMXBiSGs2SUhObGNtbG1PeUJtYjI1MExYTnBlbVU2SURFMGNIZzdJSDA4TDNOMGVXeGxQanh5WldOMElIZHBaSFJvUFNJeE1EQWxJaUJvWldsbmFIUTlJakV3TUNVaUlHWnBiR3c5SW1Kc1lXTnJJaUF2UGp4MFpYaDBJSGc5SWpVd0pTSWdlVDBpTkRBbElpQmpiR0Z6Y3owaVltRnpaU0lnWkc5dGFXNWhiblF0WW1GelpXeHBibVU5SW0xcFpHUnNaU0lnZEdWNGRDMWhibU5vYjNJOUltMXBaR1JzWlNJK1YyRnljbWx2Y2p3dmRHVjRkRDQ4ZEdWNGRDQjRQU0kxTUNVaUlIazlJalV3SlNJZ1kyeGhjM005SW1KaGMyVWlJR1J2YldsdVlXNTBMV0poYzJWc2FXNWxQU0p0YVdSa2JHVWlJSFJsZUhRdFlXNWphRzl5UFNKdGFXUmtiR1VpUGt4bGRtVnNjem9nTUR3dmRHVjRkRDQ4TDNOMlp6ND0ifQ=="
        );
        assertEq(chainBattles.getLevel(0), "0");
        assertEq(chainBattles.generateCharacter(0), "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHByZXNlcnZlQXNwZWN0UmF0aW89InhNaW5ZTWluIG1lZXQiIHZpZXdCb3g9IjAgMCAzNTAgMzUwIj48c3R5bGU+LmJhc2UgeyBmaWxsOiB3aGl0ZTsgZm9udC1mYW1pbHk6IHNlcmlmOyBmb250LXNpemU6IDE0cHg7IH08L3N0eWxlPjxyZWN0IHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGZpbGw9ImJsYWNrIiAvPjx0ZXh0IHg9IjUwJSIgeT0iNDAlIiBjbGFzcz0iYmFzZSIgZG9taW5hbnQtYmFzZWxpbmU9Im1pZGRsZSIgdGV4dC1hbmNob3I9Im1pZGRsZSI+V2FycmlvcjwvdGV4dD48dGV4dCB4PSI1MCUiIHk9IjUwJSIgY2xhc3M9ImJhc2UiIGRvbWluYW50LWJhc2VsaW5lPSJtaWRkbGUiIHRleHQtYW5jaG9yPSJtaWRkbGUiPkxldmVsczogMDwvdGV4dD48L3N2Zz4=");
    }
}
