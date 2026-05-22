# shellcheck shell=bash
# Custom time segment: HH:MM prefixed with a Nerd Font clock glyph (U+F017).

run_segment() {
	local icon
	icon=$(printf '\xef\x80\x97')
	printf "%s %s" "$icon" "$(date +%H:%M)"
	return 0
}
