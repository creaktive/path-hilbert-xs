# ABSTRACT: XS implementation of a Hilbert Path algorithm
package Path::Hilbert::XS;
use strict;
use warnings;
use XSLoader;
use parent 'Exporter';

our $VERSION = '0.001';
our @EXPORT  = qw<d2xy xy2d>;

XSLoader::load( 'Path::Hilbert::XS', $VERSION );

1;
