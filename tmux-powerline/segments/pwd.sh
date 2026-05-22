# shellcheck shell=bash
# Custom pwd segment: basename of the active pane's cwd, no truncation prefix.

source "${TMUX_POWERLINE_DIR_LIB}/tmux_adapter.sh"

run_segment() {
	local cwd
	cwd=$(tp_get_tmux_cwd)
	[[ -z "$cwd" ]] && return 1
	echo "${cwd##*/}"
	return 0
}
