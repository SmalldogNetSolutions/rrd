package rrd::object::house::btu;

use strict;
use Carp;

sub main {
	my $s = shift;

	if ($s->{in}{process}) {
		$s->{in}{btu} = sprintf "%.2f", $s->{in}{gallons}*8.345404*($s->{in}{end_temp}-$s->{in}{start_temp});

		$s->{in}{kwh} = sprintf "%.2f", $s->{in}{btu}/3412.14;

		if ($s->{in}{kwh_cost}) {
			$s->{in}{btu_cost} = sprintf "%.2f", $s->{in}{kwh_cost}*$s->{in}{kwh};
		}
	}

	$s->tt('house/btu.tt', { s => $s, });
}
	
1;
