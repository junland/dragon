
# Expand Trinity's path, if needed

# Set path for Trinity binaries
case $PATH in
*/opt/trinity/bin*)
    true
    ;;
*)
    # Set path for Tqt3 and Trinity binaries
    PATH="${PATH}:/opt/trinity/bin"
    export PATH
    ;;
esac

# Set path for search pkg-config files
case $PKG_CONFIG_PATH in
*/opt/trinity/lib*)
    true
    ;;
*)
    PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:/opt/trinity/lib/pkgconfig"
    export PKG_CONFIG_PATH
    ;;
esac

