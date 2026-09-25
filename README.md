# dotfiles

Linux-only, managed with [chezmoi](https://www.chezmoi.io). No templates, every file is a plain copy.
On other machines (Windows, WSL, …) copy what you need by hand: `chezmoi cat ~/.config/<file>` or read it straight from this repo.

## What's managed

| Target                           | Source                                  |
| -------------------------------- | --------------------------------------- |
| `~/.config/alacritty/alacritty.toml` | `dot_config/alacritty/alacritty.toml` |
| `~/.config/fish/`                | `dot_config/fish/`                      |
| `~/.config/nvim/init.lua`        | `dot_config/nvim/init.lua`              |
| `~/.config/tmux/tmux.conf`       | `dot_config/tmux/tmux.conf`             |

`chezmoi managed` lists everything.

## Daily loop

```fish
chezmoi edit ~/.config/fish/config.fish   # edit the source copy in $EDITOR (nvim); auto-applies (edit.apply = true)
chezmoi re-add                            # edited the live file directly? pull changes back into the repo
chezmoi diff                              # what would apply change?
chezmoi apply -v                          # write source -> home
chezmoi cd                                # shell in the repo: git add / commit / push, then `exit`
```

## Adding / removing files

```fish
chezmoi add ~/.config/foo/config    # start tracking
chezmoi forget ~/.config/foo/config # stop tracking (leaves the file in ~)
```

To keep a file in the repo but never write it to `~`, add it to `.chezmoiignore`.

## Source filename prefixes

| Prefix / suffix | Meaning                     |
| --------------- | --------------------------- |
| `dot_`          | leading `.` (`dot_config` → `.config`) |
| `private_`      | mode 0600                   |
| `executable_`   | +x                          |
| `.tmpl`         | Go template (none used now) |

## New machine

```fish
chezmoi init --apply <git-remote-url>   # clone + apply
chezmoi update                          # later: git pull + apply
```

## Troubleshooting

```fish
chezmoi status          # what differs between source and home
chezmoi merge <target>  # both sides changed: 3-way merge
chezmoi doctor          # check the chezmoi install/config
```

## Quirks

- `nvim-pack-lock.json` is tracked but ignored, so it's never applied (nvim rewrites it).
- `fish_variables` is `private_` and fish rewrites it. Run `chezmoi re-add` after changing prompt colors etc.
