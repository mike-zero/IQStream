#!/opt/perl5/bin/perl

use ExtUtils::testlib;

use lib '../blib/lib', '../blib/arch';
use IQStream;

my $buf0 = "\x00\x01\x40\x60\x7E\x7F\x80\x81\xA0\xF0\xFF";
#my $buf0 = "\xB0\xC0\xFF\xFF\x4F\x3F";

my $strm = new IQStream();

#my $buf = $buf0;
#printf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));
#$strm->IQ_normalize_zero_buf(\$buf);
#printf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));

my $strm1 = new IQStream({'scale_bits' => 8});
$strm1->fill_amplitude_cache();
$buf = "\xB0\xC0\xFF\xFF\x4F\x3F"; 
warn sprintf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));
$strm1->Convert_IQ_to_amplitude_buf_cached(\$buf);
warn sprintf(('\x%02X' x length($buf)) ."\n", unpack('C*', $buf));


