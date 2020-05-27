
# Output commands to set the LS_COLORS environment variable
if type dircolors > /dev/null
then
    if test -r /etc/DIR_COLORS
    then
        eval "$(dircolors -b /etc/DIR_COLORS)"
    else
        eval "$(dircolors -b)"
    fi
fi

# Make ls(1) aliases for the terminal
#
# Options:
#
#    -b  Print C-style escapes for nongraphic characters.
#    -C  List entries by columns.
#    -l  Use a long listing format.
#    -T  Assume tab stops at each COLS instead of 8.
#    -N  Print entry names without quoting.
#        (See https://bugs.debian.org/813164 for references)
#    --color
#        Colorize the output.
#

if test -n "$LS_COLORS"
then
    alias ls='ls -N -T 0 --color=auto'
    alias dir='ls -N -C -b -T 0 --color=auto'
    alias vdir='ls -N -l -b -T 0 --color=auto'
fi

