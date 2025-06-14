NFT Helper
==========

This is a wrapper for nft running under tini.  Its only purpose is to
listen to signals from tini, load nft at start, flush ruleset at exit.

We could use a simple script for this, as shown below, and that would
be fine if we had a POSIX shell in the container.  This helper is for
the case when there is nothing.

```sh
#!/bin/sh
# nft wrapper to load rules at startup and flush at shutdown

flush()
{
    echo "Got signal, stopping ..."
    nft flush ruleset
    exit 0
}

trap flush INT TERM QUIT EXIT

# Load ruleset
nft -f /etc/nftables.conf

# sleep may exit on known signal, so we cannot use 'set -e'
sleep infinity
```
