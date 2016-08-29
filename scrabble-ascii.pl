#!/Users/brian/bin/perls/perl5.24.0
use v5.24;
use utf8;
use open qw(:std :utf8);

my %hash;
my @letters = 'a' .. 'z';

while( <STDIN> ) {
	next if /\A\s*#/; # skip comments
	chomp;
	$_ = lc $_;
	if( m/\A([a-z])([a-z])\s*(.*)/ ) {
		my( $first, $second, $definition ) = ( $1, $2, $3 );
		$hash{$first}{$second} = $definition;
		}
	else {
		warn "The word <$_> doesn't appear to be a two letter word\n";
		}
	}

say ' │', join ' ', @letters;
say ' ├', '─' x ( 2 * @letters ), '┤';
foreach my $first ( @letters ) {
	print $first, '│';
	foreach my $second ( @letters ) {
		print exists $hash{$first}{$second} ? '* ' : '  ';
		}
	print "│\n";
	}
say ' ├', '─' x ( 2 * @letters ), '┤';
