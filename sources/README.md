# README

There are two ways to get the sources used by Dragora:

  1. Source list.
  2. RSYNC protocol.

  Normally we obtain the sources from original sites (upstream).

Full address of sources files are in the "SOURCELIST.txt" file.  A copy
of these files can be found via RSYNC at [rsync://rsync.dragora.org][1]

Please, [check our mirrors][2].

## Instructions

### 1. Source list.

Download all the sources from the list, one by one:

    wget -c -i SOURCELIST.txt

If your wget(1) implementation lacks '-i', try with:

    cat SOURCELIST.txt | wget -c -

### 2. RSYNC protocol.

    rsync -rvaiz --progress rsync://rsync.dragora.org/dragora/current/sources/ .

Note, if you are upgrading an (already) out-of-date sources directory
and want to make it clear, add the following options:

    rsync -rvaiz --progress --exclude=README.md --delete-delay \
     rsync://rsync.dragora.org/dragora/current/sources/ .

The command and options above will preserve the README.md file while deletes
any previous source.

The tarballs will be stored on the current working directory.

### Recommendation

Download all the sources from the list.

Use the RSYNC protocol to download missing sources.

## Check sums

Remember to check if everything is OK.  To check the integrity of all
the tarballs using sha256sum(1), type:

    sha256sum --quiet --check *.sha256


[1]: http://rsync.dragora.org "Browse via HTTP"
[2]: https://dragora.org/en/mirrors.html

