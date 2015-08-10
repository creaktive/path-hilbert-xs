package Path::Hilbert::XS;
use strict;
use warnings;
use XSLoader;
use parent 'Exporter';

our $VERSION = '0.001';
our @EXPORT  = qw<d2xy xy2d>;

XSLoader::load( 'Path::Hilbert::XS', $VERSION );

1;

__END__

=encoding utf8

=head1 NAME

Path::Hilbert::XS - XS implementation of a Hilbert Path algorithm

=head1 SYNOPSIS

    use Path::Hilbert::XS;

    my ($x, $y) = d2xy(16, 127);
    my $d = xy2d(16, $x, $y);
    die unless $d == 127;

=head1 DESCRIPTION

This implements L<Path::Hilbert> in XS for speed and awesomesauceness.

The OO interface is not available (yet?).

=head1 CREDITS

=over 4

=item * Rafaël Garcia-Suarez - for asking for it.

=item * p5pclub

=back

=head1 AUTHORS

=over 4

=item * Sawyer X C<< xsawyerx AT cpan DOT org >>

=item * Gonzalo Diethelm C<< gonzus AT cpan DOT org >>

=back

