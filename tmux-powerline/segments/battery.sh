# shellcheck shell=bash
# Custom battery segment: percentage prefixed with a Nerd Font battery glyph (U+F240).

run_segment() {
	local pct icon
	icon=$(printf '\xef\x89\x80')
	if [[ "$(uname)" == "Darwin" ]]; then
		pct=$(pmset -g batt | grep -Eo "[0-9]+%" | head -n1)
	else
		if [[ -r /sys/class/power_supply/BAT0/capacity ]]; then
			pct="$(cat /sys/class/power_supply/BAT0/capacity)%"
		else
			return 1
		fi
	fi
	[[ -z "$pct" ]] && return 1
	printf "%s %s" "$icon" "$pct"
	return 0
}
