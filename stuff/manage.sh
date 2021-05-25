#!/bin/bash

# current working directory
DIR="$(pwd)"
# repositories to ignore when 'git pull'ing
ignore_list=('')
# list of all repo names in DIR
repo_names=('')

function help() {
<<<<<<< HEAD
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
=======
	echo -e "\e[1mUSAGE:\e[0m ./manage.sh [command] [option/command]"
	echo -e "\e[1mAVAILABLE OPTIONS:\e[0m"
	echo -e "\e[1mupdate\e[0m - git pull all the repos in the current folder.\n    ignore repos by adding the '--ignore' flag followed by a list of the folder names of the repos to ignore."
	echo -e "\e[1mpush\e[0m - git push all the repos in the current folder.\n    ignore repos by adding the '--ignore' flag followed by a list of the folder names of the repos to ignore."
>>>>>>> 01a9b0844c279feba81b6cd694ac48b797f6de48
}


# get all repo names in DIR and store them in the repo_names array
function get-repo-names() {
	for repo in $DIR/*; do
		reponame="$(basename "$repo")"
		if [[ "$reponame" != "manage.sh" ]]; then
			if [[ ! "${ignore_list[@]}" =~ "$reponame" ]]; then
				repo_names+=("$reponame")
			fi
		fi
	done
}

if [[ "$1" != "" ]]; then
	case $1 in 
		update)
			if [[ ! -z "$2" ]] && [[ "$2" != "--ignore" ]]; then
				if [[ -d "$2" ]]; then
					echo -e "\e[1m$2\e[0m"
					cd "$2"
					git pull
					pid=$(echo $?)
					cd "$DIR"
					exit $pid
				else
					echo -e "\e[1;31mERROR:\e[0;31m There is no repo called '$2' locally!\e[0m"
					exit 1
				fi
			fi
			if [[ "$2" == "--ignore" ]]; then
				shift 2
				ignore_list+=("$@")
			fi
			get-repo-names
			for repo in ${repo_names[@]}; do
				if [[ ! "${repo_names[@]}" =~ "${ignore_list[@]}" ]] || [[ "${ignore_list[@]}" == '' ]]; then
					echo -e "\e[1m$repo\e[0m"
					cd "$repo"
					git pull
					cd "$DIR"
				fi
			done
		;;
		push)
			if [[ ! -z "$2" ]] && [[ "$2" != "--ignore" ]]; then
				if [[ -d "$2" ]]; then
					echo -e "\e[1m$2\e[0m"
					cd "$2"
					git push
					pid=$(echo $?)
					cd "$DIR"
					exit $pid
				else
					echo -e "\e[1;31mERROR:\e[0;31m There is no repo called '$2' locally!\e[0m"
					exit 1
				fi
			fi
			if [[ "$2" == "--ignore" ]]; then
				shift 2
				ignore_list+=("$@")
			fi
			get-repo-names
			for repo in ${repo_names[@]}; do
				if [[ ! "${repo_names[@]}" =~ "${ignore_list[@]}" ]] || [[ "${ignore_list[@]}" == '' ]]; then
					echo -e "\e[1m$repo\e[0m"
					cd "$repo"
					git push
					cd "$DIR"
				fi
			done
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
			echo -e "\e[1;31mERROR: \e[0;31m invalid operation \"$1\"!\e[0m"
		;;
	esac
else
	echo -e "\e[1;31mERROR: \e[0;31mno operations supplied!\e[0m"
fi
