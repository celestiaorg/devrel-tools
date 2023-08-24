#!/bin/bash
set -e

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="amd64"
elif [[ "$ARCH" == "arm64" ]] || [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
fi

# Define the version of Golang and Celestia Node you want to install
GOLANG_VERSION="1.20.2"
CELESTIA_NODE_VERSION="v0.11.0-rc8"

# Install Golang
cd $HOME
if [[ "$OS" == "darwin" ]]; then
    wget "https://golang.org/dl/go$GOLANG_VERSION.darwin-$ARCH.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "go$GOLANG_VERSION.darwin-$ARCH.tar.gz"
    rm "go$GOLANG_VERSION.darwin-$ARCH.tar.gz"
else
    wget "https://golang.org/dl/go$GOLANG_VERSION.linux-$ARCH.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "go$GOLANG_VERSION.linux-$ARCH.tar.gz"
    rm "go$GOLANG_VERSION.linux-$ARCH.tar.gz"
fi

# Install Celestia Node
cd $HOME
rm -rf celestia-node
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/
git checkout tags/$CELESTIA_NODE_VERSION
make build
make install
make cel-key

# Instantiate a Celestia light node
celestia light init --p2p.network arabica

echo "Installation complete! You can now use Celestia Node from your terminal."