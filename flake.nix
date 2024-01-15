{
  description = "A combination of `noice` things to have in a tmux session manager.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        tmuxinoicer = pkgs.callPackage ./packages/default.nix {};
        overlays = final: prev: {
          tmuxPlugins =
            prev.tmuxPlugins
            // {
              inherit tmuxinoicer;
            };
        };
      in {
        packages.default = tmuxinoicer;

        overlays.default = overlays;

        devShells.default = let
          tmux_conf = pkgs.writeText "tmux.conf" ''
            set -g prefix ^A
            run-shell ${tmuxinoicer.rtp}
            set-option -g default-terminal 'screen-254color'
            set-option -g terminal-overrides ',xterm-256color:RGB'
            set -g default-terminal "''${TERM}"
          '';
        in
          pkgs.mkShell {
            buildInputs = with pkgs; [tmux fzf tmuxinoicer];

            shellHook = ''
              TMUX=
              TMUX_TMPDIR=
              ${pkgs.tmux}/bin/tmux -f ${tmux_conf}
            '';
          };
      }
    );
}
