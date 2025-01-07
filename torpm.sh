#!/bin/bash

# Find the first *.rpm file recursively from the current directory
RPM_FILE=$(find . -type f -name "*.rpm" | sort -n | head -n 1)

# Check if an RPM file was found
if [ -z "$RPM_FILE" ]; then
    echo "Error: No RPM file found in the current directory or its subdirectories."
    exit 1
fi

# Extract the directory containing the RPM file
RPM_DIR=$(dirname "$RPM_FILE")

# Move to the directory containing the RPM file
cd "$RPM_DIR" || exit
echo "Moved to directory: $(pwd)"
