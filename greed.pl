#!/usr/bin/perl
######################################################################
# Greed clone by perl
######################################################################

use strict;
#use warnings;
use POSIX q/strftime/;
use Getopt::Std;
use Pod::Usage;
use autodie;
use Data::Dumper;
#use Term::Screen;

#$|++;

my %opts = ();
#my $t_banana = strftime ("%d_%B_%Y_%H_%M_%S",localtime(time()));

getopts('hsy:x:',\%opts);

my $sp = " ";
my $x_total = $opts{x} || 10;
my $y_total = $opts{y} || 2 * $x_total;
my @GRID = ();
my $offset = 5;

######################################################################
# MAIN
######################################################################

if ($opts{h}){
    ayuda() and exit;
}
init_grid();
play();
exit;

######################################################################
# SUBS
######################################################################
sub ayuda {
    pod2usage(-verbose=>2);
}

sub play {
    do_move();
    draw_grid();
}

sub do_move{
    my $index_cursor = xy2index();
    }

sub init_grid {
    foreach my $n (0 .. $x_total){
        foreach my $m ( 0 .. $y_total){
            #print int(rand(7)) . $sp;
            my $index = $n + $m * $y_total;
            $GRID[$index] = int(rand(7));
        }
    }
}

sub draw_grid {
    foreach my $n (0 .. $x_total){
        foreach my $m ( 0 .. $y_total){
            my $index = $n + $m * $y_total;
            print $GRID[$index] . $sp;
            #$GRID[$index] = int(rand(7));
        }
        print "\n";
    }
}
