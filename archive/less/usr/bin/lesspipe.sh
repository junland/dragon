#! /bin/sh -
# Preprocessor for 'less'.
#
# Copyright (c) 2017 Antonio Diaz Diaz, <antonio@gnu.org>.
# Copyright (c) 2017 Matias Fonzo, <selk@dragora.org>.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

