(require 'use-package)

(use-package paredit
  :ensure t
  :config
    (setq show-paren-delay 0)
    (show-paren-mode t)
    (setq show-paren-style 'mixed)) ; also 'parenthesis or 'expression

(use-package ace-window
  :ensure t
  :config
    (global-set-key (kbd "C-x o") 'ace-window))

(use-package avy
  :ensure t
  :init
    (global-set-key (kbd "M-C-j") nil)
  :bind (("M-C-j c" . avy-goto-char-2)
	 ("M-C-j w" . avy-goto-word-1)
	 ("M-C-j l" . avy-goto-line)))

(use-package dart-mode
  :ensure t
  :mode "\\.da?rt$"
  :config
    (setq dart-enable-analysis-server t)
    (add-hook 'dart-mode-hook 'flycheck-mode)
  )

(use-package ess
  :ensure t
  :mode "\\.(R\\|r)$"
  :config
    (setq-default ess-dialect "R")
  )


(use-package geiser
  :ensure t
  :mode "\\.(scm\\|rkt)$"
  :config
    (when (string-match "\.rkt$" (buffer-file-name))
      (setq geiser-active-implementations '(racket)))
    (setq geiser-repl-startup-time 5000)
    (require 'quack)
  )


(use-package google-this
  :ensure t
  :diminish google-this-mode
  :config
    (setq google-this-browse-url-function 'eww-browse-url)
    (google-this-mode 1))


(use-package ido
  :ensure t
  :config
    (ido-mode t)
    (setq ido-enable-flex-matching t))


(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("\\.(md\\|markdown)$" . markdown-mode)
	 ("README\\.md$" . gfm-mode))
  )


(use-package which-key
  :ensure t
  :config
    (which-key-mode))


(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config
    (yas-global-mode)
    (add-hook 'hippie-expand-try-functions-list 'yas-hippie-try-expand)
    (setq yas-key-syntaxes '("w_" "w_." "^ "))
    (setq yas-expand-only-for-last-commands nil)
    (yas-global-mode 1)
    (bind-key "\t" 'hippie-expand yas-minor-mode-map)
    (add-to-list 'yas-prompt-functions 'shk-yas/helm-prompt)
    (load "expansion-cursor-indicator"))


(use-package yasnippet-snippets
  :after yasnippet
  :config (yasnippet-snippets-initialize))
