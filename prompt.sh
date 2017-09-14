# 
# COLORS
RESET="\[\033[0;37m\]"
RESET_STR=$(tput sgr0)
CLEAR="\[${RESET_STR}\]"

#ExtendedChars
LEFT_CORNER="$(printf "\xe2\x95\xb0")"
LEFT_SIDE="${LEFT_CORNER}"

export COLORA=""
export COLORB=""
export COLORC=""
export COLORD=""

# Count some colors, make sure the val is initialized
if [ -z $COLORINDEX ]; then
	export COLORINDEX=0
fi

# Called at the beginning of `prompt_command` to cycle colors
# `tput setaf <int>` returns a color string for 0-255
# `expr` does math in the shell!
function getColor() {
	if [ $COLORINDEX -gt 252 ]; then
		COLORINDEX=0
	fi
	COLORA=$(tput setaf ${COLORINDEX})
	COLORB=$(tput setaf $(expr ${COLORINDEX} + 1))
	COLORC=$(tput setaf $(expr ${COLORINDEX} + 2))
	COLORD=$(tput setaf $(expr ${COLORINDEX} + 3))
	COLORINDEX=$(expr ${COLORINDEX} + 4)
	return
}

# Set env vars for helper PS1s
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export VIRTUAL_ENV_DISABLE_PROMPT=1

function venv() {
	venv=""
	if [[ -n "$VIRTUAL_ENV" ]]; then
		venv="[${VIRTUAL_ENV##*/}]"
		echo "${venv} "
		return
	fi
}

# Call venv() to see if there is a valid virtual env, and return the string
VENV="\$(venv)"

# Call getColor to cycle colors
# call __git_ps1 with three arguments:
# - Left side of prompt
# - Right side of prompt
# - printf formatted string that is returned by git_ps1
# 
# Displays, in order:
# - Python VirtualEnv if enabled for the terminal session
# - docker-machine configured machine for the terminal session
export PROMPT_COMMAND='getColor; __git_ps1 "${LEFT_SIDE}\[${COLORA}\]${VENV}${DOCKER_MACHINE_NAME:+▷}${DOCKER_MACHINE_NAME}${DOCKER_MACHINE_NAME:+◁ }${CLEAR}\[${COLORB}\]($(date +%H:%M))${CLEAR} " "\[${COLORC}\]\W/\[${COLORD}\]> ${CLEAR}${CLEAR}" "${LEFT_CORNER}(%s) "'

# Original source for these companion scripts:
# - https://github.com/git/git/tree/master/contrib/completion
# 
# If you're using a non-bash shell, explore the repo above.
# This version of git-prompt.sh has some hacking in
source "$HOME/scripts/git/git-prompt.sh"
source "$HOME/scripts/git/git-completion.bash"
