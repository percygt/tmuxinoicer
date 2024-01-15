#!/usr/bin/env bash

basedir="$(cd "$(dirname "$0")" && pwd)"
. "${basedir}/lib/tmux.bash"

key="$(get_tmux_option '@tmuxinoicer-bind' 'o')"
if [[ -n "$key" ]]; then
	tmux bind-key "$key" run-shell -b "${basedir}/libexec/switcher.bash"
fi
