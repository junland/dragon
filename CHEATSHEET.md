# Dragora's Cheatsheet

## Bootstrapping

Prerequisities:

- Clone or sync the git repository.

- Obtain or sync the sources (tarballs).  See the *sources/README.md* file.

Instructions:

1. `./bootstrap -s0 2>&1 | tee stage0-log.txt`

2. `./bootstrap -s1 2>&1 | tee stage1-log.txt`

3. `./enter-chroot`

4. `qi -o /usr/src/qi/recipes/*.order | qi -b -S -p -i - 2>&1 | tee build-log.txt`

5. `passwd`

6. `exit`

7. `./bootstrap -s2 2>&1 | tee stage2-log.txt`

8. Burn or emulate the ISO image.

