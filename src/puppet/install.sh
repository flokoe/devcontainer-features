#!/usr/bin/env bash

set -e

readonly PUPPET_VERSION=${VERSION:-"8"}
readonly PUPPET_RELEASE_GPG_KEY="D6811ED3ADEEB8441AF5AA8F4528B6CD9E61EF26"
GPG_KEY_SERVERS="keyserver hkp://keyserver.ubuntu.com
keyserver hkps://keys.openpgp.org
keyserver hkp://keyserver.pgp.com"

# Get current architecture
ARCHITECTURE="$(dpkg --print-architecture)"

# check supported arch
if [[ ! $ARCHITECTURE =~ ^(amd64|x86_64|i386) ]]; then
    echo "ERROR: Architecture $ARCHITECTURE is not supported!" >&2
    exit 1
fi

# Get information about os
# shellcheck source=/dev/null
source /etc/os-release

# Check if Distriution is debian based
if [[ ! $ID =~ ^(debian|ubuntu) ]]; then
    echo "ERROR: Distributions based on ${ID^} are not supported!" >&2
    exit 1
fi

# Check if Codename is supported
# if [[ ! $VERSION_CODENAME =~ ^(bullseye|buster|stretch|jammy|focal) ]]; then
#     echo "ERROR: Distribution Codename ${ID^} is not supported!" >&2
#     exit 1
# fi

receive_gpg_keys() {
    local keys=${!1}
    local keyring_args=""
    if [ ! -z "$2" ]; then
        mkdir -p "$(dirname \"$2\")"
        keyring_args="--no-default-keyring --keyring $2"
    fi

    # Use a temporary location for gpg keys to avoid polluting image
    export GNUPGHOME="/tmp/tmp-gnupg"
    mkdir -p ${GNUPGHOME}
    chmod 700 ${GNUPGHOME}
    echo -e "disable-ipv6\n${GPG_KEY_SERVERS}" > ${GNUPGHOME}/dirmngr.conf
    # GPG key download sometimes fails for some reason and retrying fixes it.
    local retry_count=0
    local gpg_ok="false"
    set +e
    until [ "${gpg_ok}" = "true" ] || [ "${retry_count}" -eq "5" ]; 
    do
        echo "(*) Downloading GPG key..."
        ( echo "${keys}" | xargs -n 1 gpg -q ${keyring_args} --recv-keys) 2>&1 && gpg_ok="true"
        if [ "${gpg_ok}" != "true" ]; then
            echo "(*) Failed getting key, retring in 10s..."
            (( retry_count++ ))
            sleep 10s
        fi
    done
    set -e
    if [ "${gpg_ok}" = "false" ]; then
        echo "(!) Failed to get gpg key."
        exit 1
    fi
}

apt_get_update() {
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

echo "Start installing puppet-agent and pdk..."

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

check_packages curl ca-certificates gnupg2 dirmngr apt-transport-https debian-archive-keyring

# Get GPG Key and add source list
receive_gpg_keys PUPPET_RELEASE_GPG_KEY /usr/share/keyrings/puppet.gpg
echo -e "deb [arch=${ARCHITECTURE} signed-by=/usr/share/keyrings/puppet.gpg] https://apt.puppet.com ${VERSION_CODENAME} puppet${PUPPET_VERSION}" >/etc/apt/sources.list.d/puppet.list

apt-get update -y
apt-get install -y puppet-agent pdk

# Clean up
rm -rf /tmp/tmp-gnupg
rm -rf /var/lib/apt/lists/*

echo "Done!"
