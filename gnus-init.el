(load "~rclayton/.emacs.d/common")

; gnus

  (setq gnus-nntp-server (getenv "nntpserver"))
  (if (not gnus-nntp-server) (setq gnus-nntp-server "news.verizon.net"))
  (setq gnus-newsrc-save-frequency 20)
  (setq gnus-show-all-headers nil)
  (setq gnus-large-newsgroup 200)
  (setq gnus-score-expiry-days 30)

  (setq gnus-ignored-headers (concat
    "^Path:\\|^Posting-Version:\\|^Article-I.D.:\\|^Expires:\\|^Reply-To:\\|"
    "^Date-Received:\\|^References:\\|^Control:\\|^X\\|^Lines:\\|^Mime\\|"
    "^Posted:\\|^Relay-Version:\\|^Message-ID:\\|^Nf-ID:\\|^Nf-From:\\|"
    "^Approved:\\|^Keywords:\\|^Sender:\\|^NNTP-Posting-Host:\\|^Content\\|"
    "^Newsgroups:\\|^Organization:"))

  (add-hook 'gnus-startup-hook
    (lambda ()
      (set-variable 'fill-column 79)
      (local-set-key "\C-c\C-b" 'browse-url-at-point)))
