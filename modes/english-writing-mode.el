;;; english-writing-mode.el --- 

;; Copyright (C) 2012  Zeno Zeng

;; Author: Zeno Zeng <zenoes@qq.com>
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

(defvar english-writing-mode-hook nil)

(defvar english-writing-mode-map
  (let ((map (make-keymap)))
    (define-key map "\C-j" 'newline-and-indent)
    map)
  "Keymap for this major mode")


;; 自动拼写检查
(setq ispell-dictionary "english")      ;设置英文词典
(add-hook 'english-writing-mode-hook 'flyspell-mode)

;; 单词自动补全
(defun my-writting-auto-complete ()
  (when (eq major-mode 'english-writing-mode)
    (let* ((beg
	    (save-excursion
	      (backward-word)
	      (point)))
	   (dabbrev-search-these-buffers-only
	    (list "words")))
      (if (> (- (point) beg) 3)
	  (dabbrev-completion 16)))))

(add-hook 'english-writing-mode-hook 'auto-complete-mode)
(add-hook 'post-self-insert-hook 'my-writting-auto-complete)
(find-file-noselect "/usr/share/dict/words")


(define-derived-mode english-writing-mode text-mode "EnWriting"
  "Major mode for english writing"
  (interactive)
  (kill-all-local-variables)
  (use-local-map english-writing-mode-map)
  (setq major-mode 'english-writing-mode)
  (setq mode-name "English Writing")
  (run-hooks 'english-writing-mode-hook))

(provide 'english-writing-mode)
;;; english-writing-mode.el ends here
