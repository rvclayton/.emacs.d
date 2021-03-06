;; -*- lexical-binding: t -*-

; An init.el that emacs doesn't modify to make it easier to keep under
; source-code control.  init.el should require or load this (make sure
; load-path is set apropriately).

(require 'package)

(setq package-enable-at-startup nil)

; the working geiser is in melpa-unstable

(mapc (lambda (a) (add-to-list 'package-archives a 'append))
      '(("gnu"            . "https://elpa.gnu.org/packages/")
	("melpa-stable"   . "https://stable.melpa.org/packages/")
	("melpa-unstable" . "http://melpa.org/packages/")))

(when (< emacs-major-version 27)
  (package-initialize))
; (package-refresh-contents)  ; do this by hand when needed, it's slow.

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(mapc 
  (lambda (f)
    (let ((fn (concat "~rclayton/.emacs.d/" f ".el")))
      (when (file-exists-p fn)
	(load-file fn))))
  '("customizations" "common" "general"))

(provide 'stable-init) 
