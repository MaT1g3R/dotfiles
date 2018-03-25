# Better ls
export DISABLE_LS_COLORS="true"
export LS_COLORS=$(ls_colors_generator)
ls() {
	ls-i --color=auto -w $(tput cols) "$@"
}

dir() {
	dir-i --color=auto -w $(tput cols) "$@"
}

vdir() {
	vdir-i --color=auto -w $(tput cols) "$@"
}
