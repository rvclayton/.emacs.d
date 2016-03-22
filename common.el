; Common environent for any emacs invocation.

  ; naked emacs.

  (if (fboundp 'menu-bar-no-scroll-bar) (menu-bar-no-scroll-bar))
  (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
  (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

  (fset 'yes-or-no-p 'y-or-n-p)

  (put 'erase-buffer 'disabled nil)
  (put 'downcase-region 'disabled nil)
  (put 'upcase-region 'disabled nil)
  (setq initial-scratch-message nil)

  (defun filter-non-directories (lst)
    (let ((drs '()))
      (mapc 
	(lambda (o) 
	  (if (and (stringp o) (file-directory-p o) (not (member o drs)))
	      (add-to-list 'drs o)))
	lst)
      (reverse drs)))


   (defun find-first-file (default &rest files)

     ; Return the first file found in a left-to-right scan of the given file
     ; list.  If none of the files exists, return the given default value.

     (let (f)

       (fset 'f
         (lambda (files)
	   (if (null files)
	     default
	     (let ((file (car files)))
	       (if (file-exists-p file)
		 file
		 (f (cdr files)))))))

       (f files)))


   (setq local-site-path "/usr/local/share/emacs/site-lisp")

   (setq load-path 
     (filter-non-directories 
       (append '("~/lib/emacs/lisp"
		 "/usr/local/share/emacs/site-lisp/scala-mode"
		 "/usr/share/emacs/site-lisp/haskell-mode"
		 "/usr/share/emacs/site-lisp/eieio"
		 "/usr/share/emacs/site-lisp/cedet-common"
		 "/usr/share/emacs/site-lisp/cedet-contrib"
		 "/usr/share/emacs/site-lisp/elib"
		 ".") 
	       load-path)))
       
   (setq Info-default-directory-list
     (filter-non-directories 
       (append Info-default-directory-list 
         '("~/lib/emacs/info ~/local/info" "/usr/local/info"  
	   "/usr/local/share/info" "/export/opt/TeX/info"))))

   (setq-default initial-major-mode 'text-mode)
   (setq-default major-mode 'text-mode)
   (put 'eval-expression 'disabled nil)
   (setq inhibit-startup-message t)
   (setq suggest-key-bindings nil)
   (setq display-time-day-and-date 1)
   (display-time)
 
   (global-font-lock-mode -1)

   ; These disapeared in emacs 22.
   (global-set-key "\C-xx" 'copy-to-register)
   (global-set-key "\C-xg" 'insert-register)

   (global-set-key "\C-c\C-x" 'execute-extended-command)  
   ; (global-set-key [f1] 'font-lock-mode)
   (global-set-key [home] 'beginning-of-buffer)
   (global-set-key [end] 'end-of-buffer)

   (defun do-abbrevs ()
     (catch 'exit
       (mapc (lambda (f)
	       (when (file-exists-p f)
		 (setq abbrev-file-name f)
		 (setq abbrev-mode t)
		 (setq save-abbrevs t)
		 (read-abbrev-file f)
		 (local-set-key "\C-xaw" 'write-abbrev-file)
		 (throw 'exit nil)))
	     '("./abbrevs" "./.abbrevs" "~/.abbrevs"))))

  (defvar yow-file "~/lib/emacs/lisp/yow.lines")


; what kind of emacs is this?

  (require 'general-utils)
  (defconst emacs-major-version (genutl:emacs-major-version))


; parens matching

  (let ((w 'paredit))
    (cond 

      ((eq w 'paredit)
        (setq show-paren-delay 0)
        (show-paren-mode t)
        (setq show-paren-style 'mixed)) ; also 'parenthesis or 'expression

      ((eq w 'rainbow-delimiters)
       (when (require 'rainbow-delimiters nil 'noerror) 
	 (mapc (lambda (m) (add-hook m 'rainbow-delimiters-mode))
	      '(scheme-mode-hook java-mode-hook))))))


; uniqify buffer names

  (require 'uniquify)
  (setq
    uniquify-buffer-name-style 'reverse
    uniquify-separator ".")


; buffer printing things.

  (setq lpr-command "lpr")


; switch ^H and ^?.

  (cond
    (0
      (global-set-key "\C-h" 'delete-backward-char)
      (global-set-key "\M-h" 'help-command)
      ; (global-set-key "\d" 'help-command)
      (global-set-key "\M-\C-h" 'backward-kill-word)
      (normal-erase-is-backspace-mode 1))

    (0
      (let ((the-table (make-string 128 0)))
	(let ((i 0))
	  (while (< i 128)
	   (aset the-table i i)
	    (setq i (1+ i))))
	; Swap ^H and DEL
	(aset the-table ?\177 ?\^h)
	(aset the-table ?\^h ?\177)
	(setq keyboard-translate-table the-table))))


; do auto inserting for new files.

  (when (require 'autoinsert nil t)
    (auto-insert-mode)
    (setq auto-insert-directory "~/lib/emacs/lisp/auto-ins-skeletons")
    (setq auto-insert-query nil)
    (mapc (lambda (p) (define-auto-insert (car p) (cdr p)))
      '(("\\.java$" . "java")
	("\\.pic$" . "pic")
	("\\.arr$" . "pyret")
	("\\.awkpic$" . "awkpic")
	("gen-[^/]*html$" . "gen-html"))))


  (when (require 'auto-complete nil t)
    (let ((d "/usr/share/auto-complete/dict/"))
      (when (file-exists-p d)
	(add-to-list 'ac-dictionary-directories d))
      (require 'auto-complete-config)
      (ac-config-default)))


; set some globally useful functions.

  (defun shell-command-on-buffer (command)

    "Execute string COMMAND in inferior shell with buffer as input. See \\[shell-command-on-region]."

    (interactive (list (read-from-minibuffer "Shell command on buffer: "
					     nil nil nil
					     'shell-command-history)))
    (shell-command-on-region (point-min) (point-max) command
			     current-prefix-arg
			     current-prefix-arg
			     shell-command-default-error-buffer))

   (defun require-or-print (sym)
     (if (require sym nil t)
       t
       (message "!! %s require failed" sym)
       nil))

   (global-set-key "\e\e" nil)
   (global-set-key "\M-\C-r" 'query-replace-regexp)
   (global-set-key "\M-s" 'replace-regexp)
   (global-set-key "\M-]" 'forward-paragraph)
   (global-set-key "\M-[" 'backward-paragraph)
   (global-set-key "\C-c\C-b" 'browse-url-at-point)
   (global-set-key "\C-c|" 'shell-command-on-buffer)
   (global-set-key "\C-crs" 'replace-string)
   (global-set-key "\C-crr" 'replace-regexp)
   (global-set-key "\C-crq" 'query-replace-regexp)


; flyspell

  ; sometimes flyspell freaks out, and it should be turned off (set
  ; non-positive) until it's fixed.

  (if (not (executable-find "aspell"))
    (defvar do-flyspell-mode -1) ; no aspell, no flyspell mode.
    (defvar do-flyspell-mode 1)
    (defvar ispell-program-name "aspell")
    (defvar ispell-extra-args   '("--sug-mode=ultra")))


; Rename the buffer and the file at the same time.

  (defun rename-current-buffer-file ()
    "Renames current buffer and file it is visiting."
    (interactive)
    (let ((name (buffer-name))
	  (filename (buffer-file-name)))
      (if (not (and filename (file-exists-p filename)))
	  (error "Buffer '%s' is not visiting a file!" name)
	(let ((new-name (read-file-name "New name: " filename)))
	  (if (get-buffer new-name)
	      (error "A buffer named '%s' already exists!" new-name)
	    (rename-file filename new-name 1)
	    (rename-buffer new-name)
	    (set-visited-file-name new-name)
	    (set-buffer-modified-p nil)
	    (message "File '%s' successfully renamed to '%s'"
		     name (file-name-nondirectory new-name)))))))

  (global-set-key (kbd "C-x C-r") 'rename-current-buffer-file)


; ace jump everywhere.

  (autoload 'ace-jump-mode "ace-jump-mode" "Emacs quick move minor mode" t)
  (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)


; make label text visibile on dark (black) backgrounds.

  ; This may be a bad thing to do because there's only supposed to be one of
  ; these forms managed by custom mode.  Custom mode stores this form in the
  ; init file, not in this file.  Using custom mode to fiddle with the font
  ; faces will create a second form, which is claimed to screw things up.

  (custom-set-faces
    '(minibuffer-prompt ((t (:foreground "green"))))
    '(w3m-anchor 
      ((((class color) (background dark)) (:foreground "yellow"))
       (((class color) (background light)) (:foreground "yellow"))))
    '(w3m-arrived-anchor 
      ((((class color) (background dark)) (:foreground "cyan")) 
       (((class color) (background light)) (:foreground "cyan")))))


; Make noise characters less visible.

  (defface noise-chars-face
     '((((class color) (background dark))
	(:foreground "grey25"))
       (((class color) (background light))
	(:foreground "grey75")))
     "Face used to dim noise characters.")


; package management

  (cond
    ((= emacs-major-version 24)

      ; details from 2015/01/06/my-emacs-configuration-with-use-package.html
      ; at www.lunaryorn.com

      ; ("marmalade" . "http://marmalade-repo.org/packages/")
      ; replaced by melpa-stable

      (require-or-print 'package)
      (setq package-enable-at-startup nil)
      (mapc (lambda (p) (add-to-list 'package-archives p)) 
	    '(("melpa-stable" . "http://stable.melpa.org/packages/")
	      ("elpa" . "http://elpa.gnu.org/packages/")))

      (package-initialize)

      ; Bootstrap use-package

      (unless (package-installed-p 'use-package)
	(package-refresh-contents)
	(package-install 'use-package))))

