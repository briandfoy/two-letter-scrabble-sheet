#!/Users/brian/bin/perls/perl5.24.0
use v5.24;
use utf8;

use PDF::API2;
use POSIX qw(ceil);


my @letters = 'a' .. 'z';

my %rect;
@rect{ qw(x y width height)  } = ( 70, 50, 512, 612 );
@rect{ qw(y_offset x_offset) } = map { ceil( $_ )   } ( $rect{'height'} / @letters, $rect{'width'} / @letters );
@rect{ qw(y_tail x_tail)     } = map { $_/2 } @rect{ qw(y_offset x_offset) };

my $font_size     = 18;
my $line_color    = '#ccc';
my $letter_color  = '#00f';
my $circle_color  = 'red';
my $circle_radius = 5;
my $score_color   = 'white';

my %y_positions;
my %x_positions;
my %two_word_positions;

my $pdf  = PDF::API2->new;
my $page = $pdf->page;
$page->mediabox( 'Letter' );

LINES_AND_LABELS: {
	my $lines = $page->gfx;
	$lines->linewidth( 1 );
	$lines->strokecolor( $line_color );
	$lines->fillcolor( $line_color );

	my $text    = $page->text;
	$text->font( $pdf->corefont('Helvetica'), $font_size );
	$text->strokecolor( $letter_color );
	$text->fillcolor( $letter_color );

	HORIZONTAL: foreach my $x_count ( 0 .. $#letters ) {
		my $x = $rect{'x'} - $rect{'x_tail'};
		my $y = $rect{'y'} + $x_count * $rect{'y_offset'};
		my $letter = $letters[ $#letters - $x_count ];
		$y_positions{ $letter } = $y;

		$lines->move( $x, $y );
		$lines->line(
			$x + $rect{'x_tail'} + $rect{'width'},
			$y
			);
		$lines->fillstroke;

		$text->translate(
			$x - (1/2) * $font_size,
			$y - (1/4) * $font_size
			);
		$text->text_center( $letter );
		}

	VERTICAL: foreach my $y_count ( 0 .. $#letters ) {
		my $x = $rect{'x'} + $y_count * $rect{'x_offset'};
		my $y = $rect{'y'} - $rect{'y_tail'};
		my $letter = $letters[$y_count];
		$x_positions{ $letter } = $x;

		$lines->move( $x, $y );
		$lines->line(
			$x,
			$y + $rect{'y_tail'} + $rect{'height'},
			);
		$lines->fillstroke;

		$text->translate(
			$x,
			$y + $rect{'y_tail'} + $rect{'height'} + (1/4) * $font_size
			);
		$text->text_center( $letter );
		}
	}

INTERSECTIONS: {
	foreach my $first_letter ( keys %y_positions ) {
		foreach my $second_letter ( keys %x_positions ) {
			$two_word_positions{$first_letter}{$second_letter} =
				[ $x_positions{$second_letter}, $y_positions{$first_letter} ];
			}
		}
	}

my %words = do {
	open my $sfh, '<:utf8', 'two-letter-word-scores.txt';
	my %s =  map { /\A([a-z]{2})\s+(\d+)/ }  grep { ! /\A\s*#/ } map { chomp; s/\A\s+//; lc } <$sfh>
	};

CIRCLES: {
	my $circle = $page->gfx;
	$circle->strokecolor( $circle_color );
	$circle->fillcolor( $circle_color );

	foreach my $word ( sort keys %words ) {
		my( $first, $second ) = $word =~ m/\A\s*([a-z])([a-z])/;
		my( $x, $y ) = $two_word_positions{$first}{$second}->@*;
		$circle->circle( $x, $y, $circle_radius );
		$circle->fillstroke;
		}
	}

SCORES: {
	my $score = $page->text;
	$score->font( $pdf->corefont('Helvetica'), 9 );
	$score->strokecolor( $score_color );
	$score->fillcolor( $score_color );

	foreach my $word ( sort keys %words ) {
		my( $first, $second ) = $word =~ m/\A\s*([a-z])([a-z])/;
		my( $x, $y ) = $two_word_positions{$first}{$second}->@*;
		$score->translate( $x, $y - 3 );
		$score->text_center( $words{$word} );
		}
	}

print $pdf->stringify();
