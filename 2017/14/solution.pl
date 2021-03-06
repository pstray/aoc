#! /usr/bin/perl

use strict;

@ARGV = qw(input) unless @ARGV;

my $input = do { local $/ = undef; <>; };
chomp $input;

sub knot_hash {
    my($input) = @_;
    my @input = unpack "c*", $input;
    my @sparse_hash = (0 .. 255);
    my $pos = 0;
    my $skip = 0;

    push @input, 17, 31, 73, 47, 23;

    for my $round (1 .. 64) {
	for my $length (@input) {
	    push @sparse_hash, splice @sparse_hash, 0, $pos;
	    splice @sparse_hash, 0, $length, reverse @sparse_hash[0 .. $length-1];
	    unshift @sparse_hash, splice @sparse_hash, -$pos;
	    $pos += $length + $skip;
	    $pos %= 256;
	    $skip++;
	}
    }

    my @dense_hash;
    for my $i (0 .. 255) {
	push @dense_hash, 0 unless $i % 16;
	$dense_hash[-1] ^= $sparse_hash[$i];
    }

    return unpack "B*", pack "c*", @dense_hash;
}

my @grid;
my $in_use = 0;
for my $n (0 .. 127) {
    push @grid, knot_hash("$input-$n");
    $in_use += $grid[-1] =~ y/1/#/;
}

printf "Solution 1: %d in use\n", $in_use;

sub mark_region {
    my($x,$y) = @_;

    return 0 unless substr($grid[$y],$x,1) eq '#';
    substr $grid[$y], $x, 1, 'X';

    mark_region($x+1,$y) if $x < 128;
    mark_region($x-1,$y) if $x > 0;
    mark_region($x,$y+1) if $y < 128;
    mark_region($x,$y-1) if $y > 0;

    return 1;
}

my $regions = 0;
for my $y (0 .. 127) {
    for my $x (0 .. 127) {
	$regions += mark_region($x,$y);
    }
}

printf "Solution 2: %d regions\n", $regions;
