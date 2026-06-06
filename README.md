# sing-box deb package

## Install

```bash
sudo apt install sing-box_<x.xx.x>_amd64.deb
sudo apt install sing-box_<x.xx.x>_arm64.deb
```

GitHub Releases publish both Debian architectures for each synced sing-box tag:

- `sing-box_<version>_amd64.deb`
- `sing-box_<version>_arm64.deb`

## Build

```bash
bash scripts/build.sh <tag> amd64
bash scripts/package.sh <tag> amd64
```

For arm64:

```bash
bash scripts/build.sh <tag> arm64
bash scripts/package.sh <tag> arm64
```

## Backfill an existing release

Run the `Build and Package sing-box` workflow manually, set `version` to the
existing sing-box tag, and enable `force_update`. The workflow rebuilds both
`amd64` and `arm64` packages and updates the existing GitHub Release assets.

## Uninstall

```bash
sudo apt remove sing-box
```
