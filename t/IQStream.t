use strict;
use warnings;

use Test::More tests => 5;
BEGIN { use_ok('IQStream') };

my $buf = "\x00\x01\x40\x60\x7E\x7F\x80\x81\xA0\xF0\xFF"; IQStream::IQ_normalize_zero_buf($buf, length($buf), 0); is($buf, "\x7F\x7E\x3F\x1F\x01\x00\x00\x01\x20\x70\x7F");
$buf = "\x00\x01\x40\x60\x7E\x7F\x80\x81\xA0\xF0\xFF"; IQStream::IQ_normalize_zero_buf($buf, length($buf)-4, 0); is($buf, "\x7F\x7E\x3F\x1F\x01\x00\x00\x81\xA0\xF0\xFF");
$buf = "\x00\x01\x40\x60\x7E\x7F\x80\x81\xA0\xF0\xFF"; IQStream::IQ_normalize_zero_buf($buf, length($buf), 1); is($buf, "\x80\x81\xC0\xE0\xFE\xFF\x00\x01\x20\x70\x7F");

$buf = "\xB0\xC0\xFF\xFF"; IQStream::Convert_IQ_to_amplitude_buf($buf, length($buf)); is($buf, "\x50\x00\xB3\x00");

