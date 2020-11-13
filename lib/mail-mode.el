
(require 'general-utils)


(defun check-id ()

  "Find the first student id in the current buffer and figure out who that is
using the check-id function."

  (interactive)

  (let ((id (get-student-id)))
    (if id
      (shell-command (concat "checkid " id))
      (message "Can't find a student id."))
  )
)


(defun get-student-id ()

  "Search for the first student id in the current buffer and return it; return
nil if the current buffer doesn't contain a student id."

  (save-excursion
    (goto-char (point-min))
    (if (search-forward-regexp "s0[0-9]+@" (point-max) t)
	(buffer-substring (match-beginning 0) (1- (match-end 0))))
  )
)


(defun mail-clean-html ()

  "Scrub html from a message."

  (interactive)

  (toggle-read-only -1)

  (mail-to-msg-body)
  (let ((pmin (point)))

    (goto-char pmin)
    (let ((h "<head"))
      (when (search-forward h nil t)
	(forward-line 0)
	(genutl:delete-matching-region h "</head>")))

    (genutl:delete-regexp-matches "<[^>]*>" pmin (point-max))
    (genutl:delete-regexp-matches "=\n" pmin (point-max))
    (genutl:delete-regexp-matches "^[[:space:]]+$" pmin (point-max))
    
    (goto-char pmin)
    (while (search-forward "\n\n\n" nil t)
      (replace-match "\n")
      (forward-line -1))

    (mapc

      (lambda (p)
	(genutl:replace-regexp-matches (car p) (cdr p) pmin (point-max)))

      '(("&#8211;" . "-")
	("&#8217;" . "'")
	("&#8218;" . "'")
	("&#8218;" . "'")
	("&#8220;" . "\"")
	("&#8221;" . "\"")
	("&amp;" . "&")
	("&gt;" . ">")
	("&lt;" . "<")
	("&nbsp;" . " ")
	("&quot;" . "\"")
	("&bull;" . "*")))

    (goto-char pmin)
    (search-forward "\n\n" nil t)))


(defun mail-delete-nesting ()

  "Delete overly nested quoted text in a message."

  (let ((inhibit-read-only t))
    (goto-char (point-min))
    (while (search-forward-regexp "^> *>" nil t)
      (forward-line 0)
      (kill-line 1))
    (goto-char (point-min))
    (forward-paragraph)))


(defun mail-to-msg-body ()

  "Move point to the start of the message body."

  (let ((start (point)))
    (goto-char (point-min))
    (unless (search-forward "\n\n" nil t)
      (message "Can't find the message body.")
      (goto-char start))))


(defun print-msg ()

  "Print the message in the current buffer and label it as printed."

  (interactive)

  (print-buffer)
  (rmail-add-label "p"))


(setq mail-specify-envelope-from t)


(local-set-key "\M-\C-p" 'print-msg)
(local-set-key "\C-cc" 'mail-clean-html)


; $Log: mail-mode.el,v $
; Revision 1.4  2014/01/31 16:18:01  rclayton
; mail clean message bodies, not headers; turn bullets into asterisks.
;
; Revision 1.3  2013/02/06 02:53:59  rclayton
; define mail-delete-nesting
;
; Revision 1.2  2013/01/18 17:59:34  rclayton
; convert unicode dashes
;
; Revision 1.1  2012/11/08 00:05:56  rclayton
; added unicode clean-up for single and double quotes.
;
; Revision 1.2  2006-01-20 01:26:11  rclayton
; Remove the user-mail-address set.
;
