#!/bin/bash

DIR="$(pwd)"
# repositoreies to ignore when 'git pull'ing
ignore_list=('')

function help() {
	echo "USAGE: ./manage.sh [command] [option/command]"
	echo "AVAILABLE OPTIONS:"
	echo "update - git pull all the repos in the current folder."
	echo "ignore='repo1 repo2' - ignore repositories when updating. requires a command after it, currently only 'update.'"
}

function update-repos() {
	for repo in $DIR/*; do
			reponame="$(basename "$repo")"
			if [[ "$reponame" != "manage.sh" ]]; then
				if [[ ! "${ignore_list[@]}" =~ "$reponame" ]]; then
					cd "$reponame"
					echo -e "\e[1m$reponame:\e[0m"
					git pull
					cd "$DIR"
				fi
			fi
	done
}

if [[ "$1" != "" ]]; then
	case $1 in
		update*)
			update=$(echo $1 | sed -e 's/^[^=]*=//g')
			if [[ "$update" == "update" ]]; then
				update-repos
			else
				if [[ -d "$update" ]]; then
					echo -e "\e[1m$update\e[0m"
					cd "$update"
					git pull
					cd "$DIR"
				else
					echo -e "\e[1;31mERROR:\e[0;31m There is no repo called '$update' locally!\e[0m"
				fi
			fi
		;;
		ignore*)
			ignore=$(echo $1 | sed -e 's/^[^=]*=//g')
			ignore_list+=("$ignore")
			echo -e "\e[1mignore list:\e[0m ${ignore_list[@]}\n--------"
			if [[ "$2" == "update" ]]; then
				update-repos
			else
				echo -e "\e[1;31mERROR: \e[0;31m no ooperation provided for ignore_list change!\e[0m"
			fi
		;;
		help|-h|--help)
			help
		;;
		*)
			echo -e "\e[1;31mERROR: \e[0;31m invalid operation!\e[0m"
		;;
	esac
else
	echo -e "\e[1;31mERROR: \e[0;31mno operations supplied!\e[0m"
fi
