#!/bin/bash

# current working directory
DIR="$(pwd)"
# repositories to ignore when 'git pull'ing
ignore_list=('')
# list of all repo names in DIR
repo_names=('')

function help() {
	echo -e "\e[1mUSAGE:\e[0m ./manage.sh [command] [option/command]"
	echo -e "\e[1mAVAILABLE OPTIONS:\e[0m"
	echo -e "\e[1mupdate\e[0m - git pull all the repos in the current folder.\n    ignore repos by adding the '--ignore' flag followed by a list of the folder names of the repos to ignore."
	echo -e "\e[1mpush-all\e[0m - git push all the repos in the current folder.\n    ignore repos by adding the '--ignore' flag followed by a list of the folder names of the repos to ignore."
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
		update*)
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
		push-all)
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
		*)
			echo -e "\e[1;31mERROR: \e[0;31m invalid operation!\e[0m"
		;;
	esac
else
	echo -e "\e[1;31mERROR: \e[0;31mno operations supplied!\e[0m"
fi
