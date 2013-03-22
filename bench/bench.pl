#!/usr/bin/perl -w

use strict;
use integer;

use lib '../blib/lib', '../blib/arch';
use IQStream;

use Benchmark qw(:all);

my $filename = shift || '-';

my $bufsize = 2 * 16384;
my $buf = 0 x $bufsize;
map { substr($buf, $_, 1)=chr(rand(256)) } (0..$bufsize-1);

my $buf1 = $buf;
my $buf2 = $buf;
my $buf3 = $buf;

my @amp_cache;

# sub SCALE_BITS() { 8 }
sub SCALE_BITS() { 0 }
# sub AVG_FACTOR_BITS() { 2 }

my ($i, $q, $amp);

sub calc_amp($$) {
	my ($i,$q) = @_;
	$amp_cache[$i][$q] = int(sqrt(($i*$i+$q*$q) << (SCALE_BITS() * 2)));
	return $amp_cache[$i][$q];
}

my $test = {
  'perl-0' => sub {
	foreach my $s (0..(length($buf)/2-1)) {
		$i = ord(substr($buf, $s*2, 1));
		$q = ord(substr($buf, $s*2 + 1, 1));
		# print "$i\t$q\t";
		$i = $i & 0x80 ? $i & 0x7F : $i ^ 0x7F;
		$q = $q & 0x80 ? $q & 0x7F : $q ^ 0x7F;
		$amp = calc_amp($i, $q);
	}
  }, ######################
  'perl-1' => sub {
	foreach my $s (0..(length($buf1)/2-1)) {
		$i = ord(substr($buf1, $s*2, 1));
		$q = ord(substr($buf1, $s*2 + 1, 1));
		# print "$i\t$q\t";
		$i = $i & 0x80 ? $i & 0x7F : $i ^ 0x7F;
		$q = $q & 0x80 ? $q & 0x7F : $q ^ 0x7F;
		$amp = $amp_cache[$i][$q];
		$amp = calc_amp($i, $q) unless defined $amp;
	}
  }, ######################
  'xs-full' => sub {
		IQStream::Convert_IQ_to_amplitude_buf($buf2, length($buf2), 0);
  }, ######################
#  'xs-full-scale' => sub {
#		IQStream::Convert_IQ_to_amplitude_buf($buf3, length($buf3), 8);
#  }, ######################
};

my $count = -2;
my $results = timethese($count, $test);
cmpthese($results);
