# handshake-resolver
Container running `bind` DNS Resolver using Handshake &amp; ICANN ROOT data

This is designed to pair with my `handshake-bridge` to use the merged & signed ROOT
zone to provide a DNS resolver service.

If you look in the `named.conf` file, you will see the `DS` record that belongs to the `KSK`
from the signed ROOT zone I maintain. This means you are trusting me to do a decent job.

If you do not wish to trust me, then all you need to do is produce the merged-signed ROOT
yourself and choose to trust that. You can use my `handshake-bridge` project to do this and its accompanying
cron job to keep the zone up-to-date.

Where the ROOT zone is then laved into this resolver, you will then need to change the
`masters` option to slave the ROOT zone you have produced.

The `handshake-bridge` scripts will generate your own key-set and 
give you a copy of your `DS` records in the file
`dsset-.`. You only need to include the longer one of the two.
