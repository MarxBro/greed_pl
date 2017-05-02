#!/usr/bin/perl
######################################################################
# Greed protos
######################################################################

#use strict;
#use warnings;
#use diagnostics;
use Data::Dumper;

$|++;

our @G = ();
our $rows = 15;
our $cols = $rows * 3;

our $cx = 0;#int(rand($rows));
our $cy = 0;#int(rand($cols));
our $value = 0;

our $limite = 3;
our $l = 0;

our $GK = "GAME OVER PAPU";

######################################################################
# M A I N
######################################################################
#{
init_grid();

while(42){
    $value = $G[$cx][$cy] || die $GK;
    #die $GK if ($cx + $value > $rows);
    #die $GK if ($cx - $value < -1);
    die $GK if ($cy + $value > $cols);
    die $GK if ($cy - $value < -1);
    
    
    pr_grid();
    print "V: $value\n";
    #print "X: $cx\n";
    #print "Y: $cy\n";
    #my $status = move_R();
    my $status = move_L();
    if ($status eq "block"){
        $l++;
        die if ($limite == $l);
        next;    
    }
    sleep 1;
}

######################################################################
# S U B S
######################################################################

sub init_grid{
    $cx = int(rand($rows ));
    $cy = int(rand($cols ));
    for my $x (0.. $rows){
        for my $y (0.. $cols){
            $G[$x][$y]=1+(int(rand(7)));
            }
        }
}
sub pr_grid {
    for my $x (0.. $rows){
        for my $y (0.. $cols){
            #$G[$x][$y]=1+(int(rand(7)));
            if ($G[$x][$y] == 0){
                print " ";    
            } else {
                print $G[$x][$y];
            }
            }
        print "\n";
        }
}

sub move_R {
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

#}
