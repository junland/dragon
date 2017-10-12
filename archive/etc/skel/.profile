#
# .profile - Personal shell-initialization file.
#

# Add personal bin directory to the end of path
# and make it known to child process

PATH=${PATH}:${HOME}/bin
export PATH

# Remove all access for group and other
umask 077

