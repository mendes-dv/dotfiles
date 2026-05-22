#!/usr/bin/env bash
# tmux-powerline user overrides

# Make tmux-powerline pick up custom segments from ~/.config/tmux-powerline/segments/
export TMUX_POWERLINE_DIR_USER_SEGMENTS="${XDG_CONFIG_HOME:-$HOME/.config}/tmux-powerline/segments"

# Detect macOS appearance and pick a segment palette.
# Format: "<segment> <bg> <fg>" using 256-color palette indices.
# Re-evaluated on every status refresh, so it follows Light/Dark toggles live.
if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
	# Dark mode
	export TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
		"pwd 148 234"
	)
	export TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
		"cpu 24 255"
		"battery 29 255"
		"time 237 250"
	)
else
	# Light mode — saturated pills on a white statusline
	export TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
		"pwd 22 255"
	)
	export TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
		"cpu 18 255"
		"battery 22 255"
		"time 235 252"
	)
fi

# Keep the path short — basename-ish (will show just the leaf dir or a `…/leaf`).
export TMUX_POWERLINE_SEG_PWD_MAX_LEN=15
