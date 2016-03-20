package rrd::object::house::list;

use strict;
use Carp;

sub main {
	my $s = shift;

	$s->{title} = '808 Pioneer Hill Road';

	my $d = $s->{in}{d} || $s->{datetime}{ymd};

	my %date = $s->db_q("
		SELECT date(?) as this_date,
			date(date(?) + interval '1 day') as next_date,
			date(date(?) - interval '1 day') as last_date
		",'hash',
		v => [ $d, $d, $d ]);

	my %hash = $s->db_q("
		SELECT v.*
		FROM logdata_daily v
		WHERE v.stat_date=?
		",'hash',
		v => [ $d ]);

	my @list;
	if ($s->{in}{d}) {
		@list = $s->db_q("
			SELECT v.*, to_char(v.log_ts,'HH12:MI AM') as log_time,
				COALESCE(v.kw_now,0)+COALESCE(v.kw_now_g,0) as kw_now_t
			FROM logdata v
			WHERE date(v.log_ts)=?
			ORDER BY log_ts
			",'arrayhash',
			v => [ $d ]);
	} else {
		@list = $s->db_q("
			SELECT v.*, to_char(v.log_ts,'HH12:MI AM') as log_time,
				COALESCE(v.kw_now,0)+COALESCE(v.kw_now_g,0) as kw_now_t
			FROM logdata v
			WHERE v.log_ts >= now() - interval '24 hours'
			ORDER BY log_ts
			",'arrayhash');
	}

	my %booleans = (
		'hot_water' => 1.05,
		'solar_pump' => 1.15,
		'public_heat' => '1.15',
		'private_heat' => '1.25',
		'wood_avail' => '1.35',
		'boiler_run' => 1.05,
		'boiler_fire' => 1.15,
		);

	foreach my $ref (@list) {
		foreach my $k (keys %booleans) {
			if ($ref->{$k} eq '0') {
				$ref->{$k} = 1*$booleans{$k};
			} else {
				$ref->{$k} = 'null';
			}
		}

		foreach my $k (keys %{$ref}) {
			$ref->{$k} = 'null' if ($ref->{$k} eq '');
		}
	}

	my $f = $s->{in}{f};
	$s->tt("house/list_head$f.tt", { s => $s, list => \@list, hash => \%hash },$s->{head});
	$s->tt("house/list$f.tt", { s => $s, list => \@list, hash => \%hash, date => \%date });
	#$s->{content} .= $s->dump(\%hash);
	#$s->{head} .= $s->dump(\@list);
}
	
1;
