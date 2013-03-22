package IQStream;

use 5.010000;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use IQStream ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('IQStream', $VERSION);

# Preloaded methods go here.

sub new
{
	my $class = shift;
	my $self  = bless { '__stream__' => undef }, $class;
	$self->{'__stream__'} = make($self);
	$self;
}

sub IQ_normalize_zero_buf
{
	my ($self, $buf, $make_signed) = @_;
	printf("__>\t".('\x%02X' x length($$buf)) ."\n", unpack('C*', $$buf));
	$self->{'__stream__'}->IQ_normalize_zero_buf($$buf, length($$buf), $make_signed);
	printf("<__\t".('\x%02X' x length($$buf)) ."\n", unpack('C*', $$buf));
}

sub Convert_IQ_to_amplitude_buf
{
	my ($self, $buf, $scale_bits) = @_;
	printf("__>\t".('\x%02X' x length($$buf)) ."\n", unpack('C*', $$buf));
	$self->{'__stream__'}->Convert_IQ_to_amplitude_buf($$buf, length($$buf), $scale_bits);
	printf("<__\t".('\x%02X' x length($$buf)) ."\n", unpack('C*', $$buf));
}

1;

__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

IQStream - Perl extension for blah blah blah

=head1 SYNOPSIS

  use IQStream;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for IQStream, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Mike Zero, E<lt>m0@pisem.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Mike Zero

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.16.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
