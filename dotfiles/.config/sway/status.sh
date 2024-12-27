#!/usr/bin/env bash


declare -g WLAST_RUN=999999999
declare -g WEATHER=""

function update_weather() {
    # Get current timestamp and calculate DELTA
    local CURRENT_TIME=$(date +%s)
    local DELTA=$(( CURRENT_TIME - WLAST_RUN ))
		
		if (( DELTA >= 1800 )); then
				WLAST_RUN=$CURRENT_TIME
				export WLAST_RUN
		else
        return 1
		fi

    # Fetch IP information
    IPINFO=$(curl -s http://ip-api.com/json/)
    LAT=$(echo "$IPINFO" | jq .lat)
    LON=$(echo "$IPINFO" | jq .lon)
    if [[ -z "$LAT" || -z "$LON" || "$LAT" == "null" || "$LON" == "null" ]]; then
        return 1
    fi

    # Fetch weather forecast
    FLINK=$(curl -s "https://api.weather.gov/points/$LAT,$LON" | jq -r .properties.forecast)
    if [[ -z "$FLINK" || "$FLINK" == "null" ]]; then
        return 1
    fi

    FORECAST=$(curl -s "$FLINK")
    TEMP=$(echo "$FORECAST" | jq .properties.periods[0].temperature)
    ISDAY=$(echo "$FORECAST" | jq .properties.periods[0].isDaytime)
    PRECIPITATION=$(echo "$FORECAST" | jq .properties.periods[0].probabilityOfPrecipitation.value)
		PRECIPITATION=$([[ $PRECIPITATION == "null" ]] && echo "0" || echo $PRECIPITATION)

    # Determine weather icons
    if [[ "$ISDAY" == "true" ]]; then
        if (( $(echo "$PRECIPITATION > 0.2" | bc -l) )); then
            ICON="" # Daytime rainy
        else
            ICON="" # Daytime clear
        fi
    else
        if (( $(echo "$PRECIPITATION > 0.2" | bc -l) )); then
            ICON="" # Nighttime rainy
        else
            ICON="" # Nighttime clear
        fi
    fi

    # Update weather string and timestamp
    WEATHER="$ICON $TEMP󰔅"
    WLAST_RUN=$(date +%s)
}

# Define swaybar width (adjust based on your screen resolution if needed)
FONT_SIZE=10
BAR_WIDTH=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused).rect.width')

# WIDTH in characters
BAR_WIDTH=$(echo "$BAR_WIDTH / ($FONT_SIZE - 1)" | bc)

# Start i3status
i3status -c ~/.config/sway/i3status.conf | while :
do
    # Read i3status output line
    read -r line
		update_weather
		line="$WEATHER$line"

    # Get the current window title using swaymsg
    window_title=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true).name')

    # Fallback if no window title is found
    window_title=${window_title:-""}

    # Combine centered window title and right-aligned i3status output
    
		padding_chars=$(( (BAR_WIDTH - (${#window_title} + ${#line})) / 2 ))
		# Ensure padding is non-negative
		if [ "$padding_chars" -lt 0 ]; then
			  padding_chars=0
		fi

		padding=$(printf '%*s' "$padding_chars" '' | tr ' ' ' ')
		output="$window_title $padding $line"
    echo "$output" || exit 1
done


