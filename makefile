%.elc	: %.el
	  emacs --batch --eval \
	    '(progn (push "~/lib/emacs/lisp" load-path) (byte-compile-file "$<"))'

go	: $(addsuffix .elc, init common gnus-init rmail-init general)

init.elc	: common.elc general.elc
general.elc	: common.elc
rmail-init.elc	: common.elc
gnus-init.elc	: common.elc
