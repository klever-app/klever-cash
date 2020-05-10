## Klever Blockchain - Digital Assets

A cryptocurrency for the next century. A new blockchain home for all kinds of digital assets.

Klever Chain builds on top of Tendermint Byzantine Fault Tolerant (BFT) consensus and the Cosmos SDK.

## Building the `klever-node` application

This repo contains a complete `klever-node` application. If you want to build this completed version **Go 1.13.0+** is required.

Add some parameters to environment is necessary if you have never used the `go mod` before.

```bash
mkdir -p $HOME/go/bin
echo "export GOBIN=\$GOPATH/bin" >> ~/.bash_profile
echo "export PATH=\$PATH:\$GOBIN" >> ~/.bash_profile
source ~/.bash_profile
```

### To install:
```
go mod tidy
make install

```


## Running the live network and using the commands

To initialize configuration and a `genesis.json` file for your application and an account for the transactions, start by running:

> _*NOTE*_: If you have run the tutorial before, you can start from scratch with a `klever-node unsafe-reset-all` or by deleting both of the home folders `rm -rf ~/.klever-cli ~/.klever-node`

> _*NOTE*_: If you have the Cosmos app for ledger and you want to use it, when you create the key with `klever-cli keys add jack` just add `--ledger` at the end. That's all you need. When you sign, `jack` will be recognized as a Ledger key and will require a device.

> _*NOTE*_: The following commands combined with `rm -rf ~/.klever-cli ~/.klever-node` are also collected in the `init.sh` file in the root directory of this project. You can execute all of these commands using default values at once by running `./init.sh` in your terminal.

```bash
# Initialize configuration files and genesis file
# moniker is the name of your node
klever-node init <moniker> --chain-id namechain

# Configure your CLI to eliminate need to declare them as flags
klever-cli config chain-id namechain
klever-cli config output json
klever-cli config indent true
klever-cli config trust-node true

# We'll use the "test" keyring backend which save keys unencrypted in the configuration directory of your project (defaults to ~/.klever). You should **never** use the "test" keyring backend in production. For more information about other options for keyring-backend take a look at https://docs.cosmos.network/master/interfaces/keyring.html
klever-cli config keyring-backend test 

# Copy the `Address` output here and save it for later use
# [optional] add "--ledger" at the end to use a Ledger Nano S
klever-cli keys add jack

# Copy the `Address` output here and save it for later use
klever-cli keys add alice

# Add both accounts, with coins to the genesis file
klever-node add-genesis-account $(klever-cli keys show gen -a) 9800000000klv
klever-node add-genesis-account $(klever-cli keys show adm -a) 200000000klv

# The "klever-cli config" command saves configuration for the "klever-cli" command but not for "klever-node" so we have to 
# declare the keyring-backend with a flag here
klever-node gentx --name jack <or your key_name> --keyring-backend test
```

> Note: There is not a need to specify an amount as by default it will set the minimum.

After you have generated a genesis transaction, you will have to input the genTx into the genesis file, so that your nameservice chain is aware of the validators. To do so, run:

`klever-node collect-gentxs`

and to make sure your genesis file is correct, run:

`klever-node validate-genesis`

You can now start `klever-node` by calling `klever-node start`. You will see logs begin streaming that represent blocks being produced, this will take a couple of seconds.

You have run your first node successfully.

```bash
# First check the accounts to ensure they have funds
klever-cli query account $(klever-cli keys show jack -a)
klever-cli query account $(klever-cli keys show alice -a)

# Buy your first name using your coins from the genesis file
klever-cli tx nameservice buy-name jack.id 5nametoken --from jack

# Set the value for the name you just bought
klever-cli tx nameservice set-name jack.id 8.8.8.8 --from jack

# Try out a resolve query against the name you registered
klever-cli query nameservice resolve jack.id
# > 8.8.8.8

# Try out a whois query against the name you just registered
klever-cli query nameservice whois jack.id
# > {"value":"8.8.8.8","owner":"cosmos1l7k5tdt2qam0zecxrx78yuw447ga54dsmtpk2s","price":[{"denom":"nametoken","amount":"5"}]}

# Alice buys name from jack
klever-cli tx nameservice buy-name jack.id 10nametoken --from alice

# Alice decides to delete the name she just bought from jack
klever-cli tx nameservice delete-name jack.id --from alice

# Try out a whois query against the name you just deleted
klever-cli query nameservice whois jack.id
# > {"value":"","owner":"","price":[{"denom":"nametoken","amount":"1"}]}
```

# Run second node on another machine (Optional)

Open terminal to run commands against that just created to install klever and klever-cli

## init use another moniker and same namechain

```bash
klever-node init <moniker-2> --chain-id namechain
```

## overwrite ~/.klever-node/config/genesis.json with first node's genesis.json

## change persistent_peers

```bash
vim /.klever-node/config/config.toml
persistent_peers = "id@first_node_ip:26656"
```

To find the node id of the first machine, run the following command on that machine:

```bash
klever-node tendermint show-node-id
```

## start this second node

```bash
klever-node start
```

### Available commands
```
klever-cli --help
klever --help
```

### klever node
```
$ klever-node
```

```
Klever Chain Daemon (server)

Usage:
  klever-node [command]

Available Commands:
  init                Initialize private validator, p2p, genesis, and application configuration files
  collect-gentxs      Collect genesis txs and output a genesis.json file
  migrate             Migrate genesis to a specified target version
  gentx               Generate a genesis tx carrying a self delegation
  validate-genesis    validates the genesis file at the default location or at the location passed as an arg
  add-genesis-account Add a genesis account to genesis.json
  debug               Tool for helping with debugging your application
  start               Run the full node
  unsafe-reset-all    Resets the blockchain database, removes address book files, and resets priv_validator.json to the genesis state
                      
  tendermint          Tendermint subcommands
  export              Export state to JSON
                      
  version             Print the app version
  help                Help about any command

Flags:
  -h, --help                    help for klever-node
      --home string             directory for config and data (default "/Users/USERNAME/.klever-node")
      --inv-check-period uint   Assert registered invariants every N blocks
      --log_level string        Log level (default "main:info,state:info,*:error")
      --trace                   print out full stack trace on errors

Use "klever-node [command] --help" for more information about a command.
```

```
$ klever-cli
```

```
Command line interface for interacting with appd

Usage:
  klever-cli [command]

Available Commands:
  status      Query remote node for status
  config      Create or query an application CLI configuration file
  query       Querying subcommands
  tx          Transactions subcommands
              
  rest-server Start LCD (light-client daemon), a local REST server
              
  keys        Add or view local private keys
              
  version     Print the app version
  help        Help about any command

Flags:
      --chain-id string   Chain ID of tendermint node
  -e, --encoding string   Binary encoding (hex|b64|btc) (default "hex")
  -h, --help              help for klever-cli
      --home string       directory for config and data (default "/Users/USERNAME/.klever-cli")
  -o, --output string     Output format (text|json) (default "text")
      --trace             print out full stack trace on errors

Use "klever-cli [command] --help" for more information about a command.
```
