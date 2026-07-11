### Recommended Repository Name

**`arch-pk-suite`**

It is concise, descriptive, follows Arch community naming conventions, and clearly communicates that this is a collection of package management utilities rather than a single tool. Alternatives like `fish-arch-pkg` or `pk-scripts` are either too generic or don't convey the "suite" aspect.

---

### README.md

````markdown
# arch-pk-suite

A set of smart Fish shell functions for Arch Linux that unify `pacman` and `yay` workflows into simple 3-character commands. No more guessing whether a package was installed from official repos or the AUR.

> 👤 Author: [@iSalehGholami](https://github.com/iSalehGholami)

## Why?

On Arch, you constantly juggle two package managers:

- Was it `postman` or `postman-bin`?
- Did I install it via `pacman` or `yay`?
- Is this package from official repos or the AUR?

This suite eliminates that mental overhead. Every command auto-detects the correct tool and package variant.

## Commands

| Short | Longform    | Description                                              |
| ----- | ----------- | -------------------------------------------------------- |
| `pki` | `pkginst`   | Install — tries `pacman` first, falls back to `yay`      |
| `pkr` | `pkgremove` | Remove — finds any matching variant, purges orphans      |
| `pkf` | `pkginfo`   | Info — shows source (repo/AUR), version, metadata        |
| `pkl` | `pkgls`     | List — all installed packages with `[repo]`/`[aur]` tags |

### Examples

```fish
# Install ripgrep (auto-detects pacman vs yay)
pki ripgrep

# Remove postman (finds postman-bin automatically)
pkr postman

# Check where spotify came from
pkf spotify

# List all AUR packages
pkl | grep '\[aur\]'

# Filter installed packages by name
pkl git
```
````

## Installation

### Option 1: Standalone (single file)

```fish
curl -LO https://raw.githubusercontent.com/iSalehGholami/arch-pk-suite/main/install-pk-standalone.fish
fish install-pk-standalone.fish
rm install-pk-standalone.fish
```

### Option 2: From source (editable)

```fish
git clone https://github.com/iSalehGholami/arch-pk-suite.git
cd arch-pk-suite
fish install-pk.fish
```

Both methods install functions to `~/.config/fish/functions/`. Open a new terminal tab after installing.

## Project Structure

```
arch-pk-suite/
├── install-pk-standalone.fish   # Self-contained installer
├── install-pk.fish     # Reads from pkgscripts/
└── pkgscripts/                  # Individual function bodies
    ├── pki.fish
    ├── pkginst.fish
    ├── pkr.fish
    ├── pkgremove.fish
    ├── pkf.fish
    ├── pkginfo.fish
    ├── pkl.fish
    └── pkgls.fish
```

Edit files in `pkgscripts/` and re-run `install-pk.fish` to update.

## How It Works

- **No trial-and-error.** Uses `pacman -Qq` to query the local database instantly. Since `yay` registers AUR packages in the same local DB, one check covers both sources.
- **Source detection.** Compares `pacman -Qi` (local) against `pacman -Si` (sync DB). If a package exists locally but not in sync repos, it's tagged as AUR.
- **Safe removal.** Uses `grep -i "^$term"` to match package name prefixes, preventing accidental removal of similarly-named dependencies. Always prompts before deleting.
- **Fish-native.** Functions are autoloaded from `~/.config/fish/functions/` with zero startup cost. Tab completion works out of the box.

## Requirements

- [Fish shell](https://fishshell.com/) 3.x+
- Arch Linux (or Arch-based distro)
- `pacman` (pre-installed)
- `yay` _(optional — required only for AUR support)_

## Uninstall

```fish
rm ~/.config/fish/functions/{pki,pkginst,pkr,pkgremove,pkf,pkginfo,pkl,pkgls}.fish
```

## License

MIT
