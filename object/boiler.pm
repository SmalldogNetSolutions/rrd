# $Id: $
package rrd::object::boiler;

use strict;
use Carp;

sub config {
	my $s = shift;
	
	return {
		public => 1,
		functions => {
			display => 'Display',
			list => 'List',
			},
		fields => [
			{ k => 'name', t => 'Name' },
			],
		};
}

sub display {
	my $s = shift;

}

sub list {
	my $s = shift;

	my @list = $s->db_q("
		SELECT start_ts, end_ts, 
			(extract('epoch' from end_ts-start_ts)/60)::int4 as minutes,
			(value_int*8.3*60)::int4 as btus,
			(value_int*8.3*60*0.000293)::numeric(10,1) as kwh,
			((value_int*8.3*60)/
			(extract('epoch' from end_ts-start_ts)/3600))::int4 as btus_hr
		FROM valuelog
		WHERE key='boiler'
		ORDER BY start_ts desc
		",'arrayhash');

	my @day = $s->db_q("
		SELECT x.stat_date, sum(x.minutes) as minutes,
			sum(x.btus)::int4 as btus,
			sum(x.kwh)::int4 as kwh
		FROM (
			SELECT date(start_ts) as stat_date,
				(extract('epoch' from end_ts-start_ts)/60)::int4 as minutes,
				(value_int*8.3*60.0) as btus,
				(value_int*8.3*60.0*0.000293) as kwh
			FROM valuelog
			WHERE key='boiler'
			AND value_int > 0) x
		GROUP BY 1
		ORDER BY 1 desc
		",'arrayhash');

	my @thermos = $s->db_q("
		SELECT y.stat_date, y.key, y.on, y.off, y.on+y.off as total,
			CASE WHEN y.on+y.off != 0 THEN (y.on/(y.on+y.off))::numeric(10,3) 
				ELSE NULL END as percent_on,
			CASE WHEN y.on+y.off != 0 THEN (y.off/(y.on+y.off))::numeric(10,3) 
				ELSE NULL END as percent_off,
			CASE WHEN y.key IN ('private','public','heat') 
				THEN (y.on*25000)::int4 ELSE NULL END as btus,
			CASE WHEN y.key IN ('private','public','heat') 
				THEN (y.on*25000*0.000293)::int4 ELSE NULL END as kwh
		FROM (
			SELECT x.stat_date, x.key,
				(sum(CASE WHEN x.value_int = 0 THEN x.minutes 
					ELSE 0 END)/60.0)::numeric(10,1) as on,
				(sum(CASE WHEN x.value_int = 1 THEN x.minutes 
					ELSE 0 END)/60.0)::numeric(10,1) as off
			FROM (
				SELECT date(start_ts) as stat_date, value_int, key,
					(extract('epoch' from end_ts-start_ts)/60)::int4 as minutes
				FROM valuelog
				WHERE key IN ('public','private','hotwater','heat')) x
			GROUP BY 1,2) y
		ORDER BY 1 desc, 2
		",'arrayhash');

	$s->tt('boiler/list.tt', { s => $s, list => \@list, day => \@day, thermos => \@thermos });
}

1;
