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
use Term::Screen;

#$|++;

my %opts = ();
#my $t_banana = strftime ("%d_%B_%Y_%H_%M_%S",localtime(time()));

getopts('dhsy:x:',\%opts);
my $debug = $opts{d} || 0;


my $sp = " ";
my $x_total = $opts{x} || 10;
my $y_total = $opts{y} || 2 * $x_total;
my @GRID = ();
my $offset = 5;

my $csr_x = 0;
my $csr_y = 0;


######################################################################
# MAIN
######################################################################

if ($opts{h}){
    ayuda() and exit;
}
my $scr = new Term::Screen || die;
$scr->clrscr();
init_grid();
    #$scr->at($csr_x,$csr_y)->bold();

while (1){
    my $inputin = $scr->getch();
    my $current_index = xy2index($csr_x,$csr_y);
    my $current_value = $GRID[$current_index] || die;
    
    
    if ($inputin eq 'ku'){
        print "arriba" if $debug;
    } 
    elsif ($inputin eq 'kl'){
        print "izq" if $debug;
        $csr_x -= $current_value;
        my @tempy = '-'x$current_value;
        my $borrados = scalar grep {m'-'} $GRID[$current_index - $current_value, $current_index];
        splice (@GRID,$current_index - ($current_value+$borrados),$current_index,@tempy);
    } 
    elsif ($inputin eq 'kr'){
        print "der" if $debug;
        $csr_x += $current_value;
        my @tempy = '-'x$current_value;
        my $borrados = scalar grep {m'-'} $GRID[$current_index, $current_index];
        splice (@GRID,$current_index,$current_value+$borrados,@tempy);
    } 
    elsif ($inputin eq 'kd'){
        print "abaj" if $debug;
    } 
    play();
}
exit;

######################################################################
# SUBS
######################################################################
sub ayuda {
    pod2usage(-verbose=>2);
}

sub play {
    #do_move();
    draw_grid();
}

#sub do_move{
    #my $index_cursor = xy2index();
    #}

sub init_grid {
    $csr_x = 1 + int(rand($x_total -1));
    $csr_y = 1 + int(rand($y_total -1));
    foreach my $n (0 .. $x_total){
        foreach my $m ( 0 .. $y_total){
            #print int(rand(7)) . $sp;
            my $index = $n + $m * $y_total;
            $GRID[$index] = 1 + int(rand(6));
        }
    }
    draw_grid();
}

sub draw_grid {
    foreach my $n (0 .. $x_total){
        foreach my $m ( 0 .. $y_total){
            my $index = xy2index($n,$m);
            if (($n == $csr_x) && ($m == $csr_y)){
                $scr->at($n, $m)->puts( $GRID[$index])->reverse();
            } else {
                $scr->at($n, $m)->puts( $GRID[$index])->normal();
            }
            #print $GRID[$index] . $sp;
            #$GRID[$index] = int(rand(7));
        }
        $scr->at($n,0)->puts("\n");
    }
}

sub xy2index {
    my $x = shift;
    my $y = shift;
    my $indexxx = $x+$y*$y_total;
    return $indexxx;
}
