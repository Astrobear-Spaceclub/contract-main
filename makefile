# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

flatten:
    forge flatten src/AstrobearTakeoff.sol --output src/AstrobearTakeoffFlat.sol
script-local:
        forge script script/AstrobearTakeoff.s.sol:AstrobearTakeoffScript --fork-url http://localhost:8545 --private-key ${PRIVATE_KEY} --broadcast
script-testnet:
        forge script script/AstrobearTakeoff.s.sol:AstrobearTakeoffScript --rpc-url ${RINKEBY_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_KEY} -vvvv
script-mainnet:
        forge script script/AstrobearTakeoff.s.sol:AstrobearTakeoffScript --rpc-url ${MAINNET_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_KEY} -vvvv