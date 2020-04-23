#!/usr/bin/env bash

#author: Dane Williams
#scipt for gathering battery percentage and A/C status
#script is called in dracula.tmux program

battery_percent()
{
	# Check OS
	case $(uname -s) in
		Linux)
            echo $(cat /sys/class/power_supply/BAT?/capacity)%
		;;

		Darwin)
			echo $(pmset -g batt | grep -Eo '[0-9]?[0-9]?[0-9]%')
		;;

		CYGWIN*|MINGW32*|MSYS*|MINGW*)
			# leaving empty - TODO - windows compatibility
		;;

		*)
		;;
	esac
}

battery_status()
{
	# Check OS
	case $(uname -s) in
		Linux)
			status=$(cat /sys/class/power_supply/BAT?/status)
		;;

		Darwin)
			status=$(pmset -g batt | sed -n 2p | cut -d ';' -f 2)
		;;

		CYGWIN*|MINGW32*|MSYS*|MINGW*)
			# leaving empty - TODO - windows compatibility
		;;

		*)
		;;
	esac

	if [ $status = 'discharging' ] || [ $status = 'Discharging' ]; then
		echo 'DC ↓ '
	else
	 	echo 'AC ↑ '
	fi
}

main()
{
	bat_stat=$(battery_status)
	bat_perc=$(battery_percent)
	echo "ϟ $bat_stat$bat_perc"
}

#run main driver program
main

