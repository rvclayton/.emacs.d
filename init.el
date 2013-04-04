(load "~rclayton/.emacs.d/common")


; ange-ftp.  I'm thinking this is obsolete - 12 feb 13.
;
;  (set-variable 'ange-ftp-default-user "anonymous")
;  (set-variable 'ange-ftp-generate-anonymous-password "clayton@cc.gatech.edu")
;  (set-variable 'ange-ftp-binary-file-name-regexp ".*Z$")


; antlr

  (autoload 'antlr-mode "antlr-mode" "Major mode for antlr code." t)
  (add-to-list 'auto-mode-alist '("\\.g\\'" . antlr-mode))


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
      (setq inferior-lisp-program "clojure")))


; cmu shell.

   (autoload 'cmushell "cmushell" "Run an inferior shell process." t)


; dart

  (autoload 'dart-mode "dart-mode" "Major mode for dart code." t)
  (add-to-list 'auto-mode-alist '("\\.dart\\'" . dart-mode))

  (add-hook 'dart-mode-hook
    (lambda ()
      (local-set-key "\e\C-l" 'goto-line)
      (local-set-key "\M-c" 'compile)
      (set (make-local-variable 'compile-command)
        (concat "/home/dart/dart-sdk/bin/dart --enable-checked-mode " (file-name-nondirectory buffer-file-name)))))


; go

  (require 'go-mode-load nil 'noerror)


; haskell

  (add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
  (autoload 'haskell-mode "haskell-mode" "Go into haskell mode" t)

  (add-hook 'haskell-mode-hook
    (lambda() "Haskell mode hacks"
      (load "inf-haskell")
      (define-key haskell-mode-map "\C-c\C-l" 'inferior-haskell-load-file)
      (turn-on-font-lock)
      (turn-on-haskell-doc-mode)))


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


; identica

  (require 'identica nil 'noerror)


; java

  (add-hook 'java-mode-hook
    (lambda ()
       (c-set-offset (quote case-label) 2 nil)
       (c-set-offset (quote topmost-intro) -2 nil)
       (c-set-offset (quote defun-block-intro) 2 nil)
       (c-set-offset (quote statement-block-intro) 2 nil)
       (c-set-offset (quote substatement) 2 nil)
       (c-set-offset (quote class-close) 2 nil)
       (c-set-offset (quote defun-close) 2 nil)
       (c-set-offset (quote topmost-intro-cont) 0 nil)

       (load "java-mode-defs" nil t)
       (set-variable 'fill-column 79)
       (setq dabbrev-case-fold-search nil)
       (local-set-key "\M-c" 'compile)
       (local-set-key "\e\C-l" 'goto-line)

       (set (make-local-variable 'compile-command)
         (let ((filename (file-name-nondirectory buffer-file-name)))
	    (if (or (file-exists-p "makefile") (fpile-exists-p "Makefile"))
	      (concat "make " 
		      (file-name-sans-extension filename) ".class")
	      (concat "javac -Xlint " filename))))))

; javascript

  (add-hook 'js-mode-hook
    (lambda () (load "js-utils")))


; makefile

  (autoload 'makefile-mode "make-mode" "Edit makefiles" t)
 
  (add-to-list 'auto-mode-alist '("^[Mm]akefile$" . makefile-mode))
 
  (setq makefile-electric-keys t)

  (add-hook 'makefile-mode-hook
    (lambda ()
      (local-set-key "\M-c" 'compile)))


; msgs

  (add-to-list 'auto-mode-alist '("/var/log/messages" . auto-revert-tail-mode))


; multiple cursors

  (require 'multiple-cursors nil 'noerror)
  (global-set-key (kbd "C-c mca") 'mc/mark-all-like-this)
  (global-set-key (kbd "C-c mce") 'mc/edit-lines)
  (global-set-key (kbd "C-c mcn") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-c mcp") 'mc/mark-previous-like-this)


; no web.

  (autoload 'noweb-mode "noweb-mode" "Editing noweb files." t)
  (add-to-list 'auto-mode-alist '("\\.nw$" . noweb-mode))
 

; org-mode

  (require 'org-install nil 'noerror)
  (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
  (define-key global-map "\C-cl" 'org-store-link)
  (define-key global-map "\C-ca" 'org-agenda)
  (setq org-log-done t)


; outlines

  (add-to-list 'auto-mode-alist '("\\.ol$" . outline-mode))

  (defun insert-date ()

    "Insert the date and time into the current buffer at the current location."

    (interactive)
    (insert (format-time-string "%Y %h %d")))

  (add-hook 'outline-minor-mode-hook
    (lambda ()
      (setq outline-regexp "\\.+")
      (local-set-key "\M-\C-d" 'insert-date)))
    

; Python

  (add-hook 'python-mode-hook
    (lambda ()
      (define-key python-mode-map "\el" 'goto-line)
      (setq python-indent 2)
      (set-fill-column 79)))

  (autoload 'python "python-mode" "" t)
  (add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
  (add-to-list 'auto-mode-alist '("\\.pypic$" . python-mode))


; scheme

  (add-to-list 'auto-mode-alist '("\\.(scm(awk\\|pic)?)\\|rkt$" . scheme-mode))

  (add-hook 'scheme-mode-hook
    (lambda ()
      (show-paren-mode 1)
      (setq scheme-program-name "guile")
      (setq fill-column 79)
      (when t
	; (setq gds-scheme-directory "/usr/local/share/guile")
	; (require 'gds)
	(setq debug-on-error t)
	(local-set-key "\C-cc" 'gds-help-symbol)
	(local-set-key "\C-ca" 'gds-apropos)
	(global-set-key "\C-h" 'delete-backward-char))
      (setq debug-ignored-errors '())
      (local-set-key "\e\C-l" 'goto-line)))


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
      )
  )

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

   
; twitter

  (cond
    (nil ; ublog.el
      (require 'ublog))

    (nil ; twitter.el
      (autoload 'twitter-get-friends-timeline "twitter" nil t)
      (autoload 'twitter-status-edit "twitter" nil t)
      (global-set-key "\C-xt" 'twitter-get-friends-timeline)
      (add-hook 'twitter-status-edit-mode-hook 'longlines-mode)
      (add-hook 'twitter-timeline-view-mode-hook
        (lambda ()
	  (local-set-key "\C-c\C-u" 'twitter-get-friends-timeline))))

    (t ; twitel.el
      (autoload 'twitel-get-friends-timeline "twitel" nil t)
      (autoload 'twitel-status-edit "twitel" nil t)
      (global-set-key "\C-xt" 'twitel-get-friends-timeline)
      (add-hook 'twitel-status-edit-mode-hook 'longlines-mode)
      (add-hook 'twitter-timeline-view-mode-hook
        (lambda ()
	  (local-set-key "\C-c\C-u" 'twitter-get-friends-timeline)))))


; version control

    (setq vc-handled-backends '(RCS GIT))


; web jump

  (when (require 'webjump-plus nil t)

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

  (require 'w3m nil 'noerror)


; $Log: init.el,v $
; Revision 1.9  2006-12-20 02:37:28  rclayton
; Add haskell mode; file-expand to the rmail inbox.
;
; Revision 1.8  2006-10-28 16:25:00  rclayton
; Store semantic files in one directory.
;
; Revision 1.7  2006-05-27 00:19:43  rclayton
; Re-disable bars.
;
; Revision 1.6  2006-05-22 02:59:15  rclayton
; Drop asymptote; update jdee.
;
; Revision 1.5  2006-05-04 17:23:45  rclayton
; Added predictive completion autoload.
;
; Revision 1.4  2006-04-04 00:06:39  rclayton
; Add curry-mode load.
;
; Revision 1.3  2006-02-02 03:04:14  rclayton
; Added an outline-mode hook.
;
; Revision 1.2  2006-01-14 12:04:43  rclayton
; Configure mail addresses based on domain.
;
; Revision 1.1.1.1  2006-01-08 19:56:44  rclayton
; Created
;
; Revision 1.17  2005/10/25 19:59:55  rclayton
; Added gds and oberon initialization.
;
; Revision 1.16  2005/09/18 03:18:42  rclayton
; Add w3m.
;
; Revision 1.15  2005/09/08 01:13:21  rclayton
; 69-character line lengths in mail.
;
; Revision 1.14  2005/09/04 02:11:52  rclayton
; Added antlr mode.
;
; Revision 1.13  2005/09/01 02:25:56  rclayton
; Default to news.verizon.net as the nntp server.
;
; Revision 1.12  2005/08/31 17:29:10  rclayton
; Drop gopher.
;

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.

(let ((lf (expand-file-name "~/.emacs.d/elpa/package.el")))
  (when
    (file-readable-p lf)
    (load lf)
    (package-initialize)))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(canlock-password "ec29aa15f46d35b18a7e50e124673f00529cbd8f")
 '(initial-major-mode (quote text-mode)))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(w3m-anchor ((((class color) (background dark)) (:foreground "yellow")) (((class color) (background light)) (:foreground "yellow"))))
 '(w3m-arrived-anchor ((((class color) (background dark)) (:foreground "cyan")) (((class color) (background light)) (:foreground "cyan")))))

