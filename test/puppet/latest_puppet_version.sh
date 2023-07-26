#!/usr/bin/env bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib. Syntax is...
# check <LABEL> <cmd> [args...]
latest_version="$(git ls-remote --tags https://github.com/puppetlabs/puppet |grep -oP '\d+\.\d+\.\d+$' | sort -V |tail -n1)"
export PDK_DISABLE_ANALYTICS=true

check "latest puppet version ${latest_version} installed" puppet --version | grep "$latest_version"
check "pdk version" pdk --version

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults