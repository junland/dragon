#
# .profile - Personal shell-initialization file.
#
# The instructions here could serve to complement
# /etc/profile or to override default (previous)
# values.
#

# Add personal bin directory to the end of path
# and make it known to child process

PATH=${PATH}:${HOME}/bin
export PATH

