#!/usr/bin/perl
######################################################################
# Greed protos
######################################################################

#use strict;
#use warnings;
#use diagnostics;
use Data::Dumper;
use Term::Screen;

$|++;

our @G = ();
our $rows = 25;
our $cols = $rows * 3;

our $cx = 0;#int(rand($rows));
our $cy = 0;#int(rand($cols));
our $value = 0;

our $debug = 0;
our $limite = 3;
our $l = 0;
our $offset = 2;

our $scr = new Term::Screen;
our $GK = "GAME OVER PAPU";

######################################################################
# M A I N
######################################################################
#{
init_grid();

while(42){
    #$scr->at($cx+$offset,$cy+$offset-1);
    $value = $G[$cx][$cy] || muere();
    
    pr_grid();
    print_( "V: $value\n")  if $debug;
    print_( "X: $cx\n")     if $debug;
    print_( "Y: $cy\n")     if $debug;
    #my $status = move_R();
    my $status = move_U();
    if ($status eq "block"){
        $l++;
        muere()if ($limite == $l);
        next;    
    }
    sleep 1;
}

######################################################################
# S U B S
######################################################################

sub init_grid{
    $scr->clrscr();
    $scr->at(0,0);#clrscr();
    $cx = int(rand($rows ));
    $cy = int(rand($cols ));
    for my $x (0.. $rows){
        for my $y (0.. $cols){
            $G[$x][$y]=1+(int(rand(7)));
            }
        }
}
sub pr_grid {
    $scr->at(0,0);#clrscr();
    for my $x (0.. $rows){
        for my $y (0.. $cols){
            if ($x == $cx && $y == $cy){
                $scr->bold();
            } else {
                $scr->normal();
            }

            #$G[$x][$y]=1+(int(rand(7)));
            if ($G[$x][$y] == 0){
                #print " ";    
                $scr->puts(" ")->at($x+$offset,$y+$offset);
            } else {
                #print $G[$x][$y];
                $scr->puts($G[$x][$y])->at($x+$offset,$y+$offset);
            }
            }
        $scr->puts("\n")->at($x+$offset,$cols);
        #print "\n";
    }
    $scr->at($cx+$offset,$cy+$offset-1);
}

sub move_R {
    muere() if ($cy + $value >= $rows);
    my @t = @{$G[$cx]}[$cy .. $cy+$value]; 
    my $blanks = ~~ grep (/0/, @t);
    #print "$blanks\n";
    if ($blanks == 0){
        for my $n (0 .. ($value-1)){
            $G[$cx][$cy + $n] = 0;
        }
    } else {
        return "block";    
    }
    $cy += $value ;
}

sub move_L {
    muere() if ($cy - $value <= -1);
    my @t = @{$G[$cx]}[ $cy-$value .. $cy]; 
    my $blanks = ~~ grep (/0/, @t);
    #print "$blanks\n";
    if ($blanks == 0){
        for my $n (0 .. ($value-1)){
            $G[$cx][$cy - $n] = 0;
        }
    } else {
        return "block";    
    }
    $cy -= $value ;
}

sub move_U {
    muere() if ($cx - $value <= -1);
    my $blanks = 0;
    for my $n (0 .. ($value - 1)){
        $blanks++ if ($G[$cx - $value][$cy] == 0);
    }
    if ($blanks == 0){
        for my $n (0 .. ($value - 1)){
            $G[$cx - $n][$cy] = 0;
        }
    } else {
        return "block";
    }
    $cx -= $value;
}

sub move_D {
    muere() if ($cx + $value >= $cols);
    my $blanks = 0;
    for my $n (0 .. ($value - 1)){
        $blanks++ if ($G[$cx + $value][$cy] == 0);
    }
    if ($blanks == 0){
        for my $n (0 .. ($value - 1)){
            $G[$cx + $n][$cy] = 0;
        }
    } else {
        return "block";
    }
    $cx += $value;
}


sub muere {
    #my $w = 25 + 7; 
    $scr->at($rows+$offset,$offset)->reverse()->puts($GK)->normal();
    $scr->clreos();
    exit;
}


sub print_ {
    $scr->puts(shift);
    }



#}
