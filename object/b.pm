# $Id: $
package rrd::object::b;

use strict;
use Carp;

sub config {
	my $s = shift;
	
	return {
		public => 1,
		functions => {
			s => 'Save',
			},
		fields => [
			{ k => 'name', t => 'Name' },
			],
		};
}

sub s {
	my $s = shift;

	my @v = (
		{ k => 'o' => 'boiler' },
		{ k => 'i' => 'boiler_in', },
		{ k => 'gt' => 'garage_temp', },
		{ k => 't' => 'outside', },
		{ k => 'h' => 'public', },
		{ k => 'pr' => 'private', },
		{ k => 'hw' => 'hotwater', },
		{ k => 'r' => 'boiler_run', },
		{ k => 'f' => 'boiler_fire', },
		{ k => 'g' => 'garage', },
		{ k => 'mb' => 'masterbath', },
		{ k => 'mbd' => 'masterbed', },
		{ k => 'arla' => 'arla', },
		{ k => 'sam' => 'sam', },
		{ k => 'hall' => 'hall', },
		);
	
	my @out;
	foreach my $ref (@v) {
		if (defined($s->{in}{$ref->{k}})) {
			push @out, $s->{in}{$ref->{k}};
		} else {
			push @out, 'U';
		}
	}
	my $value = join ':', @out;

	$s->{content_type} = 'text/plain';
	$s->{content} = "/usr/bin/rrdtool update /data/rrd/boilerdata2 N:$value";
	my $results = `/usr/bin/rrdtool update /data/rrd/boilerdata2 N:$value 2>&1`;
	$s->{content} .= "\nresults=$results\n";
}

1;
