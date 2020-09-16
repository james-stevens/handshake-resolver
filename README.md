# handshake-resolver
This is a container running a `bind` DNS Resolver with a Handshake &amp; ICANN ROOT data to
provide a robust and fully RFC compliant DNS resolver service, with full DNSSEC suppport, for
all TLDs contained in both the ICANN and Handhsake environments.

Where there are TLDs that exist in both Handshake and ICANN, for backwards compatibility, I give
preference to the ICANN one.


## ROOT Zone XFR Support
This container will also support making the ROOT zone available by XFR (AXFR / IXFR) to anybody who asks.
This is a new fewature in v1.1


# handshake-bridge Companion
This is designed to pair with my `handshake-bridge` repo which maintains the merged & signed ROOT
zone for this resolver service. If you run `handshake-bridge` yourself, you
can choose whether to give preference to Handshake or ICANN TLDs. This only affects those 
TLDs that exist in both environments. For now this is only one - `xn--jlq480n2rg.` (`Amazon` in Chinese)

If you look in the `named.conf` file, on the `trust-anchors` line, you will see the `DS` record that belongs to the `KSK`
I used to sign the ROOT zone. This means you are trusting me to do an honest & decent job of merging & signing
the ROOT zone.

If you do not wish to trust me, then all you need to do is produce the merged-signed ROOT
yourself and choose to trust the ROOT zone you have produced & signed. You can use my
`handshake-bridge` repo to do this and use its supplied cron script to keep your signed ROOT zone up-to-date.

In the `named.conf`, where the ROOT zone is slaved into this resolver, you would then need to change the
`masters` option to slave the ROOT zone you have produced.

The `handshake-bridge` `set-up` script will generate your own key-set and produce a copy of your `DS` records
in the file `dsset-.`. You will need to replace the `static-ds` in the `trust-anchors` option in `named.conf`
with the `DS` record from your `KSK`. You only need to use the longer of the `DS` records in the `dsset-.` file.
