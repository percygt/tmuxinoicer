#!/usr/bin/env bash
# Most of this script is from
#   https://github.com/omerxx/tmux-sessionx/blob/a87122c8f4bd2eb19c3ae556e2aad2973e2ca37c/scripts/sessionx.sh
# Display preview of tmux windows/panes.
# Meant for use in fzf preview.
# Kudos:
#   https://stackoverflow.com/a/55247572/197789
#   https://github.com/petobens/dotfiles/blob/master/tmux/tmux_tree

MODE="$1"
SESSION="$2"

# Display list of files in directory
display_directory() {
	session_name="${1}"
	if command -v eza &>/dev/null; then
		eza --sort type --icons -F -H --group-directories-first -1 "$session_name"
	else
		ls -l "$session_name"
	fi
}

# Display a single session
session_mode() {
	session_name="${1}"
	session_id=$(tmux ls -F '#{session_id}' -f "#{==:#{session_name},${session_name}}")
	if test "$session_id" = ""; then
		echo "Unknown session: ${session_name}"
		return 1
	fi
	tmux capture-pane -ep -t "$session_id"
}

window_mode() {
	tmux capture-pane -ep -t "${1}"
}

# Display a full tree, with selected session highlighted.
# If an session name is passed as an argument, highlight it
# in the output.
# This is the original tmux_tree script (see kudos).
tree_mode() {
	highlight="${1}"
	tmux ls -F'#{session_id}' | while read -r s; do
		S=$(tmux ls -F'#{session_id}#{session_name}: #{T:tree_mode_format}' | grep ^"$s")
		session_info=${S##"$s"}
		session_name=$(echo "$session_info" | cut -d ':' -f 1)
		if [[ -n "$highlight" ]] && [[ "$highlight" == "$session_name" ]]; then
			echo -e "\033[1;34m$session_info\033[0m"
		else
			echo -e "\033[1m$session_info\033[0m"
		fi
		# Display each window
		tmux lsw -t"$s" -F'#{window_id}' | while read -r w; do
			W=$(tmux lsw -t"$s" -F'#{window_id}#{T:tree_mode_format}' | grep ^"$w")
			echo "  ﬌ ${W##"$w"}"
		done
	done
}

main() {
	case "$MODE" in
	session) session_mode "$SESSION" ;;
	tree) tree_mode "$SESSION" ;;
	window) window_mode "$SESSION" ;;
	*) echo "Unknown mode \"$MODE\"" ;;
	esac
}

if test "$SESSION" == '*Last*'; then
	SESSION=$(tmux display-message -p "#{client_last_session}")
	if test "$SESSION" = ""; then
		echo "No last session."
		exit 0
	fi
fi

if [[ -d "$SESSION" ]]; then
	display_directory "$SESSION"
else
	main
fi
