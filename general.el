; antlr

  (autoload 'antlr-mode "antlr-mode" "Major mode for antlr code." t)
  (add-to-list 'auto-mode-alist '("\\.[ga]4" . antlr-mode))
  (add-hook 'antlr-mode-hook
    (lambda ()
      (load "antlr-mode-defs" nil t)))

; c

  (add-hook 'c-mode-hook
     (lambda ()
       ; (font-lock-mode nil)
       ; (setq font-lock-maximum-size 1)
       (load "c-mode-defs" nil t)
       (load "include" nil t)))


; C++

  (add-hook 'c++-mode-hook
    (lambda ()
      (run-hooks 'c-mode-hook)))

  (add-to-list 'auto-mode-alist '("\\.c[cdh]$" . c++-mode))


; calender

   (setq view-diary-entries-initially t)
   (setq mark-diary-entries-in-calendar t)
   (setq number-of-diary-entries 2)
   (setq diary-file "~/.diary")


; clojure

  (autoload 'clojure-mode "clojure-mode" "Major mode for clojure." t)
  (add-to-list 'auto-mode-alist '("\\.clj$" . clojure-mode))
  (add-hook 'clojure-mode-hook
    (lambda ()
      (go-paredit)
      (setq inferior-lisp-program "clojure")))


; cmu shell.

  (autoload 'cmushell "cmushell" "Run an inferior shell process." t)


; compile on save mode

  (defun compile-on-save-start ()
    (let ((buffer (compilation-find-buffer)))
      (unless (get-buffer-process buffer) 
	(recompile))))

  (define-minor-mode compile-on-save-mode

    "Minor mode to automatically call `recompile' whenever the
  current buffer is saved. When there is ongoing compilation,
  nothing happens."

    :lighter " CoS"

    (if compile-on-save-mode
      (progn  (make-local-variable 'after-save-hook)
	      (add-hook 'after-save-hook 'compile-on-save-start nil t))
      (kill-local-variable 'after-save-hook)))


; coq

  (when (executable-find "coqc")
    (load "~/.emacs.d/elpa/proof-general-4.4/generic/proof-site"))


; dart

  (autoload 'dart-mode "dart-mode" "Major mode for dart code." t)
  (add-to-list 'auto-mode-alist '("\\.dart\\'" . dart-mode))

  (add-hook 'dart-mode-hook
    (lambda ()
      (local-set-key "\e\C-l" 'goto-line)
      (local-set-key "\M-c" 'compile)
      (set (make-local-variable 'compile-command)
        (concat "dartanalyzer --machine " (file-name-nondirectory buffer-file-name)))))


; elisp

  (add-hook 'emacs-lisp-mode-hook
    (lambda () 
      (eldoc-mode)
      (go-paredit)))


; go

  (require 'go-mode-load nil 'noerror)


; haskell

  (add-to-list 'auto-mode-alist '("\\.l?hs$" . haskell-mode))
  (autoload 'haskell-mode "haskell-mode" "Go into haskell mode" t)

  (add-hook 'haskell-mode-hook
    (lambda() "Haskell mode hacks"
      (load "inf-haskell")
      (load-library "haskell-toys")
      (define-key haskell-mode-map "\C-c\C-l" 'inferior-haskell-load-file)
      (define-key haskell-mode-map "\C-c\C-g" 'goto-line)
      (turn-on-font-lock)
      (turn-on-haskell-doc-mode)
      (turn-on-haskell-simple-indent)
      (local-set-key "\M-c" 'compile)
      (set (make-local-variable 'compile-command)
	   (concat "ghc " (file-name-nondirectory buffer-file-name) 
		   " && hlint " (file-name-nondirectory buffer-file-name)))))

; html

  (add-hook 'html-mode-hook
    (lambda ()
      (load "html-mode-defs" nil t)
      (flyspell-mode do-flyspell-mode)))


; icon

  (autoload 'icon-mode "icon" nil t)

  (add-to-list 'auto-mode-alist '("\\.iol$" . icon-mode))
  (add-to-list 'auto-mode-alist '("\\.icn$" . icon-mode))

  (add-hook 'icon-mode-hook
    (lambda ()
      (load "icon-mode-defs" nil t)))


; java

  (add-hook 'java-mode-hook
    (lambda ()
       (c-set-offset (quote case-label) 2 nil)
       (c-set-offset (quote topmost-intro) -2 nil)
       (c-set-offset (quote defun-block-intro) 2 nil)
       (c-set-offset (quote statement-block-intro) 2 nil)
       (c-set-offset (quote substatement) 2 nil)
       (c-set-offset (quote class-close) 2 nil)
       (c-set-offset (quote defun-close) 4 nil)
       (c-set-offset (quote topmost-intro-cont) 0 nil)
       (c-set-offset 'arglist-intro 2 nil)
       (c-set-offset 'func-decl-cont 0 nil)
       (c-set-offset 'statement-case-intro 2 nil)

       (electric-pair-local-mode)
       
       (load "java-mode-defs" nil t)
       (set-variable 'fill-column 79)
       (setq dabbrev-case-fold-search nil)
       (local-set-key "\M-c" 'compile)
       (local-set-key "\e\C-l" 'goto-line)

       (set (make-local-variable 'compile-command)
         (let ((filename (file-name-nondirectory buffer-file-name)))
	    (if (or (file-exists-p "makefile") (file-exists-p "Makefile"))
	      (concat "make " 
		      (file-name-sans-extension filename) ".class")
	      (concat "javac -Xlint " filename))))

       (setq compilation-exit-message-function
         (lambda (status code msg)
	   (when (and (eq status 'exit) (zerop code))
	     (bury-buffer)
	     (delete-window (get-buffer-window (get-buffer "*compilation*"))))
	   (cons msg code)))))


; javascript & typescript

  (add-to-list 'auto-mode-alist '("\\.[tj]s$" . javascript-mode))

  (add-hook 'js-mode-hook
    (lambda ()
      (load "js-utils")
      (when (string-match "\.ts$" buffer-file-name)
	(load "ts-utils")
	(local-set-key "\M-c" 'compile)
        (set (make-local-variable 'compile-command)
          (let ((filename (file-name-nondirectory buffer-file-name)))
	    (if (or (file-exists-p "makefile") (file-exists-p "Makefile"))
	      (concat "make " (file-name-sans-extension filename) ".js")
	      (concat "tsc " filename)))))))


; makefile

  (autoload 'makefile-mode "make-mode" "Edit makefiles" t)
 
  (add-to-list 'auto-mode-alist '("^[Mm]akefile$" . makefile-mode))
 
  (setq makefile-electric-keys t)

  (add-hook 'makefile-mode-hook
    (lambda ()
      (local-set-key "\M-c" 'compile)))


; msgs

  (add-to-list 'auto-mode-alist '("/var/log/messages" . auto-revert-tail-mode))


; no web.

  (autoload 'noweb-mode "noweb-mode" "Editing noweb files." t)
  (add-to-list 'auto-mode-alist '("\\.nw$" . noweb-mode))
 

; org-mode

  (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
  (add-hook 'org-mode-hook
    (lambda () 
      (require 'org-install nil 'noerror)
      (define-key global-map "\C-cl" 'org-store-link)
      (define-key global-map "\C-ca" 'org-agenda)
      (setq org-log-done t)))


; outlines

  (add-to-list 'auto-mode-alist '("\\.ol$" . outline-mode))
  (add-hook 'outline-mode-hook
    (lambda ()
      (setq outline-regexp "\\.+")
      (local-set-key "\C-cd" 
        (lambda ()
	  "insert today's date at point"
	  (interactive)
	  (insert (format-time-string "%Y %h %d"))))))
    

; packages

  (when (> emacs-major-version 23)
    ; Because pkgs.el calls use-package, it can't be compiled (or I don't know
    ; how to compile it).
    (load "~rclayton/.emacs.d/pkgs.el"))


; processing

  ; Don't forget to add the processing-mode package.

  (add-to-list 'auto-mode-alist '("\\.pde$" . processing-mode))

  (add-hook 'processing-mode-hook
    (lambda ()
      (setq processing-sketchbook-dir
        (find-first-file 
	   "./sketchbook"
	   "~/projects/sketchbook"
	   "/mnt/projects/processing/sketchbook"))
      (set-fill-column 79)
      (local-set-key "\M-c" 'processing-sketch-build)
      (local-set-key "\C-cpr" 'processing-sketch-run)
      (setq processing-location 
        (find-first-file 
	  ""
	  "/usr/local/packages/processing/processing-java"
	  "/mnt/projects/processing/processing/processing-java"))
      ; A cheap hack to get around newer emacsen dropping the user-error 
      ; function.
      (unless (fboundp 'user-error) (fset 'user-error 'error)))
      )

  
; pyret

  (ignore-errors
    (require 'pyret)
    (add-to-list 'auto-mode-alist '("\\.arr$" . pyret-mode))
    (add-to-list 'file-coding-system-alist '("\\.arr\\'" . utf-8)))


; Python

  (add-hook 'python-mode-hook
    (lambda ()
      (define-key python-mode-map "\el" 'goto-line)
      (setq python-indent 2)
      (set-fill-column 79)
      (require-or-print 'ipython)))

  (autoload 'python "python-mode" "" t)
  (add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
  (add-to-list 'auto-mode-alist '("\\.pypic$" . python-mode))


; scheme

  (add-to-list 'auto-mode-alist '("\\.(scm(awk\\|pic)?\\|rkt\\|skr)$" . scheme-mode))

  (add-hook 'scheme-mode-hook
    (lambda ()
      (setq fill-column 79)
      (local-set-key "\e\C-l" 'goto-line)
      (go-paredit)))


; skribilo (skribe)

  (autoload 'skribe-mode "skribe" "minor mode for skribilo code." t)
  (add-to-list 'auto-mode-alist '("\\.skr$" . skribe-mode))


; tcl

  (add-to-list 'auto-mode-alist '("\\.tk$" . tcl-mode))

  (add-hook 'tcl-mode-hook
    (lambda ()
      (load "tcl-mode-defs" nil t)
      (local-set-key "\M-p" 'insert-tcl-procedure-skeleton)
      (local-set-key "\C-c\M-p" 'tcl-process-start)
      (set-variable 'fill-column 79)
      (setq tcl-indent-level 2)))


; tex(t)

   (defun upcase-previous-word () 
     (interactive)
     (upcase-word -1))
   (global-set-key "\M-u" 'upcase-previous-word)

   (add-hook 'text-mode-hook
     (lambda ()
	(auto-fill-mode 1)
	(setq require-final-newline t)
	(setq fill-column 79)
	(local-unset-key "\M-s")
	(local-unset-key "\M-}")
	(local-unset-key "\M-{")
	(local-set-key "\C-h" 'delete-backward-char)
	(local-set-key "\M-g" 'fill-region-and-align)
	(load "par-align" t t)
	(flyspell-mode do-flyspell-mode)
	(when (boundp 'its-all-text!)
	  (auto-fill-mode -1)
	  (visual-line-mode))))

  (add-hook 'tex-mode-hook
    (lambda ()
       (load "tex-mode-defs" nil t)
       (local-set-key "\e\C-l" 'goto-line)
       (do-abbrevs)))

  (add-hook 'latex-mode-hook
    (lambda ()
      (load "latex-mode-defs" nil t)
      (local-set-key "\C-c\C-t" 'latex-tt-word)
      (local-set-key "\C-c\C-m" 'latex-math-word)
      (require 'btxlook)
      (btxlook-mode)
      (local-set-key "\e\C-b" 'btxlook-search)
      (setq btxlook-insert-single-match t)))

  (add-hook 'nroff-mode-hook
    (lambda ()
       (load "nroff-mode-defs" nil t)))

  (autoload 'bibtex-mode "bibtex" "Edit bibtex files" t)

  (add-to-list 'auto-mode-alist '("\\.bi?b$" . bibtex-mode))

  (add-hook' bibtex-mode-hook
    (lambda ()
       (define-key bibtex-mode-map "\e\C-l" 'goto-line)
       (flyspell-mode do-flyspell-mode)
       (load "gts.el" )))

   
; typescript

  ; see javascript


; version control

    (setq vc-handled-backends '(RCS GIT))


; web jump

  (when (require-or-print 'webjump-plus)

    (defvar browse-url-netscape-program "iceape")

    (global-set-key "\C-cj" 'webjump)
    (defvar webjump-sites `(

      ("webjump site prompt response" .
       [simple-query "url for no specified query phrase"
		     "url prefix for specified query phrase" 
		     "url suffix for specified query phrase"])

      ("os public" .
       [simple-query
	  "http://bluehawk.monmouth.edu/rclayton/web-pages/f04-438-505/505-syl.html"
	  "http://bluehawk.monmouth.edu/rclayton/web-pages/f04-438-505/" 
	  ".html"])

      ("os local" .
       [simple-query
	  "file:/export/home/uf/rclayton/public-html/f04-438-505/505-syl.html"
	  "file:/export/home/uf/rclayton/public-html/f04-438-505/" 
	  ".html"])

      ("C-C++ User's Journal" .
       [simple-query "www.cuj.com"
		     "www.cuj.com/articles/search/search.cgi?q=" ""])

      ("freshmeat" .
       [simple-query "freshmeat.net"
		     "freshmeat.net/search/?q="
		     "&section=projects"])

      ("google" .
       [simple-query "http://www.google.com"
		     "http://www.google.com/search?hl=en&ie=ISO-8859-1&q="
		     ""])

      ("Internet Drafts" .
       [simple-query
	"www.ietf.org/ID.html"
	,(concat "www.ietf.org/search/cgi-bin/BrokerQuery.pl.cgi"
		 "?broker=internet-drafts&query=")
	,(concat "&caseflag=on&wordflag=off&errorflag=0&maxlineflag=50"
		 "&maxresultflag=1000&descflag=on&sort=by-NML&verbose=on"
		 "&maxobjflag=25")])

      ("java api docs" . "http://java.sun.com/j2se/1.4.2/docs/api/index-files/index-1.html")

      )))


; w3m

  (require-or-print 'w3m)


; yaml

  (when (require-or-print 'yaml-mode)
    (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
    (add-hook 'yaml-mode-hook
     '(lambda ()
        (define-key yaml-mode-map "\C-m" 'newline-and-indent)))) 

