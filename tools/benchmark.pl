#!/usr/bin/perl
use strict;
use warnings;
use Dumbbench;
use Path::Hilbert ();
use Path::Hilbert::XS ();
use Benchmark::Dumb ':all';
use Text::Table;
use DDP;

sub show_statistics_table {
    my $bench = shift;
    my @instances = @{ $bench->{'instances'} };
    my @names     = map $_->name, @instances;
    my $table     = Text::Table->new( '', ' Time', map " $_", @names );

    foreach my $idx ( 0 .. $#instances ) {
        my $my_cb_name = $instances[$idx]{'name'};
        my $my_cb_num  = $instances[$idx]{'result'}{'num'};
        my @items      = ( $my_cb_name, sprintf ' %.3e', $my_cb_num );

        foreach my $cmp_idx ( 0 .. $#instances ) {
            my $cmp_cb_name = $instances[$cmp_idx]{'name'};
            my $cmp_cb_num  = $instances[$cmp_idx]{'result'}{'num'};

            push @items, $my_cb_name eq $cmp_cb_name
                       ? ' --'
                       : sprintf " %.2f%%\n",
                        (
                           $my_cb_num <= $cmp_cb_num
                           ? 100 - $my_cb_num / $cmp_cb_num * 100
                           : $cmp_cb_num / $my_cb_num * -100
                        );
        }

        $table->load([@items]);
    }

    print $table;
}

sub run_instances {
    my @instances = @_;
    my $bench     = Dumbbench->new(
        target_rel_precision => 0.005,
        initial_runs         => 20,
    );

    $bench->add_instances(@_);
    $bench->run;
    $bench->report;
    show_statistics_table($bench);
}

print "-- d2xy --\n";
run_instances(
    Dumbbench::Instance::PerlSub->new(
        name => 'PP',
        code => sub { Path::Hilbert::d2xy( 16, 127 ) for 1e8 },
    ),

    Dumbbench::Instance::PerlSub->new(
        name => 'XS',
        code => sub { Path::Hilbert::XS::d2xy( 16, 127 ) for 1e8 },
    ),
);

print "\n-- xy2d--\n";

run_instances(
    Dumbbench::Instance::PerlSub->new(
        name => 'PP',
        code => sub { Path::Hilbert::xy2d( 16, 7, 8 ) for 1e8 },
    ),

    Dumbbench::Instance::PerlSub->new(
        name => 'XS',
        code => sub { Path::Hilbert::XS::xy2d( 16, 7, 8 ) for 1e8 },
    ),
);
