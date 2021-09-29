Qi
==

Qi is a simple but well-integrated package manager.  It can create,
install, remove, and upgrade software packages.  Qi produces binary
packages using recipes, which are files containing specific instructions
to build each package from source.  Qi can manage multiple packages
under a single directory hierarchy.  This method allows to maintain a
set of packages and multiple versions of them.  This means that Qi could
be used as the main package manager or complement the existing one.

   Qi offers a friendly command line interface, a global configuration
file, a simple recipe layout to deploy software packages; also works
with binary packages in parallel, speeding up installations and packages
in production.  The format used for packages is a simplified but safe
POSIX pax archive compressed with lzip.

   Qi is a modern (POSIX-compliant) shell script released under the
terms of the GNU General Public License.  There are only two major
dependencies for the magic: graft(1) and tarlz(1), the rest is expected
to be found in any Unix-like system.

Requirements
------------

- A POSIX-compliant shell.

- Graft for handling symlinks: https://peters.gormand.com.au/Home/tools
  Alternatively from https://rsync.dragora.org/current/sources/

- Perl in order to run Graft: https://www.perl.org

- Tarlz for produce binary packages: https://lzip.nongnu.org/tarlz.html

### Note

Take into account when you are going to install graft, you can define some
macros like PACKAGEDIR and TARGETDIR.  To be consistent, please use the
same paths when `configure` adjusting them through the --packagedir and
--targetdir options.

If you have not changed the default values used on the graft installation,
you can avoid these steps, since qi uses the same values of graft for
PACKAGEDIR and TARGETDIR.

Installation
------------

To configure, make and install qi, type:

    $ ./configure
    $ make
    $ make install

See `./configure --help` for more options.

To install qi in a different location, type:

    $ make DESTDIR=/tmp/qi install

This is useful for package distributors.

Contact
-------

  The Qi home page can be found at https://www.dragora.org.
Send bug reports or suggestions to <dragora-users@nongnu.org>.
