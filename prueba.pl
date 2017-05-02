#!/usr/bin/perl
use Data::Dumper;


my @a = (1 ,2, 3, 4);
$a[1][0] = 7;
$a[1][1] = 7;
$a[1][2] = 9;

my @b = @{$a[1]}[0 .. 2] ;

print Dumper(@b);
print ~~grep (/7/,@b);
