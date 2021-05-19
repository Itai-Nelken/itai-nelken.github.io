#!/bin/bash

DIR="$(pwd)"
# repositoreies to ignore when 'git pull'ing
ignore_list=('')

function help() {
	echo "USAGE: ./manage.sh [command] [option/command]"
	echo "AVAILABLE OPTIONS:"
	echo "update - git pull all the repos in the current folder."
	echo "ignore='repo1 repo2' - ignore repositories when updating. requires a command after it, currently only 'update.'"
	echo "--about - about information."
}

function about() {
	echo "manage.sh - a script to manage multiple cloned git repos"
	echo "Copyright (C) $(date +%Y)  Itai-Nelken"
	echo "run this script with the about flag + the '--license' flag to show the license (GPLv3)"
}

function license() {
	echo -e "\n\e[1mThis program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.\e[0m"
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
		update)
			update-repos
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
		--about|--version|-v)
			about
			if [[ "$2" == "--license" ]]; then
				license
			fi
		;;
		*)
			echo -e "\e[1;31mERROR: \e[0;31m invalid operation!\e[0m"
		;;
	esac
else
	echo -e "\e[1;31mERROR: \e[0;31mno operations supplied!\e[0m"
fi
