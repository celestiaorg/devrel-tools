#!/bin/sh

VALIDATOR_NAME=validator1
CHAIN_ID=recipe
KEY_NAME=recipe-key
CHAINFLAG="--chain-id ${CHAIN_ID}"
TOKEN_AMOUNT="10000000000000000000000000stake"
STAKING_AMOUNT="1000000000stake"

NAMESPACE_ID=$(echo $RANDOM | md5sum | head -c 16; echo;)
echo $NAMESPACE_ID
DA_BLOCK_HEIGHT=$(curl https://rpc.limani.celestia-devops.dev/block?height | jq -r '.result.block.header.height')
echo $DA_BLOCK_HEIGHT

rm -rf "$HOME"/.reciped
reciped tendermint unsafe-reset-all
reciped init $VALIDATOR_NAME --chain-id $CHAIN_ID

reciped keys add $KEY_NAME --keyring-backend test
reciped add-genesis-account $KEY_NAME $TOKEN_AMOUNT --keyring-backend test
reciped gentx $KEY_NAME $STAKING_AMOUNT --chain-id $CHAIN_ID --keyring-backend test
reciped start --rollmint.aggregator true --rollmint.da_layer celestia --rollmint.da_config='{"base_url":"http://localhost:26659","timeout":60000000000,"gas_limit":6000000}' --rollmint.namespace_id $NAMESPACE_ID --rollmint.da_start_height $DA_BLOCK_HEIGHT
