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
	my $param = shift;
	$param = {} unless ref($param) eq 'HASH';
	my $scale_bits = $param->{'scale_bits'} || 8;
	my $self  = bless { '__stream__' => undef }, $class;
	$self->{'__stream__'} = make($self, $scale_bits);
	$self;
}

sub IQ_normalize_zero_buf
{
	my ($self, $buf, $make_signed) = @_;
	$make_signed = 0 unless defined $make_signed;
	$self->{'__stream__'}->IQ_normalize_zero_buf($$buf, length($$buf), $make_signed);
}

sub Convert_IQ_to_amplitude_buf
{
	my ($self, $buf, $scale_bits) = @_;
	$self->{'__stream__'}->Convert_IQ_to_amplitude_buf($$buf, length($$buf) & ~1, $scale_bits);
}

sub Convert_IQ_to_amplitude_buf_cached
{
	my ($self, $buf) = @_;
	$self->{'__stream__'}->Convert_IQ_to_amplitude_buf_cached($$buf, length($$buf) & ~1);
}

sub fill_amplitude_cache
{
	my ($self) = @_;
	$self->{'__stream__'}->fill_amplitude_cache();
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
