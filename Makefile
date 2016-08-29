WORDS=words.txt

.PHONY: all ascii

all: ascii

ascii:
	@ ./scrabble.pl < ${WORDS}
