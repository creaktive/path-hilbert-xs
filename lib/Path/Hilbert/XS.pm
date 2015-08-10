# ABSTRACT: XS implementation of a Hilbert Path algorithm
package Path::Hilbert::XS;
use strict;
use warnings;
use XSLoader;

our $VERSION = '0.001';

XSLoader::load( 'Path::Hilbert::XS', $VERSION );

1;
