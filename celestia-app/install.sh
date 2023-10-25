#!/bin/bash

# Create a log file to capture detailed logs
LOGFILE="$HOME/celestia-temp/logfile.log"
mkdir -p "$HOME/celestia-temp"
touch "$LOGFILE"

# Log and print the log file location
echo "Log file is located at: $LOGFILE" | tee -a "$LOGFILE"

# Create a temporary directory to work from
TEMP_DIR="$HOME/celestia-temp"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Log and print a message
echo "Working from temporary directory: $TEMP_DIR" | tee -a "$LOGFILE"

# Fetch the latest release tag from GitHub
VERSION=$(curl -s "https://api.github.com/repos/celestiaorg/celestia-app/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# Log and print a message
echo "Latest version detected: $VERSION" | tee -a "$LOGFILE"

# Detect the operating system and architecture
OS=$(uname -s)
ARCH=$(uname -m)

# Translate architecture to expected format
case $ARCH in
    x86_64)
        ARCH="x86_64"
        ;;
    aarch64|arm64)
        ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture." | tee -a "$LOGFILE"
        exit 1
        ;;
esac

# Translate OS to expected format
case $OS in
    Linux|Darwin)
        ;;
    *)
        echo "Unsupported operating system." | tee -a "$LOGFILE"
        exit 1
        ;;
esac

# Construct the download URL
PLATFORM="${OS}_${ARCH}"
URL="https://github.com/celestiaorg/celestia-app/releases/download/$VERSION/celestia-app_$PLATFORM.tar.gz"

# Log and print a message
echo "Downloading from: $URL" | tee -a "$LOGFILE"

# Download the tarball
if ! wget "$URL" >> "$LOGFILE" 2>&1; then
    echo "Download failed. Exiting." | tee -a "$LOGFILE"
    exit 1
fi

# Detect if running on macOS and use appropriate command for checksum
if [ "$OS" = "Darwin" ]; then
    CALCULATED_CHECKSUM=$(shasum -a 256 "celestia-app_$PLATFORM.tar.gz" | awk '{print $1}')
else
    CALCULATED_CHECKSUM=$(sha256sum "celestia-app_$PLATFORM.tar.gz" | awk '{print $1}')
fi

# Download checksums.txt
if ! wget "https://github.com/celestiaorg/celestia-app/releases/download/$VERSION/checksums.txt" >> "$LOGFILE" 2>&1; then
    echo "Failed to download checksums. Exiting." | tee -a "$LOGFILE"
    exit 1
fi

# Find the expected checksum in checksums.txt
EXPECTED_CHECKSUM=$(grep "celestia-app_$PLATFORM.tar.gz" checksums.txt | awk '{print $1}')

# Verify the checksum
if [ "$CALCULATED_CHECKSUM" != "$EXPECTED_CHECKSUM" ]; then
    echo "Checksum verification failed. Exiting." | tee -a "$LOGFILE"
    exit 1
else
    echo "Checksum verification successful." | tee -a "$LOGFILE"
fi

# Extract the tarball to the temporary directory
if ! tar -xzf "celestia-app_$PLATFORM.tar.gz" >> "$LOGFILE" 2>&1; then
    echo "Extraction failed. Exiting." | tee -a "$LOGFILE"
    exit 1
fi

# Log and print a message
echo "Binary extracted to: $TEMP_DIR" | tee -a "$LOGFILE"

# Remove the tarball to clean up
rm "celestia-app_$PLATFORM.tar.gz"

# Log and print a message
echo "Temporary files cleaned up." | tee -a "$LOGFILE"

# Provide final instructions to the user
echo "You can navigate to $TEMP_DIR to find and run the Celestia app." | tee -a "$LOGFILE"
echo "To run the app and check its version, you may execute the following commands:" | tee -a "$LOGFILE"
echo "  cd $TEMP_DIR" | tee -a "$LOGFILE"
echo "  chmod +x celestia-appd" | tee -a "$LOGFILE"
echo "  ./celestia-appd version" | tee -a "$LOGFILE"
