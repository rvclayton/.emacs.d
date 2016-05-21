;;; general-utils.el --- 

;; Copyright (C) 2010  R. Clayton

;; Author: R. Clayton <rvclayton@acm.org>
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

;; A bunch of small functions that do re-occurring tasks in larger e-lisp
;; programs (they do in my code, anyway).  Do (require 'general-utils) in
;; source to use them.

;;; Code:


(defun genutl:as-base-1000-number (i)

"Convert the given positive integer to a base-1000 number, returning the 
digits in a list."

  (let (f)                                                                     

    (fset 'f 
      (lambda (i l) 
        (if (= i 0) 
          l 
          (f (/ i 1000) (cons (% i 1000) l))))) 
 
    (if (and (integerp i) (> i -1))
      (f i '()) 
      '(0))))


(defun genutl:delete-matching-region (start-pat end-pat)

"Search the current buffer forward from point for the first (leftmost, closest)
region starting and ending with the given strings.  If there is such a region,
delete it and return non-nil; return nil if there's no such region."

  (let ((region (genutl:find-region-extents start-pat end-pat)))
    (when region
      (delete-region (car region) (cdr region)))
    region))


(defun genutl:delete-regexp-matches (regexp min max)

  "Delete all matches for the given regular expression from the given region."

  (genutl:replace-regexp-matches regexp "" min max))


(defun genutl:emacs-major-version ()

  "Return the emacs major version number (the leftmost digits) as an integer."

  (let ((mv (genutl:regexp-match ".*Emacs +\\([0-9]+\\)\\." (emacs-version))))
    (if mv
      (string-to-number mv)
      (error "Can't extract the major version number from emacs-version"))))


(defun genutl:escape-re-metachars (s)
  "Return a copy of the given string with all the regular-expression metacharacters escaped."

  (with-current-buffer (get-buffer-create "escape-re-metachars")
    (erase-buffer)
    (insert s)
    (goto-char (point-max))
    (while (search-backward-regexp "[[?*]" nil t)
      (insert "\\")
      (forward-char -1))
    (buffer-string)))


(defun genutl:extract-anchored-text (attribute-pattern)

  "Search forward from point, looking for the next anchor tag containing attributes matching the given regular expression.  Return nil if there's no such anchor tag; otherwise return the anchored text as a string."


  (let* ((p (concat "<a[^>]*" attribute-pattern "[^>]*>"))
	 (r (re-search-forward p nil t)))
    (if (not  r)
      nil
      (if (search-forward "</a>")
	(buffer-substring r (- (point) 4))
	(message "Closing anchor tag search failed")
	nil))))


(defun genutl:extract-region-to-register (start-pat end-pat reg)

"Search the current buffer forward from point for the first (leftmost, closest)
region starting and ending with the given strings.  If there is such a region,
extract it into the given register and return non-nil; return nil if there's no
such region.  The point and buffer are unchanged."

  (save-excursion
    (let ((region (genutl:find-region-extents start-pat end-pat)))
      (when region
	(copy-to-register reg (car region) (cdr region)))
      region)))


(defun genutl:find-region-extents (start-str end-str)

"Search the current buffer forward from point for the first (leftmost, closest)
region starting and ending with the given strings.  If there is such a region,
return a cons cell containing the point immediately to the left of the start
string (car) and the point immediately to the right of the end string (cdr);
return nil if there's no such region. After a successful search, point is
immediately to the right of the end string; otherwise point is left unchanged."
  
  (let ((search-start (point)))
    (if (search-forward start-str nil t)
      (let ((start (match-beginning 0)))
	(if (search-forward end-str nil t)
	  (cons start (match-end 0))
	  (message "Can't find the region-end string \"%s\"." end-str)
	  (goto-char search-start)
	  nil))
      (message "Can't find the region-start string \"%s\"." start-str)
      nil)))


(defun genutl:regexp-match (regexp string)

"Match the given string against the given regular expression and return the substring matching the parentisized subpattern in pattern.  Return nil if there was no match"

  (if (string-match regexp string)
    (match-string 1 string)
    nil))


(defun genutl:replace-regexp-matches (regexp replacement min max)

"Substitute all matches for the given regular expression from the
given region with the given replacement."

  (goto-char max)
  (while (search-backward-regexp regexp min t)
    (let ((p (point)))
      (replace-match replacement)
      (goto-char p))))


(defun genutl:window-height-percentage (&optional window)

  ; Return a window height as a percentage of the height of the frame
  ; containing the window.  Return 0 if anything goes wrong.  If window is nil,
  ; use the selected window; if window is a live window, use that; if window is
  ; a string, assume it's a buffer name and use the associated window; if
  ; window is a buffer, use the associated window; otherwise, something's gone
  ; wrong.

  ; This code probably doesn't work correctly if the window is not part of a
  ; frame (that is, is buried and not being displayed).

  (let (f)

    (fset 'f
       (lambda (w)
	 (if (not (windowp w))
	   0
	   (let ((f (window-frame w)))
	     (if (not (framep f))
	       0
	       (let ((h (frame-height f)))
		 (if (= 0 h)
		   0
		   (/ (float (window-height w)) h))))))))

    (cond
      ((not window)
         (f (selected-window)))
      ((windowp window)
         (f window))
      ((or (stringp window) (bufferp window))
         (f (get-buffer-window window)))
      (1
         0))))


(provide 'general-utils)


; $Log: general-utils.el,v $
; Revision 1.6  2016/04/10 00:22:05  rclayton
; Summary: string-to-int -> string-to-number
;
; Revision 1.5  2016/04/10 00:20:37  rclayton
; Summary: escape '[' in escape-re-metachars
;
; Revision 1.4  2013/12/29 02:19:29  rclayton
; make the genutl:window-height-percentage argument optional and multi-typed.
;
; Revision 1.3  2013/12/28 21:20:35  rclayton
; define genutl:window-height-percentage
;
; Revision 1.2  2013/11/08 19:28:36  rclayton
; define genutl:extract-anchored-text
;
; Revision 1.1  2012/09/22 20:34:13  rclayton
; Initial revision
;
