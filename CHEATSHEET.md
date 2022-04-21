# Dragora's Cheat Sheet

## Bootstrapping

Prerequisites:

- A working C compiler, system toolchain, utilities.

- A filesystem that supports Unix-like permissions.

- Enough hard disk space (7GB+) for the whole process.

- A superuser account is needed to perform all the steps.

- Clone or sync the git repository.

- Obtain or sync the sources (tarballs).  See the *sources/README.md* file.

Bootstrapping from Debian systems:

`apt update && apt upgrade`

`apt install bison build-essential file flex git lzip xorriso texinfo unzip zlib1g zlib1g-dev liblz1 liblz-dev`

### Instructions:

Creates a cross compiler for your native architecture:

`./bootstrap -s0 2>&1 | tee stage0-log.txt`

Prepare a temporary system using the recent cross compiler:

`./bootstrap -s1 2>&1 | tee stage1-log.txt`

Enter the temporary system:

`./enter-chroot`

Start replacing the temporary system with the final system:

`qi order /usr/src/qi/recipes/*.order | qi build -S -p -i - 2>&1 | tee build-log.txt`

Set custom modifications, like a password for the superuser:

`passwd root`

Exit from the temporal session (enter-chroot):

`exit`

Produce an ISO image from the Stage 2:

`./bootstrap -s2 2>&1 | tee stage2-log.txt`

Burn or emulate the (hybrid) ISO image at
*OUTPUT.bootstrap/stage2/cdrom/dragora-live.iso*.

Hints:

To speed up the build procedure multiple jobs can be passed to the compiler.<br/>
Just give the -j option to the *bootstrap* script and pass the same one to the<br/>
connected *qi* in the pipe.  Consider the value for -j taking into account the<br/>
number of processors + 1, for example `-j3`


---

Under the terms of the GNU Free Documentation License,
http://www.gnu.org/licenses/fdl.html

Updated: 2022-04-21
