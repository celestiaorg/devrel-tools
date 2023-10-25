# Create a temporary directory to work from
TEMP_DIR="$HOME/celestia-temp"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

echo "Working from temporary directory: $TEMP_DIR"

# Set the latest compatible tag
VERSION=v1.1.0

echo "Latest version detected: $VERSION"

# Detect the operating system and architecture
OS=$(uname -s)
ARCH=$(uname -m)

# Translate architecture to expected format
case $ARCH in
    x86_64)
        ARCH="x86_64"
        ;;
    aarch64)
        ARCH="arm64"
        ;;
    arm64)
        ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture."
        exit 1
        ;;
esac

# Translate OS to expected format
case $OS in
    Linux)
        OS="Linux"
        ;;
    Darwin)
        OS="Darwin"
        ;;
    *)
        echo "Unsupported operating system."
        exit 1
        ;;
esac

# Construct the download URL
PLATFORM="${OS}_${ARCH}"
URL="https://github.com/celestiaorg/celestia-app/releases/download/$VERSION/celestia-app_$PLATFORM.tar.gz"

echo "Downloading from: $URL"

# Download the tarball
if ! wget "$URL"; then
    echo "Download failed. Exiting."
    exit 1
fi

# Extract the tarball to the temporary directory
if ! tar -xzf "celestia-app_$PLATFORM.tar.gz"; then
    echo "Extraction failed. Exiting."
    exit 1
fi

echo "Binary extracted to: $TEMP_DIR"

# Remove the tarball to clean up
rm "celestia-app_$PLATFORM.tar.gz"

echo "Temporary files cleaned up."

# Provide final instructions to the user
echo "You can navigate to $TEMP_DIR to find and run the Celestia app."
echo "To run the app and check its version, you may execute the following commands:"
echo "  cd $TEMP_DIR"
echo "  chmod +x celestia-appd"
echo "  ./celestia-appd version"