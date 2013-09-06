#!/usr/bin/perl -w

use strict;

use ExtUtils::testlib;

use lib '../blib/lib', '../blib/arch';
use IQStream;


my $filename = shift || '-';

my $bufsize = 2 * 16384;
my $buf = 0 x $bufsize;

my $strm1 = new IQStream({'scale_bits' => 8});
$strm1->fill_amplitude_cache();

warn "Start: ".(scalar localtime(time));

open F, $filename;
binmode(F);
while (sysread(F, $buf, $bufsize)) {
	$strm1->Convert_IQ_to_amplitude_buf_cached(\$buf);
print "---------------------------------\n";
	$strm1->level_detect(\$buf, 10000);
#last;
print "=================================\n";
}
close F;


warn "Stop:  ".(scalar localtime(time));
