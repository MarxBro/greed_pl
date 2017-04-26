#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;


my $rows = 10-1;
my $cols = 30-1;
my %G = ();
my $GRID = \%G;

my $cx = 0;
my $cy = 0;
my $value = 0;#$G{$cx}->[$cy];

######################################################################

init_g();

while(42){
    pr_g();
    move_R();
    $value = $G{$cx}->[$cy];
    print "V: $value\n";
    print "X: $cx\n";
    print "Y: $cy\n";
    #print "RSHIY: $G{1}->[11]\n";
    print "\n\n";
    #print Dumper(%G);
    #die 'WTF' if ($value == 0);
    sleep 1;
}

######################################################################
    
sub move_R {
    die "Game Over" if ( $cy + $value > $cols );
    my $blanks = scalar grep {/0/} ($G{$cx}->[$cy],$G{$cx}->[$cy + $value]);
    my $value_plus_blanks = $value + $blanks;
    print "BB: $blanks\n";
    print "VPB: $value_plus_blanks\n";
    die "Game Over" if ( $cy + $value_plus_blanks > $cols );
    for my $n ( 0 .. $value_plus_blanks ) {
        $G{$cx}->[ $cy + $n ] = 0;
    }
    $cy += $value_plus_blanks;
}


# print the grid
sub pr_g {
    foreach my $x (0..$rows){
        foreach my $y (0..$cols){
            if ($G{$x}->[$y] == 0){
                print " ";
            } else {
                print $G{$x}->[$y];
            }
        }
        print "\n";
    }
    #$value = $G{$cx}->[$cy];
}


sub init_g{
# init the data
    for my $x (0 .. $rows){
        my @row = ();
        for my $y (0..$cols){
            push (@row, 1+int(rand(7)));
        }
        my $rrow = \@row;
        $G{$x} = $rrow;
    }
    $cx = int(rand($rows));
    $cy = int(rand($cols));
    $value = $G{$cx}->[$cy];
    print "VINI: $value\n\n";
}
