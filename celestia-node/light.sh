#!/bin/bash
set -e

echo "Welcome to your Celestia light node. Please choose a network:"
echo "1) Arabica 🌱"
echo "2) Mocha ☕"
read -p "Enter choice: " CHOICE

if [[ "$CHOICE" == "1" ]]; then
    NETWORK="arabica"
    GOLANG_VERSION="1.21.0"
    CELESTIA_NODE_VERSION="v0.11.0-rc8-arabica-improvements"
elif [[ "$CHOICE" == "2" ]]; then
    NETWORK="mocha"
    GOLANG_VERSION="1.20.2"
    CELESTIA_NODE_VERSION="v0.11.0-rc8"
else
    echo "Invalid choice. Please enter 1 for Arabica or 2 for Mocha."
    exit 1
fi

echo "🔍  Determining OS and architecture..."

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="amd64"
elif [[ "$ARCH" == "arm64" ]] || [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
fi

echo "💻  OS: $OS"
echo "🏗️  ARCH: $ARCH"

echo "🐹  Golang version required for $NETWORK: $GOLANG_VERSION"
echo "🌌  Celestia Node version required for $NETWORK: $CELESTIA_NODE_VERSION"

# Check if Golang is installed and the version matches
INSTALLED_GOLANG_VERSION=$(go version | awk '{print $3}' 2>/dev/null || echo "")
if ! command -v go &> /dev/null || [[ "$INSTALLED_GOLANG_VERSION" != "go$GOLANG_VERSION" ]]
then
    echo "💾  Golang is not installed or the version does not match."
    echo "💿  Installing version $GOLANG_VERSION..."
    # Golang installation code...
    cd $HOME
    if [[ "$OS" == "darwin" ]]; then
        wget -q "https://golang.org/dl/go$GOLANG_VERSION.darwin-$ARCH.tar.gz"
        echo "🔑  Admin access is required to install Golang. Please enter your password if prompted."
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf "go$GOLANG_VERSION.darwin-$ARCH.tar.gz" > /dev/null
        rm "go$GOLANG_VERSION.darwin-$ARCH.tar.gz"
    else
        wget -q "https://golang.org/dl/go$GOLANG_VERSION.linux-$ARCH.tar.gz"
        echo "🔑  Admin access is required to install Golang. Please enter your password if prompted."
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf "go$GOLANG_VERSION.linux-$ARCH.tar.gz" > /dev/null
        rm "go$GOLANG_VERSION.linux-$ARCH.tar.gz"
    fi
    echo "✅  Golang installed."
else
    echo "✅  Golang is already installed and the version matches."
fi

# Check if Celestia Node is installed and the version matches
INSTALLED_CELESTIA_VERSION=$(celestia version | head -n 1 | awk '{print $3}' 2>/dev/null || echo "")
if ! command -v celestia &> /dev/null || [[ "$INSTALLED_CELESTIA_VERSION" != "$CELESTIA_NODE_VERSION" ]]
then
    echo "💾  Celestia Node is not installed or the version does not match."
    echo "💿  Installing version $CELESTIA_NODE_VERSION..."
    cd $HOME
    rm -rf celestia-node
    git clone -q https://github.com/celestiaorg/celestia-node.git
    cd celestia-node/
    git checkout -q tags/$CELESTIA_NODE_VERSION

    echo "🔨  Building Celestia..."
    make build > /dev/null

    if [[ "$OS" == "darwin" ]]; then
        echo "🔧  Installing Celestia..."
        make go-install > /dev/null
    else
        echo "🔧  Installing Celestia..."
        echo "🔑  Admin access is required to install Celestia. Please enter your password if prompted."
        make install > /dev/null
    fi

    echo "🔑  Building cel-key..."
    make cel-key > /dev/null

    echo "✅  Celestia Node installed."
else
    echo "✅  Celestia Node is already installed and the version matches."
fi

# Instantiate a Celestia light node
echo "🚀  Instantiating a Celestia light node..."
celestia light init --p2p.network $NETWORK > /dev/null

echo "🎉  Installation complete! You can now use Celestia Node from your terminal."

# Start the Celestia light node
echo "🚀  Starting Celestia light node on $NETWORK network..."
echo ""
celestia light start --p2p.network $NETWORK