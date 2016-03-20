package rrd::object::house::elech;

use strict;
use Carp;

sub main {
	my $s = shift;

	$s->{content_type} = 'text/plain';

	my %fields = (
		kw_now => 'kw_now', 
		kw_today => 'kw_today',
		kw_peak_today => 'kw_peak_today', 
		);

	my %insert;

	foreach my $k (keys %fields) {
		if (defined($s->{in}{$k})) {
			$insert{$fields{$k}} = $s->{in}{$k};
		}
	}

	if (keys %insert) {
		$s->db_insert('loginput',\%insert);
		$s->{content} = 'OK';
	} else {
		$s->{content} = 'No data';
	}
}
	
1;
