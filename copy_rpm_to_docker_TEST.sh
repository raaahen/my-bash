#!/bin/bash

# Check for sufficient arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <container_name>:<path>"
    exit 1
fi

# Extract container name and path
ARG=$1
DOCKER_CONTAINER=$(echo "$ARG" | cut -d: -f1)
CONTAINER_PATH=$(echo "$ARG" | cut -d: -f2-)

# Validate container and path
if [ -z "$DOCKER_CONTAINER" ] || [ -z "$CONTAINER_PATH" ]; then
    echo "Error: Provide container and path in the format <container_name>:<path>."
    exit 1
fi

# Directory where *.rpm is usually located
RPM_DIR="target/rpm"

# Check if RPM directory exists
if [ ! -d "$RPM_DIR" ]; then
    echo "Error: Directory '$RPM_DIR' not found."
    exit 1
fi

# Find the latest built RPM file
RPM_FILE=$(find "$RPM_DIR" -type f -name "*.rpm" | sort -n | tail -n 1)

if [ -z "$RPM_FILE" ]; then
    echo "Error: No RPM files found in '$RPM_DIR'."
    exit 1
fi

echo "Found RPM file: $RPM_FILE"

# Copy RPM file to Docker container
echo "Copying $RPM_FILE to container $DOCKER_CONTAINER:$CONTAINER_PATH ..."
docker cp "$RPM_FILE" "$DOCKER_CONTAINER:$CONTAINER_PATH"

if [ $? -eq 0 ]; then
    echo "Successfully copied $(du -h "$RPM_FILE" | cut -f1) to $DOCKER_CONTAINER:$CONTAINER_PATH"
else
    echo "Error while copying the file."
    exit 1
fi
