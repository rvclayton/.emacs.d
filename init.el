(require 'package)

(setq package-archives
      '(("gnu"          . "https://elpa.gnu.org/packages/")
	("melpa-stable" . "https://stable.melpa.org/packages/")))

(package-initialize)
; (package-refresh-contents)  ; do this by hand when needed.

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(mapc 
  (lambda (f)
    (let ((fn (concat "~rclayton/.emacs.d/" f ".el")))
      (when (file-exists-p fn)
	(load-file fn))))
  '("customizations" "common" "general"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (yasnippet-snippets yasnippet which-key paredit markdown-mode google-this geiser dart-mode proof-general ace-window use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(minibuffer-prompt ((t (:foreground "green"))))
 '(w3m-anchor ((((class color) (background dark)) (:foreground "yellow")) (((class color) (background light)) (:foreground "yellow"))))
 '(w3m-arrived-anchor ((((class color) (background dark)) (:foreground "cyan")) (((class color) (background light)) (:foreground "cyan")))))
