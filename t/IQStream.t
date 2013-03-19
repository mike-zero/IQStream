use strict;
use warnings;

use Test::More tests => 9;
BEGIN { use_ok('IQStream') };

my $buf = "\x00\x01\x40\x60\x7E\x7F\x80\x81\xA0\xF0\xFF"; IQStream::IQ_normalize_zero_buf($buf, length($buf), 0); is($buf, "\x7F\x7E\x3F\x1F\x01\x00\x00\x01\x20\x70\x7F");
$buf = "\x00\x01\x40\x60\x7E\x7F\x80\x81\xA0\xF0\xFF"; IQStream::IQ_normalize_zero_buf($buf, length($buf)-4, 0); is($buf, "\x7F\x7E\x3F\x1F\x01\x00\x00\x81\xA0\xF0\xFF");
$buf = "\x00\x01\x40\x60\x7E\x7F\x80\x81\xA0\xF0\xFF"; IQStream::IQ_normalize_zero_buf($buf, length($buf), 1); is($buf, "\x80\x81\xC0\xE0\xFE\xFF\x00\x01\x20\x70\x7F");

$buf = "\xB0\xC0\xFF\xFF\x4F\x3F"; IQStream::Convert_IQ_to_amplitude_buf($buf, length($buf), 0); is($buf, "\x50\x00\xB3\x00\x50\x00");
$buf = "\xB0\xC0\xFF\xFF\x4F\x3F"; IQStream::Convert_IQ_to_amplitude_buf($buf, length($buf), 1); is($buf, "\xA0\x00\x67\x01\xA0\x00");
$buf = "\xB0\xC0\xFF\xFF\x4F\x3F"; IQStream::Convert_IQ_to_amplitude_buf($buf, length($buf), 2); is($buf, "\x40\x01\xCE\x02\x40\x01");
$buf = "\xB0\xC0\xFF\xFF\x4F\x3F"; IQStream::Convert_IQ_to_amplitude_buf($buf, length($buf), 4); is($buf, "\x00\x05\x39\x0B\x00\x05");
$buf = "\xB0\xC0\xFF\xFF\x4F\x3F"; IQStream::Convert_IQ_to_amplitude_buf($buf, length($buf), 8); is($buf, "\x00\x50\x9A\xB3\x00\x50");




