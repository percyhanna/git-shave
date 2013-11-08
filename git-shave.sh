#/bin/bash

function show_stash {
	clear
	git stash show -v $1
}

function yes_no_prompt {
	while : ; do
		read -e -p "$1 [y/n] " -n1 DELETE_STASH

		case "$DELETE_STASH" in
			y|Y)
				return 0
				;;

			n|N)
				return 1
				;;
		esac
	done
}

function drop_stash {
	git stash drop $1
}

function select_stashes {
	stashes=`git stash list | grep -Eo 'stash@\{\d+\}' | sort -rn`

	stashes_to_delete=()

	for stash in $stashes; do
		show_stash $stash
		if yes_no_prompt "Do you want to shave (delete) this stash?"; then
			stashes_to_delete+=($stash)
		fi
	done

	if [ ${#stashes_to_delete[@]} -lt 1 ]; then
		echo Nothing to do.
		exit
	fi

	echo You are about to delete the following stashes:
	for stash in ${stashes_to_delete[@]}; do
		echo "  - $stash"
	done

	if yes_no_prompt "Are you sure?"; then
		for stash in ${stashes_to_delete[@]}; do
			drop_stash $stash
		done
	fi
}

select_stashes