WORDS=words.txt

.PHONY: all ascii

all: ascii

ascii:
	@ ./scrabble-ascii.pl < ${WORDS}
