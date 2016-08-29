#!/Users/brian/bin/perls/perl5.24.0

open my $fh, '<:utf8', 'words.txt'
	or die "Could not open words.txt! $!\n";
open my $points_fh, '<:utf8', 'tile_points.txt'
	or die "Could not open tile_points.txt! $!\n";

open my $score_fh, '>:utf8', 'two-letter-word-scores.txt'
	or die "Could not open two-letter-word-scores.txt! $!\n";

my %points;
while( <$points_fh> ) {
	my( $letter, $points ) = split;
	$points{lc $letter} = $points;
	}

my %words;
while( <$fh> ) {
	next if m/\A\s*#/;
	chomp;
	my( $first, $second ) =  map { lc } m/\A\s*([a-z])([a-z])/i;
	my $score = $points{$first} + $points{$second};
	say { $score_fh } $_, "\t", $score;
	}
