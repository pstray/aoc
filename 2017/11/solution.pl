#! /usr/bin/perl

use strict;
use Data::Dumper;
$Data::Dumper::Sortkeys = $Data::Dumper::Ident = 1;

@ARGV = qw(input) unless @ARGV;

my $input = do { local $/ = undef; <>; };
chomp $input;

my @path = split ",", $input;

my $pos_x = 0;
my $pos_y = 0;

my $max_dist = 0;
my $dist;

for my $dir (@path) {
    if ($dir eq 'se') {
	$pos_x++;
	$pos_y--;
    }
    elsif ($dir eq 'ne') {
	$pos_x++;
	$pos_y++;
    }
    elsif ($dir eq 'n') {
	$pos_y += 2;
    }
    elsif ($dir eq 'nw') {
	$pos_x--;
	$pos_y++;
    }
    elsif ($dir eq 's') {
	$pos_y -= 2;
    }
    elsif ($dir eq 'sw') {
	$pos_x--;
	$pos_y--;
    }
    else {
	die "unhandled dir [$dir]\n";
    }

    $dist = dist($pos_x,$pos_y);
    $max_dist = $dist if $dist > $max_dist;
    
}

sub dist {
    my($x,$y) = map { abs } @_;
    my $dist = $x;
    if ($y>$x) {
	$dist += ($y-$x)/2;
    }
    $dist;
}

printf "Solution 1: %d steps\n", $dist;
printf "Solution 2: %d steps max\n", $max_dist;
