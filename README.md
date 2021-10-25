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
Do a good job.

This is the `DS` record itself, for the KSK I have used - so this is the `DS` that this resolver will be validating 
against. If you want to do a full DNSSEC validation, you will need this `DS` to validate the ROOT/KSK.

	trust-anchors { . static-ds 7482 14 2 "313A31171A3D420E339EFD610CF967FA8F047C19ECAADE151DBF4D78870EEADF"; };

I used this https://github.com/buffrr/hsd-axfr plug-in for `hsd` to get the merged DNS data out of `hsd`, then 
used dynamic signing in `bind` to sign the zone.

All you need is something like this

	zone "." {
		type slave;
		masters { 127.0.0.9; };
		file "/data/zones/ROOT.merged";

		key-directory "/keys";
		auto-dnssec maintain;
		inline-signing yes;
		};

Where your `hsd` (that has the `axfr` plug-in) is listening on `127.0.0.9`
