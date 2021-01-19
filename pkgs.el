(use-package ace-window
  :ensure t
  :config
    (global-set-key (kbd "C-x o") 'ace-window))


(use-package auto-package-update
  :defer nil
  :ensure t
  :config
    (setq auto-package-update-delete-old-versions t)
    (setq auto-package-update-hide-results t)
    (auto-package-update-maybe))


(use-package avy
  :ensure t
  :init
    (global-set-key (kbd "M-C-j") nil)
  :bind (("M-C-j c" . avy-goto-char-2)
	 ("M-C-j w" . avy-goto-word-1)
	 ("M-C-j l" . avy-goto-line)))


(use-package browse-kill-ring
  :ensure t
  :init
    (global-set-key "\C-cy" 'browse-kill-ring)
  :config
    (setq browse-kill-ring-highlight-inserted-item t)
    (setq browse-kill-ring-highlight-current-entry t))


(when (executable-find "coqc")
  (use-package proof-general
    :ensure t
    :mode ("\\.\\(v\\|coq\\)\\'" . coq-mode)

    :init
      (setq proof-splash-enable nil)
      (when (fboundp 'company-coq-initialize)
	(add-hook 'coq-mode-hook #'company-coq-initialize))
      (add-hook 'coq-mode-hook
        (lambda ()
	  (define-key coq-mode-map "\M-\C-n" #'proof-assert-next-command-interactive)))

    :config
      (setq proof-script-fly-past-comments t)
      (setq proof-three-window-mode-policy 'hybrid))

  (autoload 'coq-mode "~/.emacs.d/elpa/proof-general-4.4/generic/proof-site.elc"
    "Major mode for the coq proof assistant." t))


(use-package dart-mode
  :ensure t
  :mode "\\.da?rt$"
  :config
    (setq dart-enable-analysis-server t)
    (add-hook 'dart-mode-hook 'flycheck-mode)
  )


(use-package geiser
  :ensure t
  :mode "\\.(scm\\|rkt)$"
  :config
    (when (string-match "\.rkt$" (buffer-file-name))
      (setq geiser-active-implementations '(racket)))
    (setq geiser-repl-startup-time 10000)
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
    (setq ido-enable-flex-matching t)
    (setq ido-everywhere t))


(use-package magit
  :ensure t
  )


(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("\\.(md\\|markdown)$" . markdown-mode)
	 ("README\\.md$" . gfm-mode))
  )


(use-package multiple-cursors
  :bind
    ("C->" . mc/mark-next-like-this)
    ("C-<" . mc/unmark-next-like-this)
    ("C-S-c C-S-c" . 'mc/edit-lines)   ; mark all in region
  )


(use-package paredit
  :ensure t
  :diminish paredit-mode
  :config
    (setq show-paren-delay 0)
    (show-paren-mode t)
    (setq show-paren-style 'mixed)) ; also 'parenthesis or 'expression


(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
    (which-key-mode)
    (which-key-setup-side-window-bottom)
    (setq which-key-idle-delay 1))


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
  :ensure t
  :config
    (yasnippet-snippets-initialize))
