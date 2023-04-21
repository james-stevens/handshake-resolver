# handshake-resolver
This is a container running a `bind` DNS Resolver with a Handshake &amp; ICANN ROOT data to
provide a robust and fully RFC compliant DNS resolver service, with full DNSSEC suppport, for
all TLDs contained in both the ICANN and Handhsake environments.

Where there are TLDs that exist in both Handshake and ICANN, for backwards compatibility, I give
preference to the ICANN one.


## ROOT Zone XFR Support
This container will also support making the ROOT zone available by XFR (AXFR / IXFR) to anybody who asks.
This is a new fewature in v1.1


## NOTE

NOTE: The merged ROOT zone is signed using keys that I hold, so you are effectively trusting me to
do a good job.

This is the `DS` record itself, for the KSK I have used - so this is the `DS` that this resolver will be validating 
against. If you want to do a full DNSSEC validation, you will need this `DS` to validate the ROOT/KSK.

	trust-anchors { . static-ds 7482 14 2 "313A31171A3D420E339EFD610CF967FA8F047C19ECAADE151DBF4D78870EEADF"; };

I used this https://github.com/buffrr/hsd-axfr plug-in for `hsd` to get the merged DNS data out of `hsd`, then 
used dynamic signing in `bind` to sign the zone.



# Siging the merged ROOT yourself

### 1. Run a copy of `hsd` with the `axfr` plug-in

If you make it listen in an address in the `localhost` subnet, say `127.0.0.9`, then an AXFR can't be done from outside.

You will also need to use the `--no-sig0` option to keep `bind` happy, so add the following command line options to `hsd` when you start it

	--ns-host 127.0.0.9
	--ns-port 53
	--no-sig0


### 2. Make a set of keys

Make a set of keys (KSK & ZSK) & put them in the sub-directory `/keys` in your `named` `chroot` directory

Use `dnssec-keygen` for this.


### 3. Add the following to your `named.conf`

	zone "." {
		type slave;
		masters { 127.0.0.9; };
		file "/data/zones/ROOT.merged";

		key-directory "/keys";
		auto-dnssec maintain;
		inline-signing yes;
		};

Where your `hsd` (that has the `axfr` plug-in) is listening on `127.0.0.9` (see above)

You will also need the follow items in the `options` section of your `named.conf`

	check-names master ignore;
	check-names slave ignore;
	check-names response ignore;
	check-sibling no;
	check-integrity no;

	request-ixfr no;
	send-cookie no;
	answer-cookie no;
	require-server-cookie no;

And you will need the following `server` clause, in `named.conf`. This is *NOT* in the `options` section.

	server 127.0.0.9 { edns no; };


### 4. Run a local slave of the ICANN ROOT

To make the AXFR more reliable & faster, its better to run a local slave of the ICANN ROOT zone. `named` will update the ICANN
ROOT using incremental updates & a local copy will ensure the data is always available.

Here's an IPv4 set-up for slaving the ICANN ROOT zone. If your server has IPv6 support you can the IPv6 masters too

	zone "." {
		type slave;
		file "/zones/icann.db";
		notify no;
		masters {
			192.228.79.201; # b.root-servers.net
			192.33.4.12; # c.root-servers.net
			192.5.5.241; # f.root-servers.net
			192.0.47.132; # xfr.cjr.dns.icann.org
			192.0.32.132; # xfr.lax.dns.icann.org
			};
		};

Running a local ICANN ROOT slave is optional, but I like to do it as it costs very little in resources.

Once you have a local copy of the ICANN ROOT, you will need to tell `hsd` about it.
 I have my ICANN ROOT slave listening on `127.1.0.1`, so add the `hsd` command line option

	--axfr-icann-servers=127.1.0.1

NOTE: `named` is fussy & will not listen on a localhost IP Address unless it is explicitly assigned to your `lo` interface.
Most other server software does not have this restriction, but its easy to get fix. At start-up, as `root`, run this command

	ip addr add 127.1.0.1/8 dev lo



