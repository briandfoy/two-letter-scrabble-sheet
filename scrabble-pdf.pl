#!/Users/brian/bin/perls/perl5.24.0
use v5.24;
use utf8;

use PDF::API2;

use constant mm => 25.4 / 72;
use constant in => 1 / 72;
use constant pt => 1;

my $pdf  = PDF::API2->new;
my $page = $pdf->page;

$page->mediabox( 'Letter' );


my %rect;
@rect{ qw(x y width height) } = ( 50, 50, 512, 612 );

{
my $blue_box = $page->gfx;
$blue_box->move(400, 400);
$blue_box->linewidth( 2 );
$blue_box->strokecolor('darkblue');
$blue_box->fillcolor('darkblue');
$blue_box->rect( @rect{ qw(x y width height) } );
$blue_box->stroke;
}


{
my $x_offset  = 20;
my $y_offset  = 25;

my $x_start = $rect{'x'};
my $y_start = $rect{'y'} + $rect{'height'};
my $count   = 0;

my $font_size = 17;
my $x_offset_factor = 1.17;
my $x_offset  = $font_size * $x_offset_factor;

my $y_offset_factor = 1.35;
my $y_offset  = $font_size * $y_offset_factor;

my $text = $page->text;
$text->font( $pdf->corefont('Helvetica'), $font_size );

foreach my $letter ( 'a' .. 'z' ) {
	$text->translate(
		$rect{'x'} + $count * $x_offset,
		$rect{'y'} + $rect{height} + 10 );
	$text->text( $letter );
	$count++;
	}

$count = 1;

foreach my $letter ( 'a' .. 'z' ) {
	$text->translate( $x_start - $x_offset, $y_start - $count * $y_offset );
	$text->text( $letter );
	$count++;
	}

}

print $pdf->stringify();
exit;

__END__

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


{
my $content = $page->gfx;
$content->move(150, 100);
$content->linewidth( 4 );
$content->hline( 100/mm );
$content->strokecolor( 'red' );
$content->fillcolor( 'red' );
$content->stroke;
}


{
my $content = $page->gfx;
$content->move(150, 100);
$content->linewidth( 4 );
$content->line( 200/mm, 200/mm );
$content->linedash(800/mm);
$content->fillstroke;
}

{
my $content = $page->gfx;
$content->move(250, 200);
$content->linewidth( 4 );
$content->hline( 100 );
$content->fillstroke;
}

{
my $content = $page->gfx;
$content->move(350, 300);
$content->linewidth( 4 );
$content->vline( 100 );
$content->fillstroke;
}





# you'll have to save it yourself, but this way you can pipe it
# to something else
