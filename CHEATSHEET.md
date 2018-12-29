# Dragora's Cheat Sheet

## Bootstrapping

Prerequisities:

- Clone or sync the git repository.

- Obtain or sync the sources (tarballs).  See the *sources/README.md* file.

Bootstrapping from Debian systems:

`apt update`

`apt upgrade`

`apt install build-essential flex git lzip texinfo unzip zlib1g zlib1g-dev`

Instructions:

1. `./bootstrap -s0 2>&1 | tee stage0-log.txt`

2. `./bootstrap -s1 2>&1 | tee stage1-log.txt`

3. `./enter-chroot`

4. `qi -o /usr/src/qi/recipes/*.order | qi -b -S -p -i - 2>&1 | tee build-log.txt`

5. `passwd root`

6. `exit`

7. `./bootstrap -s2 2>&1 | tee stage2-log.txt`

8. Burn or emulate the ISO image,
  *OUTPUT.bootstrap/stage2/cdrom/dragora-live.iso*.

Hint:

To speed up the build procedure multiple jobs can be passed to the compiler.<br/>
Just give the -j option to the *bootstrap* script and pass the same one to the<br/>
connected *qi* in the pipe.  Consider the value for -j taking into account the<br/>
number of processors + 1, for example: -j3


---

Under the terms of the GNU Free Documentation License,
http://www.gnu.org/licenses/fdl.html

Updated: 2018-12-29
