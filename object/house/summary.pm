package rrd::object::house::summary;

use strict;
use Carp;

sub main {
	my $s = shift;

	$s->{title} = '808 Pioneer Hill Road';

	my @list = $s->db_q("
		SELECT v.*
		FROM logdata_daily v
		ORDER BY stat_date desc
		",'arrayhash');

	foreach my $ref (@list) {
		# make sure everything is defined for the graph
		foreach my $k (qw(kw_sum wood_avail_percent heat_percent solar_pump_percent hot_water_percent water_bottom_max)) {
			$ref->{$k} = 'null' if ($ref->{$k} eq '');
		}
	}

	$s->tt('house/summary_head.tt', { s => $s, list => \@list, },$s->{head});
	$s->tt('house/summary.tt', { s => $s, list => \@list });
	#$s->tt('house/list.tt', { s => $s, list => \@list, hash => \%hash, date => \%date });
	#$s->{content} .= $s->dump(\%hash);
	#$s->{content} .= $s->dump(\@list);
}
	
1;
