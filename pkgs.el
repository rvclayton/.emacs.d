(require 'use-package)


(use-package avy
  :ensure t
  :init
    (global-set-key (kbd "M-C-j") nil)
  :bind (("M-C-j 1" . avy-goto-word-1)
	 ("M-C-j 2" . avy-goto-word-2)
	 ("M-C-j l" . avy-goto-line)
	 ))

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
    (add-to-list 'yas-prompt-functions 'shk-yas/helm-prompt))
