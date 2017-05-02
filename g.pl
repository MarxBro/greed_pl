#!/usr/bin/perl
######################################################################
# Greed protos
######################################################################

use strict;
use warnings;
use diagnostics;
use Data::Dumper;
use Term::Screen;

#$|++;

our @G    = ();
our $rows = 25;
our $cols = $rows * 3;

our $cx    = 0;    #int(rand($rows));
our $cy    = 0;    #int(rand($cols));
our $value = 0;

our $debug  = 0;
our $limite = 3;
our $l      = 0;
our $offset = 2;

our $scr = new Term::Screen;
our $GK  = "GAME OVER PAPU";

our $score = 0;

######################################################################
# M A I N
######################################################################
init_grid();

while(42){
    $value = $G[$cx][$cy] ;
    pr_grid();
    my $c = $scr->getch();
        $scr->at(0,0)->clreol();
    if ( $c eq 'ku' ) {
        move_U();
    }
    elsif ( $c eq 'kd' ) {
        move_D();
    }
    elsif ( $c eq 'kl' ) {
        move_L();
    }
    elsif ( $c eq 'kr' ) {
        move_R();
    }
    elsif ( $c eq 'q' ) {
        muere();
    }
    if ($c){
        $score += $value;
        
        print_( "V: $value\n")  if $debug;
        print_( "X: $cx\n")     if $debug;
        print_( "Y: $cy\n")     if $debug;
        
    }


}

######################################################################
# S U B S
######################################################################

sub init_grid{
    $scr->clrscr();
    $cx = int(rand($rows ));
    $cy = int(rand($cols ));
    for my $x (0.. $rows){
        for my $y (0.. $cols){
            $G[$x][$y]=1+(int(rand(8)));
            }
        }
}
sub pr_grid {
    $scr->at($offset,$offset);
    for my $x (0.. $rows){
        for my $y (0.. $cols){
            if ($x == $cx && $y == $cy){
                $scr->bold();
            } else {
                $scr->normal();
            }
            if ($G[$x][$y] == 0){
                $scr->puts(" ")->at($x+$offset,$y+$offset);
            } else {
                $scr->puts($G[$x][$y])->at($x+$offset,$y+$offset);
            }
            }
        $scr->puts("\n")->at($x+$offset,$cols);
    }
    $scr->at($rows+$offset*2,$offset)->bold()->puts($value)->normal();
    $scr->at($cx+$offset,$cy+$offset-1);
}

sub move_R {
    broadcast("NOPE") and return "block" if ($cy + $value> $cols);
    broadcast("NOPE") and return "block" if ($G[$cx][$cy + $value+1] == 0);
    my @t = @{$G[$cx]}[$cy .. $cy+$value]; 
    my $blanks = ~~ grep (/0/, @t);
    if ($blanks == 0){
        for my $nnn (0 .. $value){
            $G[$cx][$cy + $nnn] = 0;
        }
    } else {
        broadcast("NOPE");
        return "block";    
    }
    $cy+= $value +1;
}

sub move_L {
    broadcast("NOPE") and return "block" if ($cy - $value < 0);
    broadcast("NOPE") and return "block" if ($G[$cx][$cy - $value-1] == 0);
    my @t = @{$G[$cx]}[ $cy-$value .. $cy]; 
    my $blanks = ~~ grep (/0/, @t);
    if ($blanks == 0){
        for my $nn (0 .. $value){
            $G[$cx][$cy - $nn] = 0;
        }
    } else {
        broadcast("NOPE");
        return "block";    
    }
    $cy -= $value +1;
}

sub move_U {
    broadcast("NOPE") and return "block" if ($cx - $value -1< 0);
    broadcast("NOPE") and return "block" if ($G[$cx - $value -1][$cy] == 0);
    my $blanks = 0;
    for my $n (0 .. $value){
        $blanks++ if ($G[$cx - $n][$cy] == 0);
    }
    if ($blanks == 0){
        for my $nnnn (0 .. $value){
            $G[$cx - $nnnn][$cy] = 0;
        }
    } else {
        broadcast("NOPE");
        return "block";
    }
    $cx -= $value +1;
}

sub move_D {
    broadcast("NOPE") and return "block" if ($cx + $value +1> $rows);
    broadcast("NOPE") and return "block" if ($G[$cx + $value +1][$cy]== 0);
    my $blanks = 0;
    for my $na (0 .. $value){
        $blanks++ if ($G[$cx + $na][$cy] == 0);
    }
    if ($blanks == 0){
        for my $nb (0 .. $value){
            $G[$cx + $nb][$cy] = 0;
        }
    } else {
        broadcast("NOPE");
        return "block";
    }
    $cx += $value +1;
}


sub muere {
    $scr->at($rows+$offset*2,$offset)->reverse()->puts($GK)->normal();
    $scr->at($rows+$offset*3,$offset)->bold()->puts("SCORE: $score")->normal();
    $scr->at($rows+$offset*4,$offset)->puts("\n");
    $scr->clreos();
    exit;
}


sub print_ {
    $scr->puts(shift);
    }

sub broadcast {
    $scr->at(0,0)->bold()->puts(shift)->normal();
    }

