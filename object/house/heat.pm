package rrd::object::house::heat;

use strict;
use Carp;

sub main {
	my $s = shift;

	$s->{content_type} = 'text/plain';

	my %fields = (
		wa => 'wood_avail', 
		pu => 'public_heat',
		pr => 'private_heat', 
		hw => 'hot_water',
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
