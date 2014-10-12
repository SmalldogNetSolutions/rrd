package rrd::object::house::ip;

use strict;
use LWP;
use Carp;

sub main {
	my $s = shift;

	my $ip = $s->{in}{ip} || $s->{remote_addr};

	my $ua = new LWP::UserAgent;
	my $req = new HTTP::Request('PUT' => "https://dnsimple.com/domains/smalldognet.com/records/27370");
	$req->header('X-DNSimple-Domain-Token','WGV79aTELDpImue70zNhudnXxFIWXJ1hAQ');
	$req->content_type('application/json');
	$req->content(qq({"record":{"content":"$ip"}})); 
	#my $str = $req->as_string;
	#$s->{content} = $str;
	my $resp = $ua->request($req);
	
	$s->{content} = $resp->content;
}
	
1;
