WORDS=words.txt
PDF=grid.pdf

.PHONY: all ascii

all: ascii

ascii:
	@ ./scrabble-ascii.pl < ${WORDS}

pdf:
	@ ./scrabble-pdf.pl < ${WORDS} > ${PDF}
	@ open ${PDF}
