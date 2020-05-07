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

(let (f)

  (fset 'f (lambda (f) (concat "~rclayton/.emacs.d/" f ".el")))
  
  (load-file (f "customizations"))
  (load-file (f "common"))
  (load-file (f "general")))

