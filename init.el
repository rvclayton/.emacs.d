(require 'package)

(setq package-archives
      '(("gnu"          . "https://elpa.gnu.org/packages/")
	("melpa-stable" . "https://stable.melpa.org/packages/")))

(package-initialize)
(package-refresh-contents)

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

