#!/usr/bin/perl
#use strict;
use Data::Dumper;


my $rows = 10;
my $cols = 10;
my %G = ();
my $GRID = \%G;


# init the data
for my $x (0 .. $rows){
    my @row = ();
    for my $y (0..$cols){
        push (@row, 1+int(rand(7)));
    }
    my $rrow = \@row;
    $G{$x} = $rrow;
}

# print the grid
foreach my $x (0..$rows){
    foreach my $y (0..$cols){
        print $G{$x}->[$y];
    }
    print "\n";

}


