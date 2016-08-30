WORDS=words.txt
ASCII=grid.txt
PDF=grid.pdf

.PHONY: all pdf ascii

all: ascii pdf two-letter-word-scores.txt

ascii: grid.txt

grid.txt: scrabble-ascii.pl words.txt
	@ ./scrabble-ascii.pl < ${WORDS} > $@

pdf: grid.pdf

grid.pdf: two-letter-word-scores.txt
	@ rm -f $@
	@ ./scrabble-pdf-lines.pl > $@
	@ open $@

two-letter-word-scores.txt: two-letter-word-scores.pl words.txt tile_points.txt
	@ ./two-letter-word-scores.pl
