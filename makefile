%.elc	: %.el
	  emacs --batch --eval '(byte-compile-file "$<")'

go	: $(addsuffix .elc, init common gnus-init rmail-init general)

init.elc	: common.elc
rmail-init.elc	: common.elc
gnus-init.elc	: common.elc
