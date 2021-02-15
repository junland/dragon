# Set default warning level for Glib-based applications.
# The value of the variable is a digit that corresponds to:
#    1 Alert
#    2 Critical
#    3 Error
#    4 Warning
#    5 Notice 

test -n "${GLIB_LOG_LEVEL+$GLIB_LOG_LEVEL}" || GLIB_LOG_LEVEL=4
export GLIB_LOG_LEVEL

