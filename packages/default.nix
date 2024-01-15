{
  lib,
  tmuxPlugins,
}:
tmuxPlugins.mkTmuxPlugin {
  pluginName = "tmuxinoicer";
  version = "unstable-2024-01-10";
  src = ../.;
  meta = with lib; {
    license = licenses.mit;
    platforms = platforms.unix;
  };
  postInstall = ''
    sed -i -e 's|''${TMUX_PLUGIN_MANAGER_PATH%/}|${placeholder "out"}/share/tmux-plugins|g' $target/libexec/switcher.bash
  '';
}
