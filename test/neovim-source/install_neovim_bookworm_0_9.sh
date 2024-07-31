#!/bin/bash
set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
check "Version starts with '0.9.'" bash -c "nvim -v | head -n1 | grep -q '^NVIM v0.9.' && exit 0 || exit 1"

# Report results
reportResults
