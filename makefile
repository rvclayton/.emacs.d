%.elc	: %.el
	  emacs --batch --eval '(byte-compile-file "$<")'

go	: $(addsuffix .elc, init common gnus-init rmail-init)
