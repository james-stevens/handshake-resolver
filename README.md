# handshake-resolver
This is a container running a `bind` DNS Resolver with a Handshake &amp; ICANN ROOT data to
provide a robust and fully RFC compliant DNS resolver service, with full DNSSEC suppport, for
all TLDs contained in both the ICANN and Handhsake environments.

Where there are TLDs that exist in both Handshake and ICANN, for backwards compatibility, I give
preference to the ICANN one.


## ROOT Zone XFR Support
This container will also support making the ROOT zone available by XFR (AXFR / IXFR) to anybody who asks.
This is a new fewature in v1.1

