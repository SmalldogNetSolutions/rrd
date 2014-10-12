package rrd::object::house::solar;

use strict;
use Carp;

sub main {
	my $s = shift;

	$s->{content_type} = 'text/plain';

	my %fields = (
		r => 'water_middle',
		t => 'water_bottom',
		l => 'light_level',
		p => 'solar_pump',
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
