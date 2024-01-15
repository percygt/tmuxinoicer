# tmuxinoicer

A combination of `noice` things to have in a tmux session manager.

## ✨ Features

- Integrations with fzf for fuzzy search
- Supports directory, session and tree-mode preview
- Integrations with find and zoxide for fast session creation base on directory

## 🛠️ Requirements

- find
- [tmux](https://github.com/tmux/tmux) (>= 3.2)
- [tpm](https://github.com/tmux-plugins/tpm)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [fzf](https://github.com/junegunn/fzf) (>=0.35.0)
- Optional: [eza](https://github.com/eza-community/eza)

## 💻 Install

### Installation with [tpm](https://github.com/tmux-plugins/tpm)

Add the following line to your `.tmux.conf`.

```tmux
set -g @plugin 'percygt/tmuxinoicer'
```

### Installation via [nix](https://github.com/NixOS/nix) `overlay`

Add tmuxinoicer as a flake input:

```nix
{
  inputs = {
    tmuxinoicer.url = "github:percygt/tmuxinoicer";
  };
  outputs = { tmuxinoicer, ... }: { };
}
```

Then, use the flake's `overlay` attribute:

```nix
{
  outputs = { tmuxinoicer, nixpkgs, ... }:
  let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [ tmuxinoicer.overlay ];
    };
  in
  { }
}
```

You can now then reference `pkgs.tmuxPlugins.tmuxinoicer` inside
`programs.tmux.plugins`.

## ⚙️ Customization

| Variable                           | Default value         | Description                                                                                  |
| :--------------------------------- | :-------------------- | :------------------------------------------------------------------------------------------- |
| `@tmuxinoicer-bind`                | `"o"`                 | The key that triggers the plugin.                                                            |
| `@tmuxinoicer-window-mode`         | `"ctrl-w"`            | Lists windows for every session.                                                             |
| `@tmuxinoicer-tree-mode`           | `"ctrl-t"`            | Opens the tree preview.                                                                      |
| `@tmuxinoicer-new-window`          | `"ctrl-e"`            | Lists directories in the current session                                                     |
| `@tmuxinoicer-kill-session`        | `"alt-bspace"`        | Kills the session.                                                                           |
| `@tmuxinoicer-rename`              | `"ctrl-r"`            | Renames either the session or the basename of a directory.                                   |
| `@tmuxinoicer-back`                | `"ctrl-b"`            | Move back.                                                                                   |
| `@tmuxinoicer-window-height`       | `"75%"`               | Fzf-tmux display height.                                                                     |
| `@tmuxinoicer-window-width`        | `"90%"`               | Fzf-tmux display width.                                                                      |
| `@tmuxinoicer-default-window-mode` | `"off"`               | Sets window-mode as the default list for input.                                              |
| `@tmuxinoicer-preview-location`    | `"right"`             | Fzf-tmux preview location.                                                                   |
| `@tmuxinoicer-preview-ratio`       | `"50%"`               | Fzf-tmux preview ratio.                                                                      |
| `@tmuxinoicer-extras`              | `"find,zoxide"`       | Adds both find and zoxide results to the list for input display.                             |
| `@tmuxinoicer-find-base`           | `"$HOME/.config:1:2"` | A comma-separated list of directories and their depths to find directories based on rooters. |
| `@tmuxinoicer-find-rooters`        | `".git"`              | A comma-separated list of rooters.                                                           |
| `@tmuxinoicer-zoxide-excludes`     | `".git,/nix"`         | A comma-separated list of paths you don't want in the zoxide result.                         |

### Setting `@tmuxinoicer-find-base`

`@tmuxinoicer-find-base` is a comma-separated list of directories and their
depths to search for directories based on rooters.

Each element of the list is in the following format:

```bash
/path/to/dir[:<min depth>[:<max depth>]]
```

- If you omit `<min depth>` and `<max depth>`, they are set to `0` and `0`
  respectively.
- If you omit `<max depth>`, it is set to `<min depth>`. (means `<min depth>` is
  the exact depth)

If you omit the depth or explicitly set it to `0`, the directory itself will be
added as a project. In that case, you can add the directory as an input even if
it contains no rooter.

---

For example, if you want to search for [ghq](https://github.com/x-motemen/ghq)
repositories as an input:

```tmux
set -ag @tmuxinoicer-find-base ,"$(ghq root):3"
```

For example, if you want to add `~/.config/nvim` itself as an input:

```tmux
set -ag @tmuxinoicer-find-base ,"${HOME}/.config/nvim"
```

## Thanks ❤️

Kudos to those behind these projects. I wanted a session manager that fits my
workflow, so I extracted key features and `noice` things from these sources:

- https://github.com/sei40kr/tmux-project
- https://github.com/omerxx/tmux-sessionx
- https://github.com/joshmedeski/t-smart-tmux-session-manager
- https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer

## License

MIT
