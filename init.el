(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(canlock-password "ec29aa15f46d35b18a7e50e124673f00529cbd8f")
 '(initial-major-mode (quote text-mode))
 '(package-selected-packages
   (quote
    (yaml-mode use-package scala-mode2 processing-snippets processing-mode paredit magit go-mode geiser ein dart-mode avy)))
 '(quack-programs
   (quote
    ("mzscheme" "bigloo" "csi" "csi -hygienic" "gosh" "gracket" "gsi" "gsi ~~/syntax-case.scm -" "guile" "kawa" "mit-scheme" "racket" "racket -il typed/racket" "rs" "scheme" "scheme48" "scsh" "sisc" "stklos" "sxi")))
 '(send-mail-function (quote sendmail-send-it)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(button ((t (:inherit header\ line))))
 '(custom-comment-tag ((t (:foreground "white"))))
 '(custom-link ((t (:inherit underline))))
 '(custom-visibility ((t (:inherit underline :height 0.8))))
 '(link ((t (:foreground "white" :underline t))))
 '(minibuffer-prompt ((t (:foreground "green"))))
 '(w3m-anchor ((((class color) (background dark)) (:foreground "yellow")) (((class color) (background light)) (:foreground "yellow"))))
 '(w3m-arrived-anchor ((((class color) (background dark)) (:foreground "cyan")) (((class color) (background light)) (:foreground "cyan")))))

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.

;; (when
;;     (load
;;      (expand-file-name "~/.emacs.d/elpa/package.el"))
;;   (package-initialize))

(package-initialize)

(load "~rclayton/.emacs.d/common.el")
(load "~rclayton/.emacs.d/general.el")


