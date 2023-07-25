# Development Container Features

<!-- markdownlint-disable no-inline-html -->
<table style="width: 100%; border-style: none;"><tr>
<td style="width: 140px; text-align: center;"><a href="https://github.com/devcontainers"><img width="128px" src="https://raw.githubusercontent.com/microsoft/fluentui-system-icons/78c9587b995299d5bfc007a0077773556ecb0994/assets/Cube/SVG/ic_fluent_cube_32_filled.svg" alt="devcontainers organization logo"/></a></td>
<td>
<strong>Development Container 'Features'</strong><br />
<i>A set of simple and reusable Features. Quickly add a language/tool/CLI to a development container.
</td>
</tr></table>
<!-- markdownlint-enable no-inline-html -->

'Features' are self-contained units of installation code and development container configuration.
Features are designed to install atop a wide-range of base container images (**this repository focuses on debian based images**).

Missing a CLI or language in your otherwise _perfect_ container image? Add the relevant Feature to the `features`
property of a [`devcontainer.json`](https://containers.dev/implementors/json_reference/#general-properties). A
[tool supporting the dev container specification](https://containers.dev/supporting) is required to build a development
container.

You may learn about Features at [containers.dev](https://containers.dev/implementors/features/), which is the website for the dev container specification.

## Usage

To reference a Feature from this repository, add the desired Features to a `devcontainer.json`. Each Feature has a `README.md` that shows how to reference the Feature and which options are available for that Feature.

The example below installs the `puppet` feature declared in the [`./src`](./src) directory of this
repository.

See the relevant Feature's README for supported options.

```jsonc
"name": "my-project-devcontainer",
"image": "mcr.microsoft.com/devcontainers/base:ubuntu",  // Any generic, debian-based image.
"features": {
    "ghcr.io/flokoe/devcontainer-features/puppet:1": {
        "version": "latest"
    }
}
```

## Repo Structure

```plain
.
├── README.md
├── src
│   ├── puppet
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
├── test
│   ├── puppet
│   │   └── test.sh
...
```

- [`src`](src) - A collection of subfolders, each declaring a Feature.
  Each subfolder contains at least a `devcontainer-feature.json` and an `install.sh` script.
- [`test`](test) - Mirroring `src`, a folder-per-feature with at least a `test.sh` script.
  The [`devcontainer` CLI](https://github.com/devcontainers/cli) will execute [these tests in CI](https://github.com/devcontainers/features/blob/main/.github/workflows/test-all.yaml).

## Contributions

This repository will accept improvement and bug fix contributions related to the [current set of maintained Features](./src).
