#! /usr/bin/perl

# Credit for the main guts of this program goes to David Satterfield <david_misterhouse@yahoo.com>

use strict;
use Getopt::Std;
use Device::SerialPort;
use Carp;
use IO::Socket;
use Data::Dumper;

my %args;
getopts('vd:',\%args);

unless($args{d}) {
	print "Usage ted.pl [-v] -d serialdevice\n";
	exit;
}

my $break = "\cP\cC";

my $dev = new Device::SerialPort($args{d})
	|| die "Cant open $args{d}: $!\n";

$dev->error_msg(1);
$dev->user_msg(0);
$dev->baudrate('19200');
$dev->stopbits(1);
$dev->databits(8) if ($dev->can_databits);
$dev->parity('none');
$dev->handshake('none');
$dev->write_settings;

while (1) {
	my $data = _getdata();
	last if (_processdata($data));
}

sub _getdata {
	# send TED a data request
	$dev->write(pack "C", 0xAA);
	my $data;
	while (1) {
		my $input = $dev->input;
		next unless($input);
		$data .= $input;
		# look for our break character, and then bail out
		if ($data =~ m/^(.+)$break/s) {
			$data = $1;
			last;
		}
	}

	return $data;
}

sub _processdata {
	my $data = shift;

	my @p = unpack("C*", $data);
	my $chars = scalar @p;
	# not totally sure what's going on here, just borrowed this
	for (my $i = 0; $i < $#p-1; $i++) {
		splice(@p, $i, 1) if ($p[$i] == 0x10 && $p[$i+1] == 0x10);
	}

	my $tedstr = pack "CCCC", $p[113],$p[114],$p[115],$p[116];
	my %out;
	# We want $tedstr to be 'TED ' otherwise, it's a bad packet
	if ($tedstr eq 'TED ') {
		$out{kw_now} = (($p[250] * 256) + $p[249])/100;	
		$out{watt_today} = (($p[163] * 256 * 256 * 256) +
			($p[162] * 256 * 256) +
			($p[161] * 256) +
			($p[160]));
		$out{kw_today} = sprintf "%.2f", $out{watt_today}/60000;
		$out{kw_peak_today} = (($p[149] * 256) + $p[148])/100;

		my $output = "TED:k=$out{kw_now};p=$out{kw_peak_today};t=$out{kw_today}";
		my $sock = IO::Socket::INET->new(
			PeerAddr => '10.0.1.1',
			PeerPort => 11270,
			Proto => 'udp');
		print $sock $output;
		$sock->close();

		print "$output\n" if ($args{v});
		print Data::Dumper->Dump([\%out]) if ($args{v});
		return 1;
	} else {
		return 0;
	}
}
