(defun yasnippet-can-fire-p (&optional field)

  (interactive)

  (setq yas--condition-cache-timestamp (current-time))

  (let (templates-and-pos)

    (unless (and yas-expand-only-for-last-commands
                 (not (member last-command yas-expand-only-for-last-commands)))
      (setq templates-and-pos
	    (if field
	      (save-restriction
		(narrow-to-region
		  (yas--field-start field)
		  (yas--field-end field))
		(yas--templates-for-key-at-point))
	      (yas--templates-for-key-at-point))))

    (and templates-and-pos (first templates-and-pos))))


(setq default-cursor-color (frame-parameter nil 'cursor-color))
(setq yasnippet-can-fire-cursor-color "green")

(defun my/change-cursor-color-when-can-expand (&optional field)

  (interactive)

  (when (eq last-command 'self-insert-command)
    (set-cursor-color
      (if (my/can-expand)
        yasnippet-can-fire-cursor-color
	default-cursor-color))))


(defun my/can-expand ()
  "Return true if right after an expandable thing."
  (or (abbrev--before-point) (yasnippet-can-fire-p)))

(add-hook 'post-command-hook 'my/change-cursor-color-when-can-expand)

(provide 'expansion-cursor-indicator)
