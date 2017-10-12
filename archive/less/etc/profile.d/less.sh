
# Set environment for less(1), setting lesspipe.sh,
# default options, and default charset

LESSOPEN="| lesspipe.sh %s"
LESS="-isRM"
LESSCHARSET=utf-8

export LESSOPEN LESS LESSCHARSET

