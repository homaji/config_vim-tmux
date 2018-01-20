#!/bin/bash

#load-average
load_avg="$(uptime | awk '{print $(NF-2)}')"


#airport
airport_path="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

if air_info=($(eval "$airport_path" -I | grep -E "^ *(agrCtlRSSI|state|SSID):" | awk '{print $2}')) ; then

  rssi=${air_info[0]}
  state=${air_info[1]}
  ssid=${air_info[2]}

  case "$state" in
    "running" )
      signals=(▁ ▂ ▄ ▆ █)
      signal=""
      rssi_=$(expr 5 - ${rssi} / -20)
      for ((i=0; i < $rssi_; i++ )); do
        signal="${signal}${signals[$i]}"
      done
      airport_=" ${ssid} | ${signal} "
    ;;
    "init"    ) airport_="#[fg=yellow] ... " ;;
    *         ) airport_="#[fg=red] ✘ " ;;
  esac  
  airport="${airport_}"
fi


#sound-volume
if sound_info=$(osascript -e 'get volume settings') ; then
  if [ "$(echo $sound_info | awk '{print $8}')" = "muted:false" ]; then
    sound_volume=$(expr $(echo $sound_info | awk '{print $2}' | sed "s/[^0-9]//g") / 6 )
    str=""
    for ((i=0; i < $sound_volume; i++ )); do
      str="${str} "
    done
    for ((i=$sound_volume; i < 16; i++ )); do
      str="${str} "
    done
    sound="[$str]"
  else
    sound="[      mute      ] "
  fi
fi


#battery
if battery_info=$(/usr/bin/pmset -g ps | awk '{ if (NR == 2) print $2 " " $3 }' | sed -e "s/;//g" -e "s/%//") ; then
  battery_quantity=$(echo $battery_info | awk '{print $2}')
  if [[ ! $battery_info =~ "discharging" ]]; then
    battery="⚡ $battery_quantity% "
  elif (( $battery_quantity < 16 )); then
    battery="$battery_quantity% "
  else
    battery="$battery_quantity% "
  fi
fi

echo "${load_avg}${sound}${airport}${battery}"

