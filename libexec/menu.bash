#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
. "$BASE_DIR/lib/tmux.bash"
get_find_list() {
	local -a base_dirs rooters rooter_opts

	IFS=',' read -ra base_dirs < <(get_tmux_option '@tmuxinoicer-base-dirs' "/data:1:4")
	IFS=',' read -ra rooters < <(get_tmux_option '@tmuxinoicer-rooters' '.git')

	for rooter in "${rooters[@]}"; do
		rooter_opts+=("-o" "-name" "$rooter")
	done
	rooter_opts=('(' "${rooter_opts[@]:1}" ')')

	for base_dir in "${base_dirs[@]}"; do
		# If the base_dir is empty, skip it
		if [[ -z "$base_dir" ]]; then
			continue
		fi

		local -a tmp
		IFS=':' read -ra tmp <<<"$base_dir"
		path="${tmp[0]}"
		min_depth="${tmp[1]:-0}"
		max_depth="${tmp[2]:-${min_depth}}"

		if [[ min_depth -eq 0 && max_depth -eq 0 ]]; then
			# If min_depth and max_depth are both 0, that means we
			# want to add the base_dir itself as a project.
			# In that case, add the base_dir as a project even if it
			# contains no rooter.
			if [[ -d "$path" || -L "$path" ]]; then
				echo "$path"
			fi
		else
			find "$path" -mindepth "$((min_depth + 1))" \
				-maxdepth "$((max_depth + 1))" \
				"${rooter_opts[@]}" \
				-printf '%h\n'
		fi
	done
}
get_sessions_list() {
	default_window_mode=$(get_tmux_option "@tmuxinoicer-window-mode" "off")
	if [[ "$default_window_mode" == "on" ]]; then
		tmux list-windows -aF '#{session_last_attached} #S:#W' | sort --numeric-sort --reverse | awk '{print $2}' | grep -v "$(tmux list-windows -F '#S:#W')" || tmux list-windows -F '#S:#W'
	else
		tmux list-sessions -F '#{session_last_attached} #S' | sort --numeric-sort --reverse | awk '{print $2}' | grep -v "$(tmux display-message -p '#S')" || tmux display-message -p '#S'
	fi
}
get_zoxide_list() {
	zoxide query -l | sed -e "$HOME_REPLACER"
}
default_list() {
	local unique_list zoxide_list find_list add_list add_option session_list
	IFS=',' read -ra add_option < <(get_tmux_option "@tmuxinoicer-add-option" "find")
	find_list=$(get_find_list)
	zoxide_list=$(get_zoxide_list)
	if [ ${#add_option[@]} -gt 0 ]; then
		for list_type in "${add_option[@]}"; do
			if [[ $list_type == "find" ]] && [[ -n "$find_list" ]]; then
				add_list="$find_list"
			fi
			if [[ $list_type == "zoxide" ]] && [[ -n "$zoxide_list" ]]; then
				add_list="$add_list $zoxide_list"
			fi
		done

		unique_list=$(echo "$add_list" | tr ' ' '\n' | awk '!seen[$0]++' | tr '\n' ',')
		session_list=$(tmux list-sessions -F '#S' | tr '\n' ',')
		IFS=',' read -ra add_list_dir <<<"$unique_list"
		IFS=',' read -ra session_names <<<"$session_list"
		result=()
		if [ ${#add_list_dir[@]} -gt 0 ]; then
			for path in "${add_list_dir[@]}"; do
				# Extract the basename from the full path
				# basename=$(to_session_name "$path")
				basename=$(to_session_name "$path")
				# Remove leading "." if present in the basename
				found=false
				for session in "${session_names[@]}"; do
					if [ "$basename" == "$session" ]; then
						found=true
						break
					fi
				done
				if [ "$found" == false ]; then
					result+=("$path")
				fi
			done
		fi
		get_sessions_list && printf '\e[1;34m%-6s\e[m\n' "${result[@]}"
	else
		get_sessions_list
	fi
}
