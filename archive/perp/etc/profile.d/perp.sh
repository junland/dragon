
# Set base scanning directory for the perpd process
test -n "${PERP_BASE+$PERP_BASE}" || PERP_BASE=/etc/perp

export PERP_BASE

