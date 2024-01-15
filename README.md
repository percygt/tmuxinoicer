# tmuxinoicer

A tmux session manager that brings together a collection of `noice` features to
elevate your tmux experience.

![image](./tmuxinoicer.png)

## ✨ Features

- Integrations with fzf for fuzzy search
- Supports directory, session and tree-mode preview
- Supports directory-based session creation with find and zoxide integration

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
      overlays = [ tmuxinoicer.overlays.default ];
    };
  in
    # You can now reference pkgs.tmuxPlugins.tmuxinoicer.
  { }
}
```

After that, `tmuxinoicer` can now be used as a normal tmux plugin within
`nixpkgs`.

## ⚙️ Customization

| Variable                           | Default value                             | Description                                                                                     |
| :--------------------------------- | :---------------------------------------- | :---------------------------------------------------------------------------------------------- |
| `@tmuxinoicer-bind`                | `"o"`                                     | `<prefix>` then this key to trigger the plugin                                                  |
| `@tmuxinoicer-window-mode`         | `"ctrl-w"`                                | keybind to display a list of windows for every session                                          |
| `@tmuxinoicer-tree-mode`           | `"ctrl-t"`                                | keybind to display the tree-mode preview                                                        |
| `@tmuxinoicer-new-window`          | `"ctrl-e"`                                | keybind to display a list of directories in the current session                                 |
| `@tmuxinoicer-kill-session`        | `"alt-bspace"`                            | keybind to delete a session                                                                     |
| `@tmuxinoicer-rename`              | `"ctrl-r"`                                | keybind to rename either a session or the basename of a directory                               |
| `@tmuxinoicer-back`                | `"ctrl-b"`                                | keybind to move back                                                                            |
| `@tmuxinoicer-default-window-mode` | `"off"`                                   | sets window-mode as the default result display for sessions                                     |
| `@tmuxinoicer-window-height`       | `"75%"`                                   | fzf-tmux display height                                                                         |
| `@tmuxinoicer-window-width`        | `"90%"`                                   | fzf-tmux display width                                                                          |
| `@tmuxinoicer-preview-location`    | `"right"`                                 | fzf-tmux preview location                                                                       |
| `@tmuxinoicer-preview-ratio`       | `"60%"`                                   | fzf-tmux preview ratio                                                                          |
| `@tmuxinoicer-color`               | `"pointer:9,spinner:92,marker:46,fg+:11"` | fzf-tmux color options                                                                          |
| `@tmuxinoicer-extras`              | `"find,zoxide"`                           | adds both find and zoxide to the result list                                                    |
| `@tmuxinoicer-find-base`           | `""`                                      | comma-separated list of directories and their depths for searching directories based on rooters |
| `@tmuxinoicer-find-rooters`        | `".git"`                                  | comma-separated list of rooters                                                                 |
| `@tmuxinoicer-zoxide-excludes`     | `"/nix"`                                  | comma-separated list of paths you don't want in the zoxide result                               |

### Guide

Modify the list of default values above by setting the desired values in
`.tmux.conf`.

```tmux
set -g <variable> <value>
```

#### `@tmuxinoicer-extras`

`find` and `zoxide` are both enabled by default. If you want to display only
`find` result.

```tmux
set -g @tmuxinoicer-extras "find"
```

#### `@tmuxinoicer-find-rooter`

The result of `find` is based on the value of `@tmuxinoicer-find-rooter`. If the
value is `.git`, it will search for directories that has `.git` directory in it.
If you want the result to display all directories set this:

```tmux
set -g @tmuxinoicer-find-rooters ""
```

#### `@tmuxinoicer-find-base`

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

For example, if you want to search for [ghq](https://github.com/x-motemen/ghq)
repositories as an input:

```tmux
set -ag @tmuxinoicer-find-base ,"$(ghq root):3"
```

For example, if you want to add `~/.config/nvim` itself as an input:

```tmux
set -ag @tmuxinoicer-find-base ,"${HOME}/.config/nvim"
```

## 🤗 Acknowledgements

I would like to express my sincere gratitude to the following projects and their
contributors, as I have incorporated code snippets and inspiration from them
into this project:

- [tmux-project](https://github.com/sei40kr/tmux-project) | Search projects and
  open them in a new session.
- [tmux-sessionx](https://github.com/omerxx/tmux-sessionx) | A fuzzy Tmux
  session manager with preview capabilities, deleting, renaming and more!
- [t-smart-tmux-session-manager](https://github.com/joshmedeski/t-smart-tmux-session-manager)
  | The smart tmux session manager
- [tmux-sessionizer](https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer)
  | ThePrimeagen's bash script for tmux sessions

## License

MIT
