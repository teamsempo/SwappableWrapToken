# SwappableWrapToken
Used to enable *forced* upgrading of an external ERC20 token by wrapping it through an ERC677 compliant proxy.
When it's time to upgrade, invoke `swapWrap` and specify the new token that should be wrapped in lieu of the current token.
Using a multisig wallet to ensure there's some oversight of how the owner invokews `swapWrap` is highly recommended.
