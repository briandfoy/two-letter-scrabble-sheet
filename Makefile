WORDS=words.txt
ASCII=grid-ascii.txt
PDF=grid.pdf

.PHONY: all pdf

all: grid-ascii.txt two-letter-word-scores.txt

grid-ascii.txt: scrabble-ascii.pl words.txt
	@ ./scrabble-ascii.pl < ${WORDS} > $@

pdf: scrabble-pdf.pl words.txt
	@ rm ${PDF}
	@ ./scrabble-pdf.pl < ${WORDS} > ${PDF}
	@ open ${PDF}

two-letter-word-scores.txt: two-letter-word-scores.pl words.txt tile_points.txt
	@ ./two-letter-word-scores.pl
