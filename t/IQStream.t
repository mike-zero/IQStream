use strict;
use warnings;

use Test::More tests => 10;
BEGIN { use_ok('IQStream') };

my $strm = new IQStream();

my $buf = "\x00\x01\x40\x60\x7E\x7F\x80\x81\xA0\xF0\xFF"; $strm->IQ_normalize_zero_buf(\$buf, 0); is($buf, "\x7F\x7E\x3F\x1F\x01\x00\x00\x01\x20\x70\x7F");
$buf = "\x00\x01\x40\x60\x7E\x7F\x80\x81\xA0\xF0\xFF"; $strm->IQ_normalize_zero_buf(\$buf, 1); is($buf, "\x80\x81\xC0\xE0\xFE\xFF\x00\x01\x20\x70\x7F");

$buf = "\xB0\xC0\xFF\xFF\x4F\x3F"; $strm->Convert_IQ_to_amplitude_buf(\$buf, 0); is($buf, "\x51\x00\xB4\x00\x51\x00");
$buf = "\xB0\xC0\xFF\xFF\x4F\x3F"; $strm->Convert_IQ_to_amplitude_buf(\$buf, 1); is($buf, "\xA1\x00\x69\x01\xA1\x00");
$buf = "\xB0\xC0\xFF\xFF\x4F\x3F"; $strm->Convert_IQ_to_amplitude_buf(\$buf, 2); is($buf, "\x43\x01\xD1\x02\x43\x01");
$buf = "\xB0\xC0\xFF\xFF\x4F\x3F"; $strm->Convert_IQ_to_amplitude_buf(\$buf, 4); is($buf, "\x0B\x05\x45\x0B\x0B\x05");
$buf = "\xB0\xC0\xFF\xFF\x4F\x3F"; $strm->Convert_IQ_to_amplitude_buf(\$buf, 8); is($buf, "\xB3\x50\x50\xB4\xB3\x50");

my $strm1 = new IQStream({'scale_bits' => 8});
$strm1->fill_amplitude_cache();
$buf = "\x00\x00\xB0\xC0\xFE\xFE\xFF\xFF\x4F\x3F"; $strm1->Convert_IQ_to_amplitude_buf_cached(\$buf); is($buf, "\x50\xB4\xB3\x50\xE6\xB2\x50\xB4\xB3\x50");

my $strm2 = new IQStream({'scale_bits' => 4});
$strm2->fill_amplitude_cache();
$buf = "\x00\x00\xB0\xC0\xFE\xFE\xFF\xFF\x4F\x3F"; $strm2->Convert_IQ_to_amplitude_buf_cached(\$buf); is($buf, "\x45\x0B\x0B\x05\x2E\x0B\x45\x0B\x0B\x05");
