# Celestia Node Scripts

This repository contains several scripts to help you set up and run Celestia Node on different networks.

## mocha.sh and arabica.sh

`mocha.sh` and `arabica.sh` are newer versions of the `light.sh` script. They perform the following tasks:

- Determine the operating system and architecture of your machine.
- Define the required versions of Golang and Celestia Node.
- Check if the required Golang version is already installed. If not, or if the installed version does not match the required version, the script downloads and installs the correct version.
- Check if the required Celestia Node version is already installed. If not, or if the installed version does not match the required version, the script downloads and installs the correct version.
- Instantiate a Celestia light node on the network specified by the script (Mocha or Arabica).
- Start the Celestia light node on the specified network.

These scripts are more efficient than `light.sh` because they do not download software that is already installed on your machine and matches the required version.

To run these scripts, navigate to the directory containing the script and run `./<script-name>.sh` in your terminal.

### run from your terminal

Alternatively, you can clone and run them with:

#### Arabica devnet

```bash
curl -L https://raw.githubusercontent.com/celestiaorg/devrel-tools/main/celestia-node/arabica.sh | bash
```

#### Mocha testnet

```bash
curl -L https://raw.githubusercontent.com/celestiaorg/devrel-tools/main/celestia-node/mocha.sh | bash
```

## light.sh

`light.sh` was the first version of these scripts. It performs the following tasks:

- Checks the operating system and architecture of your machine.
- Downloads and installs the Celestia Node version `v0.11.0-rc8`.
- Downloads and installs Golang version `1.20.2`.
- Starts a Celestia light node.

Please note that this script does not check if the required software is already installed on your machine. It will download and install the software regardless.
