
# Set PKG_CONFIG and PKG_CONFIG_PATH if unset

test -n "${PKG_CONFIG+$PKG_CONFIG}" || \
 PKG_CONFIG=/usr/bin/pkgconf

test -n "${PKG_CONFIG_PATH+$PKG_CONFIG_PATH}" || \
 PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig:/opt/trinity/lib/pkgconfig

export PKG_CONFIG PKG_CONFIG_PATH

