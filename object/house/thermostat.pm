package rrd::object::house::thermostat;

use strict;
use Carp;

sub main {
	my $s = shift;

	$s->{content_type} = 'text/plain';

	if ($s->{in}{id} 
		&& $s->{in}{t} =~ m/^[0-9\.]+$/ 
		&& $s->{in}{s} =~ m/^\d+$/
		&& $s->{in}{o} =~ m/^(0|1)$/) {

		my %tmp = $s->db_q("
			SELECT *
			FROM rrd_thermostats
			WHERE code=?
			",'hash',
			v => [ $s->{in}{id} ]);

		if ($tmp{n}) {
			my $n = $tmp{n};
			$s->db_insert('loginput',{
				"thermostat${n}_temp" => $s->{in}{t},
				"thermostat${n}_db_setpoint" => $tmp{setpoint},
				"thermostat${n}_setpoint" => $s->{in}{s},
				"thermostat${n}_on" => $s->{in}{o},
				});
			$s->{content} = $tmp{setpoint};
		} else {
			$s->{content} = 'invalid_id';
		}
	} else {
		$s->{content} = 'invalid_data';
	}
}
	
1;
