#!/usr/bin/perl

use strict;
use IO::Socket;
use DBI;

my $port = 11270;
my $maxlen = 1024000;
my $newlog;

my %data;
my $sock = IO::Socket::INET->new(
		LocalAddr => '206.251.244.44',
		LocalPort => 11270,
		Proto => 'udp') || die "socket: $!";

my %lookup = (
	'ARDUINO' => {
		f => 'house',
		k => [
			{ k => 'wa', value => 'wood_avail', },
			{ k => 'pu', value => 'public_heat', },
			{ k => 'pr', value => 'private_heat', },
			{ k => 'hw', value => 'hot_water', },
			],
		},
	'SOLAR' => {
		f => 'solar',
		k => [
			{ k => 'r', value => 'water_middle', },
			{ k => 't', value => 'water_bottom', },
			{ k => 'l', value => 'light_level', },
			{ k => 'p', value => 'solar_pump', },
			],
		},
	'BOILER' => {
		f => 'boiler',
		k => [
			{ k => 'bo', value => 'boiler_temp', },
			{ k => 'gt', value => '', },
			{ k => 't', value => 'tank_temp', },
			{ k => 'r', value => 'boiler_run', },
			{ k => 'f', value => 'boiler_fire', },
			{ k => 'g', value => '', },
			{ k => 'a', value => 'aquistat', },
			],
		},
	'TED' => {
		f => 'electric',
		k => [
			{ k => 'k', value => 'kw_now', },
			{ k => 't', value => 'kw_today', },
			{ k => 'p', value => 'kw_peak_today', },
			],
		},
	);

while ($sock->recv($newlog,$maxlen)) {
	#print "$newlog\n";
	#next;
	my %n;
	if ($newlog =~ m/^([A-Z]+):(.+)$/) {
		my $type = $1;
		next unless(defined($lookup{$type}));

		my $logdata = $2;
		foreach my $kv (split ';', $logdata) {
			my ($k,$v) = split '=', $kv;
			$n{$k} = $v;
		}

		my @out;
		my %insert;
		foreach my $ref (@{$lookup{$type}{k}}) {
			# save rrd stuff
			my $k = $ref->{k};
			my $v = $ref->{value};
			if (defined($n{$k})) {
				$insert{$v} = $n{$k};
				push @out, $n{$k} unless($v eq 'heat');
			} else {
				push @out, 'U' unless($k eq 'heat');
			}
		}

		my $value = join ':', @out;
	#	`rrdtool update /data/rrd/$lookup{$type}{f} N:$value`;

		if (keys %insert) {
			eval {
				db_insert('loginput',\%insert);
				};
			if ($@) {
				print STDERR "$@\n";
			}
		}	
	}
}

$sock->close();

sub db_insert {
	my $table = shift;
	my $data = shift;
	my $keyfield = shift;

	my (@keys,@values,$key,@bind);

	foreach $key (keys %$data) {
		next if ($data->{$key} eq '');
		next if ($data->{$key} eq 'NULL');
		push @keys, qq($key);
		if ($data->{$key} =~ m/^_raw:(.+)$/) {
			push @bind, $1;
			next;
		}
		push @bind, '?';
		push @values, $data->{$key};
	}

	my $columns = join ',', @keys;
	my $bind = join ',', @bind;

	my $query = qq|INSERT INTO $table ($columns) VALUES ($bind)|;
	if ($keyfield) {
		$query .= " RETURNING $keyfield";
	}

	my $dbh = DBI->connect("dbi:Pg:dbname=rrd",'postgres','', { RaiseError => 1, Warn => 0 });
	$dbh->{RaiseError} = 0;

	my $sth;
	croak $dbh->errstr."\n$query\n\n" unless($sth = $dbh->prepare($query));
	croak $dbh->errstr."\n$query\n@values\n" unless($sth->execute(@values));

	$sth->finish;

	$dbh->disconnect;
}
