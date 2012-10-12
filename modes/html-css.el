;;; html-css.el --- multi-mode PHP embedded in HTML

;; Copyright (C) 2008  Dave Love

;; Author: Andreas Raster <lazor@affenbande.org>
;; URL: http://github.com/rakete

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

(require 'multi-mode)
(require 'multi-util)

(defun html-css-mode ()
  (interactive)
  (set (make-local-variable 'multi-alist)
       '((html-mode)
         (css-mode . html-css-chunk-region)))
  (add-hook 'multi-indirect-buffer-hook
            (lambda ()
              (when (eq major-mode 'html-mode)
                (setq indent-line-function 'sgml-indent-line)))
            t t)
  (multi-mode-install-modes))

(defun html-css-chunk-region (pos)
  (interactive)
  (multi-mode-mode-chunk pos "<style[^>]*>" "<\/style>" 'css-mode 'html-mode))

(provide 'html-css)
