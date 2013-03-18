#!/opt/perl5/bin/perl

use ExtUtils::testlib;
use IQStream;

#my $buf0 = "\x00\x01\x40\x60\x7E\x7F\x80\x81\xA0\xF0\xFF";
my $buf0 = "\xB0\xC0\xFF\xFF";

my $buf = $buf0;
printf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));
IQStream::IQ_normalize_zero_buf($buf, length($buf), 0);
printf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));

$buf = $buf0;

printf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));
IQStream::Convert_IQ_to_amplitude_buf($buf, length($buf));
printf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));
