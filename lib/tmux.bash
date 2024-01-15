get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value

	option_value=$(tmux show -gqv "$option")
	echo "${option_value:-$default_value}"
}

to_session_name() {
	local session_name=$1

	session_name=${session_name##*/}

	# Dots are not allowed in a tmux session name
	# e.g. .emacs.d -> _emacs_d
	session_name=${session_name//./_}
	# If the path starts with a slash (a dot), remove it
	# e.g. .emacs.d -> _emacs_d -> emacs_d
	session_name=${session_name#_}
	# trim spaces
	session_name=${session_name// /}
	echo "$session_name"
}
