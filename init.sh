#!/usr/bin/env bash

rm -rf ~/.klever-node
rm -rf ~/.klever-cli

klever-node init test --chain-id=klever-chain

klever-cli keys add test1
klever-cli keys add test2

klever-node add-genesis-account $(klever-cli keys show test1 -a) 10000000000klv
klever-node add-genesis-account $(klever-cli keys show test2 -a) 10000000000klv

klever-cli config output json
klever-cli config indent true
klever-cli config trust-node true
klever-cli config chain-id klever-chain

klever-node gentx --name test1

echo "Collecting genesis txs..."
klever-node collect-gentxs

echo "Validating genesis file..."
klever-node validate-genesis