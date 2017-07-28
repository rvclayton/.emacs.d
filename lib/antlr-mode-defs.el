;;; antlr-mode-defs.el ---                 -*- lexical-binding: t; -*-

;; Copyright (C) 2017  R. Clayton

;; Author: R. Clayton <rclayton@rclayton.net>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:


(defun antlr:insert-colon ()

  (interactive)

  (let ((pat "^[a-zA-Z]+"))

    (cond
      ((looking-back pat)
         (insert "\n  : \n  ;\n")
	 (when (looking-at pat)
	   (insert "\n")
	   (forward-line -1))
	 (forward-line -1)
	 (forward-char -1))

      (t
         (insert ":")))))


(define-key antlr-mode-map ":" 'antlr:insert-colon)


(provide 'antlr-mode-defs)
