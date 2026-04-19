#!/usr/bin/env bash
set -euo pipefail

ARTIFACT_NAME="ec2-metadata-app.tar.gz"
BUILD_DIR="build/ec2-metadata-app"

rm -rf build
mkdir -p "${BUILD_DIR}"

cp -r app "${BUILD_DIR}/"
cp requirements.txt "${BUILD_DIR}/"
cp scripts/install.sh "${BUILD_DIR}/"

tar -czf "build/${ARTIFACT_NAME}" -C build ec2-metadata-app

echo "Artifact created: build/${ARTIFACT_NAME}"