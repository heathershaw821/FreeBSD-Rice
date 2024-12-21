#!/usr/local/bin/bash


# Define swaybar width (adjust based on your screen resolution if needed)
FONT_SIZE=10
BAR_WIDTH=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused).rect.width')

# WIDTH in characters
BAR_WIDTH=$(echo "$BAR_WIDTH / ($FONT_SIZE - 0.5)" | bc)

# Start i3status
i3status -c ~/.config/sway/i3status.conf | while :
do
    # Read i3status output line
    read -r line

    # Get the current window title using swaymsg
    window_title=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true).name')

    # Fallback if no window title is found
    window_title=${window_title:-""}

    # Combine centered window title and right-aligned i3status output
    
		padding_chars=$(( (BAR_WIDTH - ${#window_title}) / 2 ))
		# Ensure padding is non-negative
		if [ "$padding_chars" -lt 0 ]; then
			  padding_chars=0
		fi

		padding=$(printf '%*s' "$padding_chars" '' | tr ' ' ' ')
		output="$window_title $padding $line"
    echo "$output" || exit 1
done


