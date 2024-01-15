{
  description = "Tmuxinoicer: Adding noice things to tmux.";

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
      in {
        packages.default = tmuxinoicer;
        overlay = self.overlays.default;
        overlays.default = self: super: {
          tmuxPlugins =
            super.tmuxPlugins
            // {
              inherit tmuxinoicer;
            };
        };

        devShells.default = let
          tmux_conf = pkgs.writeText "tmux.conf" ''
            set -g prefix ^A
            run-shell ${tmuxinoicer.rtp}
            set-option -g default-terminal 'screen-254color'
            set-option -g terminal-overrides ',xterm-256color:RGB'
            set -g default-terminal "''${TERM}"
            display-message ${tmuxinoicer.rtp}
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
