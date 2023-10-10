
# Puppet Agent and PDK (puppet)

Install and configure Puppet Agent and PDK via official Puppetlabs repository and Puppet extension for VS Code. This feature is intended for Puppet code/modules development.

## Example Usage

```json
"features": {
    "ghcr.io/flokoe/devcontainer-features/puppet:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select Puppet version to install. | string | latest |
| installBolt | Install Bolt, a tool to orchestrate and automate manual work without the need for an agent. | boolean | false |

## Customizations

### VS Code Extensions

- `puppet.puppet-vscode`

## OS Support

This Feature should work on recent versions of Debian/Ubuntu-based distributions with the `apt` package manager installed.

`bash` is required to execute the `install.sh` script.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/flokoe/devcontainer-features/blob/main/src/puppet/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
