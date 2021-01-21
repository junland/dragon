
# Set QTDIR if unset

test -n "${QTDIR+$QTDIR}" || QTDIR=/opt/trinity/lib/tqt3-trinity

export QTDIR

# Expand Trinity's binaries path (if not already added)

if ! printf '%s\n' "$PATH" | grep -q /opt/trinity/bin
then
    PATH="${PATH}:/opt/trinity/bin"
    export PATH
fi

