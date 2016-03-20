#!/usr/bin/perl

use strict;
use XML::Simple;
use WWW::Curl::Simple;
use Data::Dumper;

my $host = $ARGV[0];
my %type = (
	'10.1.0.4' => "house/elecg",
	'10.1.0.6' => "house/elech",
	);

exit unless($host);

exit unless($type{$host});

eval {
	my $curl = WWW::Curl::Simple->new(check_ssl_certs => 0, timeout => 2);
	my $resp = $curl->get("http://$host/api/LiveData.xml");
	if ($resp->is_success) {
		my $xml;
		eval { $xml = XMLin($resp->content); };
		if ($@) {
			exit;
		}
	
		my $watts = $xml->{'Power'}{'Total'}{'PowerNow'};
		if ($watts) {
			my $kw = sprintf "%.2f", $watts/1000;
			my $rcurl = WWW::Curl::Simple->new(check_ssl_certs => 0, timeout => 10);
			my $rresp = $rcurl->get("http://rrd.smalldognet.com/$type{$host}?kw_now=$kw");
			print $rresp->content;
		}
	}
}

