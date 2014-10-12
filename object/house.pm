package rrd::object::house;

use strict;
use Carp;

sub config {
	my $s = shift;

	return {
		public => 1,
		functions => {
			list => 'List',
			ip => 'IP',
			btu => 'BTU',
			thermostat => 'Thermostat',
			solar => 'Solar',
			boiler => 'Boiler',
			heat => 'Heat',
			summary => 'Summary',
			},
		};
}

1;
