#!/opt/perl5/bin/perl

use ExtUtils::testlib;

use lib '../blib/lib', '../blib/arch';
use IQStream;

#my $buf0 = "\x00\x01\x40\x60\x7E\x7F\x80\x81\xA0\xF0\xFF";
my $buf0 = "\xB0\xC0\xFF\xFF\x4F\x3F";

my $buf = $buf0;
printf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));
IQStream::IQ_normalize_zero_buf($buf, length($buf), 0);
printf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));

$buf = $buf0;

# printf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));
IQStream::Convert_IQ_to_amplitude_buf($buf, length($buf), 0);
printf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));

$buf = $buf0;
IQStream::Convert_IQ_to_amplitude_buf($buf, length($buf), 1);
printf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));

$buf = $buf0;
IQStream::Convert_IQ_to_amplitude_buf($buf, length($buf), 2);
printf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));

$buf = $buf0;
IQStream::Convert_IQ_to_amplitude_buf($buf, length($buf), 4);
printf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));

$buf = $buf0;
IQStream::Convert_IQ_to_amplitude_buf($buf, length($buf), 8);
printf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));
