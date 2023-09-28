#!/usr/bin/env bash

set -e

# Optional: Import test library bundled with the devcontainer CLI
# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib. Syntax is...
# check <LABEL> <cmd> [args...]

# shellcheck disable=SC2016
check '`~/.config/Bitwarden CLI` existence' test -d "$HOME/.config/Bitwarden CLI"

# shellcheck disable=SC2016
check '`/dc/bitwarden-cli` existence' test -d /dc/bitwarden-cli

# shellcheck disable=SC2016
check '`~/.config/Bitwarden CLI` is a symlink' test -L "$HOME/.config/Bitwarden CLI"

# shellcheck disable=SC2016
check '`~/.config/Bitwarden CLI` is writable' test -w "$HOME/.config/Bitwarden CLI"

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
