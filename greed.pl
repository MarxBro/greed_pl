#!/usr/bin/perl
######################################################################
# Greed: programando ese jueguillo para hacer algo...
######################################################################

use strict;
#use warnings;
use Data::Dumper;
use Term::Screen;
use File::Slurp;
use POSIX q/strftime/;

my @G    = ();
my $rows = 25;
my $cols = $rows * 3;

my $cx    = 0;    
my $cy    = 0;    
my $value = 0;

my $debug  = 0;
my $limite = 3;
my $l      = 0;
my $offset = 2;

my $scr = new Term::Screen;
my $GK  = ' >>------------------------>    G A M E  O V E R !!';

#Lidiando con los puntajes
my $score = 0;
my $step_score = 0;
my $score_file = '.greed.scores';
my $saved_scores = 10;
my $score_worth_saving = 700;
my $movements = 0;

# Esto es para llevar rastro de los movimientos bloqueados y
# terminar el juego cuando no hay mas movimientos posibles.
our %BLOCKED = ( 
    'ku' => 0 ,
    'kd' => 0 ,
    'kl' => 0 ,
    'kr' => 0 ,
);

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
        my $st = move_U();
        if ($st eq 'block'){ esta_bloqueado($c) and next } else { $BLOCKED{$c} = 0; $movements++; };
    }
    elsif ( $c eq 'kd' ) {
        my $st = move_D();
        if ($st eq 'block'){ esta_bloqueado($c) and next } else { $BLOCKED{$c} = 0 ; $movements++;};
    }
    elsif ( $c eq 'kl' ) {
        my $st = move_L();
        if ($st eq 'block'){ esta_bloqueado($c) and next } else { $BLOCKED{$c} = 0 ; $movements++;};
    }
    elsif ( $c eq 'kr' ) {
        my $st = move_R();
        if ($st eq 'block'){ esta_bloqueado($c) and next } else { $BLOCKED{$c} = 0 ; $movements++;};
    }
    elsif ( $c eq 'q' ) {
        muere();
    }
    if ($c){
        $score += $step_score;
        print_( "X: $cx\n")     if $debug;
        print_( "Y: $cy\n")     if $debug;
    }
    #warn "$cx menor a $offset" if ( $cx < $offset and $debug);
    #warn "$cy menor a $offset" if ( $cy < $offset and $debug);
}

######################################################################
# S U B S
######################################################################

# Iniciar la grilla del greed!
sub init_grid {
    $scr->clrscr();
    $cx = int( rand($rows) );
    $cy = int( rand($cols) );
    for my $x ( 0 .. $rows ) {
        for my $y ( 0 .. $cols ) {
            $G[$x][$y] = 1 + ( int( rand(8) ) );
        }
    }
}

# Imprimir la grilla en su estado actual.
sub pr_grid {
    $scr->at( $offset, $offset );
    for my $x ( 0 .. $rows ) {
        for my $y ( 0 .. $cols ) {
            if ( $x == $cx && $y == $cy ) {
                $scr->reverse();
            } else {
                $scr->normal();
            }
            if ( $G[$x][$y] == 0 ) {
                $scr->puts(" ")->at( $x + $offset, $y + $offset );
            } else {
                $scr->puts( $G[$x][$y] )->at( $x + $offset, $y + $offset );
            }
        }
        $scr->puts("\n")->at( $x + $offset, $cols );
    }
    my $avg_tmp = '-';
    $avg_tmp = int($score / $movements) if ($movements);
    $scr->at( $rows + $offset * 2, $offset      )->bold()->puts("V: $value")->normal();
    $scr->at( $rows + $offset * 2, $offset * 4  )->bold()->puts("SCO: $score")->normal();
    $scr->at( $rows + $offset * 2, $offset * 10  )->bold()->puts("MV: $movements")->normal();
    $scr->at( $rows + $offset * 2, $offset * 15 )->bold()->puts("AVG: $avg_tmp")->normal();
    $scr->at( $offset + $cx,       $offset + $cy - 1 );
}

# Moverse a la DERECHA (que tan de moda esta...)
sub move_R {
    $step_score = 0;
    broadcast("BLOCK") and return "block" if ($cy + $value + 1> $cols);
    broadcast("BLOCK") and return "block" if ( $G[$cx][$cy + $value+1] == 0 );
    my $blanks = 0;
    for my $nr (0 .. $value){
        $blanks++ if ($G[$cx][$cy + $nr] == 0);
    }
    if ($blanks == 0){
        for my $nnn (0 .. $value){
            $step_score += $G[$cx][$cy + $nnn]; 
            $G[$cx][$cy + $nnn] = 0;
        }
    } else {
        broadcast("BLOCK");
        return "block";    
    }
    $cy+= $value +1;
}

# Moverse a la IZQUIERDA
sub move_L {
    $step_score = 0;
    broadcast("BLOCK") and return "block" if ($cy - $value - 1 < 0);
    broadcast("BLOCK") and return "block" if ($G[$cx][$cy - $value-1] == 0);
    my $blanks = 0;
    for my $nl (0 .. $value){
        $blanks++ if ($G[$cx][$cy - $nl] == 0);
    }
    if ($blanks == 0){
        for my $nn (0 .. $value){
            $step_score += $G[$cx][$cy - $nn]; 
            $G[$cx][$cy - $nn] = 0;
        }
    } else {
        broadcast("BLOCK");
        return "block";    
    }
    $cy -= $value +1;
}

# Pa'rriba
sub move_U {
    $step_score = 0;
    broadcast("BLOCK") and return "block" if ($cx - $value -1< 0);
    broadcast("BLOCK") and return "block" if ($G[$cx - $value -1][$cy] == 0);
    my $blanks = 0;
    for my $nu (0 .. $value){
        $blanks++ if ($G[$cx - $nu][$cy] == 0);
    }
    if ($blanks == 0){
        for my $nnnn (0 .. $value){
            $step_score += $G[$cx - $nnnn][$cy]; 
            $G[$cx - $nnnn][$cy] = 0;
        }
    } else {
        broadcast("BLOCK");
        return "block";
    }
    $cx -= $value +1;
}

# Pa'joba
sub move_D {
    $step_score = 0;
    broadcast("BLOCK") and return "block" if ($cx + $value +1> $rows);
    broadcast("BLOCK") and return "block" if ($G[$cx + $value +1][$cy] == 0);
    my $blanks = 0;
    for my $na (0 .. $value){
        $blanks++ if ($G[$cx + $na][$cy] == 0);
    }
    if ($blanks == 0){
        for my $nb (0 .. $value){
            $step_score += $G[$cx + $nb][$cy];
            $G[$cx + $nb][$cy] = 0;
        }
    } else {
        broadcast("BLOCK");
        return "block";
    }
    $cx += $value +1;
}

# Cuando muere el juego, hacemos estas ultimas cosas.
sub muere {
    $scr->at( $rows + $offset * 2,      $offset )       ->bold()->puts($GK)->normal();
    $scr->at( $rows + $offset * 3,      $offset * 2)    ->bold()->puts("SCORE: $score")->normal();
    $scr->at( $rows + $offset * 3,      $offset * 2+15) ->bold()->puts("MOVEMENTS: $movements")->normal();
    $scr->at( $rows + $offset * 4,      $offset )       ->bold()->puts("HIGHSCORES")->normal();
    $scr->at( $rows + $offset * 4 + 1,  $offset )       ->bold()->puts("---------")->normal();
    my @poner_scores = highscores();
    for my $i (0 .. $#poner_scores){
        last if ($i >= $saved_scores - 1);
        my @ln_score = split ('@', $poner_scores[$i]);
        $scr->at( $rows + $offset * 4 + 2 + $i, $offset )       ->bold()    ->puts("$ln_score[0]")->normal();
        $scr->at( $rows + $offset * 4 + 2 + $i, $offset + 7 )   ->bold()    ->puts("$ln_score[1] mv")->normal();
        $scr->at( $rows + $offset * 4 + 2 + $i, $offset + 8*2)  ->bold()    ->puts(int($ln_score[0] / $ln_score[1]) . " avg")->normal();
        $scr->at( $rows + $offset * 4 + 2 + $i, $offset + 8*3)              ->puts("$ln_score[2]");
    }
    $scr->at( $rows + $offset * 4 + 7, 0 )->puts("\n");
    $scr->clreos();
    exit;
}

# Cuando algun movimiento esta bloqueado, lo guardamos en el hash.
# Cuando las cuatro direcciones estan bloqueadas, terminamos el juego.
sub esta_bloqueado {
    my $inputo = shift;
    $BLOCKED{$inputo} = 1;
    broadcast(
        "$inputo $BLOCKED{'ku'} $BLOCKED{'kd'} $BLOCKED{'kl'} $BLOCKED{'kr'}")
      if $debug;
    if (   $BLOCKED{'ku'} == 1
        && $BLOCKED{'kd'} == 1
        && $BLOCKED{'kl'} == 1
        && $BLOCKED{'kr'} == 1 )
    {
        muere();
    }
}

# Pa'debuguear
sub print_ {
    $scr->puts(shift);
}

# Tambien pa'debuggear y para bloquear movimientos.
sub broadcast {
    $scr->at( 0, 0 )->bold()->puts(shift)->normal();
}

# Pa guardar scores
sub highscores {
    my $t_banana = strftime( "%H:%M:%S -- %d/%B/%Y", localtime( time() ) );
    my $score_ln = $score . '@' . $movements . '@' .$t_banana . "\n";
    `touch $score_file` unless ( -e $score_file );
    write_file( $score_file, { append => 1 }, $score_ln ) if ($score > $score_worth_saving);
    my @lines       = read_file($score_file);
    my @sorted_lns  = reverse( sort { $a <=> $b } @lines );
    return @sorted_lns;
}

__DATA__

print("\e[3A\e[K\e[?25l");   # Hide cursor
print("\e[2K\e[?25h\n");     # Restore cursor
