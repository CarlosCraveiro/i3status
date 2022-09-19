#!/bin/sh

# i3 config in ~/.config/i3/config :
# bar {
#   status_command exec /home/you/.config/i3status/mybar.sh
# }

bg_bar_color="#1E1C31"

# Print a left caret separator
# @params {string} $1 text color, ex: "#FF0000"
# @params {string} $2 background color, ex: "#FF0000"
separator() {
	echo -n "{"
	echo -n "\"full_text\":\"\uE0B2\","
	echo -n "\"separator\":false,"
	echo -n "\"separator_block_width\":0,"
	echo -n "\"border\":\"$bg_bar_color\","
	echo -n "\"border_left\":0,"
	echo -n "\"border_right\":0,"
	echo -n "\"border_top\":2,"
	echo -n "\"border_bottom\":2,"
	echo -n "\"color\":\"$1\","
	echo -n "\"background\":\"$2\""
	echo -n "}"
}

common() {
	echo -n "\"border\": \"$bg_bar_color\","
	echo -n "\"separator\":false,"
	echo -n "\"separator_block_width\":0,"
	echo -n "\"border_top\":2,"
	echo -n "\"border_bottom\":2,"
	echo -n "\"border_left\":0,"
	echo -n "\"border_right\":0"
}

mycrypto() {
	local bg="#ecf0f1"
	separator $bg $bg_bar_color
	echo -n ",{"
	echo -n "\"name\":\"id_crypto\","
	echo -n "\"full_text\":\" $(~/.config/i3status/crypto.py) \","
        echo -n "\"color\":\"#1E1C31\","
	echo -n "\"background\":\"$bg\","
	common
	echo -n "},"
}

myip_public() {
	local bg="#ff5458"
	separator $bg "#ffb378"
	echo -n ",{"
	echo -n "\"name\":\"ip_public\","
	echo -n "\"full_text\":\" $(~/.config/i3status/ip.py) \","	
        echo -n "\"color\":\"#1E1C31\","
	echo -n "\"background\":\"$bg\","
  common
	echo -n "},"
}

myJTAG_on() {
	local bg="#E53935" # rouge
	local icon=""
  local jtag_error=$(~/intelFPGA_lite/20.1/quartus/bin/jtagconfig -n | grep -G ".JTAG")
  local output=$(~/intelFPGA_lite/20.1/quartus/bin/jtagconfig | grep -G "No hardware available")
  if [[ "$jtag_error" != "" ]] || [[ "$output" != "" ]]; then
		bg="#424242" # grey darken-3 
		icon=""
	fi
	separator $bg "#1976D2" # background left previous block
	bg_separator_previous=$bg
	echo -n ",{"
	echo -n "\"name\":\"id_jtag\","      
	echo -n "\"full_text\":\" ${icon} JTAG  \","
	echo -n "\"background\":\"$bg\","
        echo -n "\"color\":\"#1E1C31\","
	common
	echo -n "},"
}

myip_local() {
	local bg="#95ffa4" # vert
	separator $bg "#ff8080"
	echo -n ",{"
	echo -n "\"name\":\"ip_local\","
	echo -n "\"full_text\":\"   $(ip route get 1 | sed -n 's/.*src \([0-9.]\+\).*/\1/p') \","
	echo -n "\"background\":\"$bg\","
        echo -n "\"color\":\"#1E1C31\","
	common
	echo -n "},"
}

disk_usage() {
	local bg="#ffeaa7"
	separator $bg "#ecf0f1"
	echo -n ",{"
	echo -n "\"name\":\"id_disk_usage\","
	echo -n "\"full_text\":\"   $(~/.config/i3status/disk.py)%\","
	echo -n "\"background\":\"$bg\","
        echo -n "\"color\":\"#1E1C31\","
	common
	echo -n "}"
}

memory() {
	echo -n ",{"
	echo -n "\"name\":\"id_memory\","
	echo -n "\"full_text\":\"   $(~/.config/i3status/memory.py)%\","
	echo -n "\"background\":\"#ffeaa7\","
        echo -n "\"color\":\"#1E1C31\","
	common
	echo -n "}"
}

cpu_usage() {
	echo -n ",{"
	echo -n "\"name\":\"id_cpu_usage\","
	echo -n "\"full_text\":\"   $(~/.config/i3status/cpu.py)% \","
	echo -n "\"background\":\"#ffeaa7\","
        echo -n "\"color\":\"#1E1C31\","
	common
	echo -n "},"
}

meteo() {
	local bg="#546E7A"
	separator $bg "#3949AB"
	echo -n ",{"
	echo -n "\"name\":\"id_meteo\","
	echo -n "\"full_text\":\" $(~/.config/i3status/meteo.sh) \","
	echo -n "\"background\":\"$bg\","
	common
	echo -n "},"
}

mydate() {
	local bg="#74b9ff"
	separator $bg "#ffeaa7"
	echo -n ",{"
	echo -n "\"name\":\"id_time\","
	echo -n "\"full_text\":\"   $(LC_TIME=en_US date "+%a %d/%m %H:%M") \","
        echo -n "\"color\":\"#1E1C31\","
	echo -n "\"background\":\"$bg\","
	common
	echo -n "},"
}

battery0() {
	if [ -f /sys/class/power_supply/BAT0/uevent ]; then
		local bg="#fd79a8"
		separator $bg "#74b9ff"
		bg_separator_previous=$bg
		prct=$(cat /sys/class/power_supply/BAT0/uevent | grep "POWER_SUPPLY_CAPACITY=" | cut -d'=' -f2)
		charging=$(cat /sys/class/power_supply/BAT0/uevent | grep "POWER_SUPPLY_STATUS" | cut -d'=' -f2) # POWER_SUPPLY_STATUS=Discharging|Charging
		icon=""
		if [ "$charging" = "Charging" ]; then
			icon=""
		elif [ "$prct" -lt 10 ]; then
			icon=""
		elif [ "$prct" -lt 30 ]; then
			icon=""
		elif [ "$prct" -lt 50 ]; then
			icon=""
		elif [ "$prct" -lt 80 ]; then
			icon=""
		fi
		echo -n ",{"
		echo -n "\"name\":\"battery0\","
		echo -n "\"full_text\":\" ${icon}  ${prct}% \","
                echo -n "\"color\":\"#1E1C31\","
		echo -n "\"background\":\"$bg\","
		common
		echo -n "},"
	else
		bg_separator_previous="#E0E0E0"
	fi
}

volume() {
	local bg="#dfe6e9"
	separator $bg "#fd79a8"
	vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '..%' | head -1)
	mute=$(0)
	echo -n ",{"
	echo -n "\"name\":\"id_volume\","
	if [ "$mute" = true ]; then
		echo -n "\"full_text\":\"  Muted \","
	elif [ $vol -le 0 ]; then
		echo -n "\"full_text\":\"  ${vol} \","
	else
		echo -n "\"full_text\":\"   ${vol} \","
	fi
	echo -n "\"background\":\"$bg\","
        echo -n "\"color\":\"#1E1C31\","
	common
	echo -n "},"
	separator $bg_bar_color $bg
}

systemupdate() {
	local nb=$(checkupdates | wc -l)
	if (( $nb > 0)); then
		echo -n ",{"
		echo -n "\"name\":\"id_systemupdate\","
		echo -n "\"full_text\":\"  ${nb}\""
		echo -n "},"
	fi
}

logout() {
	echo -n ",{"
	echo -n "\"name\":\"id_logout\","
	echo -n "\"full_text\":\"  \""
	echo -n "}"
}

# https://github.com/i3/i3/blob/next/contrib/trivial-bar-script.sh
echo '{ "version": 1, "click_events":true }'    # Send the header so that i3bar knows we want to use JSON:
echo '['                    			# Begin the endless array.
echo '[]'                   			# We send an empty first array of blocks to make the loop simpler:

# Now send blocks with information forever:
(while :;
do
	echo -n ",["
	#mycrypto
	myip_public
	myip_local
  myJTAG_on
	disk_usage
	memory
	cpu_usage
  meteo
	mydate
	battery0
	volume
	#systemupdate
	logout
	echo "]"
	sleep 10
done) &

# click events
while read line;
do
	# echo $line > /home/you/gitclones/github/i3/tmp.txt
	# {"name":"id_vpn","button":1,"modifiers":["Mod2"],"x":2982,"y":9,"relative_x":67,"relative_y":9,"width":95,"height":22}

	# VPN click
	if [[ $line == *"name"*"id_vpn"* ]]; then
		alacritty -e ~/.config/i3status/click_vpn.sh &

	# CHECK UPDATES
	elif [[ $line == *"name"*"id_systemupdate"* ]]; then
		alacritty -e ~/.config/i3status/click_checkupdates.sh &

	# CPU
	elif [[ $line == *"name"*"id_cpu_usage"* ]]; then
		alacritty -e btop &

	# TIME
	elif [[ $line == *"name"*"id_time"* ]]; then
		alacritty -e ~/.config/i3status/click_time.sh &

	# METEO
	elif [[ $line == *"name"*"id_meteo"* ]]; then
		alacritty -e ~/.config/i3status/wheather_forecast.sh &

	# CRYPTO
	elif [[ $line == *"name"*"id_crypto"* ]]; then
		xdg-open https://www.livecoinwatch.com/ > /dev/null &

	# VOLUME
	elif [[ $line == *"name"*"id_volume"* ]]; then
		alacritty -e alsamixer &

	# LOGOUT
	elif [[ $line == *"name"*"id_logout"* ]]; then
		i3-nagbar -t warning -m 'Log out ?' -b 'yes' 'i3-msg exit' > /dev/null &

	fi  
done
