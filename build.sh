#!/bin/bash

APP_NAME="silk-datalake"
SRC_DIR="./cmd/app"
BUILD_DIR="build"
BINARY_NAME="silk-datalake-binary"

# Build the Go application for Linux
echo "Building the Go application for Linux..."
GOOS=linux GOARCH=amd64 go build -o "$BUILD_DIR/$BINARY_NAME" "$SRC_DIR"

# Check if the build was successful
if [ $? -eq 0 ]; then
  echo "Build successful!"
else
  echo "Build failed!"
  exit 1
fi

# Create a zip file
echo "Creating zip file..."
cd "$BUILD_DIR" || exit
zip "$APP_NAME.zip" "$BINARY_NAME"

# Check if zip creation was successful
if [ $? -eq 0 ]; then
  echo "Zip file created: $APP_NAME.zip"
else
  echo "Failed to create zip file!"
  exit 1
fi

# Clean up the binary file
echo "Cleaning up..."
rm "$BINARY_NAME"

echo "Done."
