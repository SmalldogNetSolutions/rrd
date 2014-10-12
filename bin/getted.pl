#!/usr/bin/perl

use strict;
use XML::Simple;
use Data::Dumper;
use DBI;

my $data;
while (<STDIN>) {
	$data .= $_;
}

my $xml;
eval { $xml = XMLin($data); };
if ($@) {
	exit;
}

my $watts = $xml->{'Power'}{'Total'}{'PowerNow'};
if ($watts) {
	my $kw = sprintf "%.2f", $watts/1000;
	#print "$kw\n";
	db_insert('loginput',{
		kw_now => $kw,
		});
}

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
