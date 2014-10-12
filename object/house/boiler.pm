package rrd::object::house::boiler;

use strict;
use Carp;

sub main {
	my $s = shift;

	$s->{content_type} = 'text/plain';

	my %fields = (
		bo => 'boiler_temp', 
		t => 'tank_temp', 
		r => 'boiler_run', 
		f => 'boiler_fire', 
		a => 'aquistat', 
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
