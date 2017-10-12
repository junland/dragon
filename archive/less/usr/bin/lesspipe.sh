#! /bin/sh -
# Preprocessor for 'less'.
#
# This lesspipe version was provided by Antonio Diaz Diaz (antonio@gnu.org),
# slightly modified for Dragora by Matias Fonzo (selk@dragora.org).
# Under the terms of the GNU General Public License.
#
# Use with environment variable: LESSOPEN="|lesspipe.sh %s"

case $1 in
*.tar)
    tar -tvvf "$1" 2> /dev/null
    ;;
*.tbz2 | *.tar.bz2)
    bzip2 -cd "$1" 2> /dev/null | tar -tvvf - 2> /dev/null
    ;;
*.t[ag]z | *.tar.gz | *.tar.[zZ])
    tar -tzvvf "$1" 2> /dev/null
    ;;
*.tlz | *.tar.lz)
    lzip -cd "$1" 2> /dev/null | tar -tvvf - 2> /dev/null
    ;;
*.txz | *.tar.xz)
    xz -cd "$1" 2> /dev/null | tar -tvvf - 2> /dev/null
    ;;
*.zip)
    unzip -l "$1" 2> /dev/null
    ;;
*.[1-9n])
    nroff -mandoc "$1"
    ;;
*.[1-9n].bz2)
    bzip2 -cd "$1" 2> /dev/null | nroff -mandoc -
    ;;
*.[1-9n].gz)
    gzip -cd "$1" 2> /dev/null | nroff -mandoc -
    ;;
*.[1-9n].lz)
    lzip -cd "$1" 2> /dev/null | nroff -mandoc -
    ;;
*.bz2)
    bzip2 -cd "$1" 2> /dev/null
    ;;
*.gz | *.[zZ])
    gzip -cd "$1" 2> /dev/null
    ;;
*.lz)
    lzip -cd "$1" 2> /dev/null
    ;;
*.xz)
    xz -cd "$1" 2> /dev/null
    ;;
esac

