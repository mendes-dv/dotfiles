# shellcheck shell=bash
# Custom CPU segment: single percentage prefixed with a Nerd Font microchip glyph (U+F2DB).

run_segment() {
	local cpus_line cpu_user cpu_system total icon
	icon=$(printf '\xef\x8b\x9b')
	if [[ "$(uname)" == "Darwin" ]]; then
		cpus_line=$(top -l 1 -n 0 | grep "CPU usage:" | sed 's/CPU usage: //')
		cpu_user=$(echo "$cpus_line" | awk '{print $1}' | tr -d '%')
		cpu_system=$(echo "$cpus_line" | awk '{print $3}' | tr -d '%')
	else
		cpus_line=$(top -bn1 | grep "Cpu(s)")
		cpu_user=$(echo "$cpus_line" | grep -o "[0-9.]\+ *us" | awk '{print $1}')
		cpu_system=$(echo "$cpus_line" | grep -o "[0-9.]\+ *sy" | awk '{print $1}')
	fi
	total=$(awk -v u="${cpu_user:-0}" -v s="${cpu_system:-0}" 'BEGIN { printf "%.0f", u + s }')
	printf "%s %s%%" "$icon" "$total"
	return 0
}
