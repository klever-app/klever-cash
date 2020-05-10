#!/bin/bash

klever-cli query account $(klever-cli keys show jack -a) | jq ".value.coins[0]"
klever-cli query account $(klever-cli keys show alice -a) | jq ".value.coins[0]"

# Buy your first name using your coins from the genesis file
klever-cli tx nameservice buy-name jack.id 5nametoken --from jack -y | jq ".txhash" |  xargs $(sleep 6) klever-cli q tx

# Set the value for the name you just bought
klever-cli tx nameservice set-name jack.id 8.8.8.8 --from jack -y | jq ".txhash" |  xargs $(sleep 6) klever-cli q tx

# Try out a resolve query against the name you registered
klever-cli query nameservice resolve jack.id | jq ".value"
# > 8.8.8.8

# Try out a whois query against the name you just registered
klever-cli query nameservice whois jack.id
# > {"value":"8.8.8.8","owner":"cosmos1l7k5tdt2qam0zecxrx78yuw447ga54dsmtpk2s","price":[{"denom":"nametoken","amount":"5"}]}

# Alice buys name from jack
klever-cli tx nameservice buy-name jack.id 10nametoken --from alice -y | jq ".txhash" |  xargs $(sleep 6) klever-cli q tx

# Alice decides to delete the name she just bought from jack
klever-cli tx nameservice delete-name jack.id --from alice -y | jq ".txhash" |  xargs $(sleep 6) klever-cli q tx

# Try out a whois query against the name you just deleted
klever-cli query nameservice whois jack.id
# > {"value":"","owner":"","price":[{"denom":"nametoken","amount":"1"}]}