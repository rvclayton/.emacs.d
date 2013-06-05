(load "~rclayton/.emacs.d/common")

; rmail

  (defvar my-mail-dir "~/mail" "the directory containing mail files")

  (setq mail-user-agent 'sendmail-user-agent)
  (setq rmail-primary-inbox-list (list))
  (mapc 
    (lambda (f)
      (when (file-exists-p f)
	(add-to-list 'rmail-primary-inbox-list f)))
    (list
      (expand-file-name (concat my-mail-dir "/hcoop-incoming"))
      (expand-file-name (concat my-mail-dir "/incoming"))
      (concat "/var/mail/" (user-login-name))
      (concat "/var/spool/mail/" (user-login-name))))

  (let ((month (substring (downcase (current-time-string)) 4 7)))
    (setq mail-archive-file-name (concat my-mail-dir "/" month ".out"))
    (setq rmail-file-name (concat my-mail-dir "/" month)))

  (setq rmail-ignored-headers
       (concat "^(via:\\|mail-from:\\|origin\\|status\\|received"
	       "\\|[a-z-]*message-id\\|summary-line\\|errors-to"
	       "\\|in-reply\\|vote-\\|return-\\|refer\\|x-\\|X-\\|user-"
	       "\\|mime-\\|reply-to\\|approved-by\\|thread"
	       "\\|Delivered\\|Content-type\\|DKIM-Signature"
	       "\\|resent-\\|precedence\\|auto\\|list\\|lines\\|Sender)"))

  (defun NoBackupMode ()
    (auto-save-mode 1)
    (flyspell-mode do-flyspell-mode)
    (set-variable 'fill-column 79)
    (make-local-variable 'make-backup-files)
    (setq make-backup-files nil)
    (setq enable-local-variables ())
    (setq auto-save-interval 0)
    (load "mail-mode")
    (load "etach")
    (setq etach-prompt-me-for-file-names t))

  (cond
    ((string=  (getenv "Domain") "monmouth.edu")
       (setq mail-host-address "monmouth.edu")
       (setq user-mail-address (concat "rclayton@" mail-host-address)))
    (t
       (setq mail-host-address "verizon.net") ; was "acm.org" 
       (setq user-mail-address (concat "rvclayton@" mail-host-address))))

  (add-hook 'mail-mode-hook 
    (lambda ()
      (NoBackupMode)
      (define-key mail-mode-map "\e," 'ispell-word)))

  (add-hook 'rmail-mode-hook
    (lambda ()
      (NoBackupMode)
      (define-key rmail-mode-map "\e." 'fill-paragraph)
      (add-hook 'rmail-show-message-hook 'mail-delete-nesting)
      (setq rmail-confirm-expunge nil)))
