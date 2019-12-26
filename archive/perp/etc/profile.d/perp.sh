
# Set base scanning directory for the perpd process
test -n "${PERP_BASE+$PERP_BASE}" || PERP_BASE=/etc/perp

# Colorize perpls(8) output
test -n "${PERPLS_COLORS+$PERPLS_COLORS}" || \
 PERPLS_COLORS="df=00:na=00:an=01:ar=01;33:ap=01;33:\
ad=01;34:wu=01;33:wd=01;33:er=01;31:ex=01;31"

export PERP_BASE PERPLS_COLORS

