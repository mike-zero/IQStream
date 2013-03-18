#!/opt/perl5/bin/perl

use ExtUtils::testlib;
use IQStream;

my $buf = "\x00\x01\x40\x60\x7E\x7F\x80\x81\xA0\xF0\xFF";

printf(('%02X ' x length($buf)) ."\n", unpack('C*', $buf));
IQStream::IQ_normalize_zero($buf, length($buf)-1, 0);
printf(('%02X ' x length($buf)) ."\n", unpack('C*', $buf));

my $buf = "\x00\x01\x40\x60\x7E\x7F\x80\x81\xA0\xF0\xFF";
printf(('%02X ' x length($buf)) ."\n", unpack('C*', $buf));
IQStream::IQ_normalize_zero($buf, length($buf)-1, 1);
printf(('%02X ' x length($buf)) ."\n", unpack('C*', $buf));
