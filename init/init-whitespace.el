;; 高亮无意义空白及超过80的行

(require 'whitespace)
(setq whitespace-line-colum 80)
(setq whitespace-style '(face tabs lines-tail trailing))
(global-whitespace-mode t)

(provide 'init-whitespace)

;; 缩进提示线

(require 'highlight-indentation-autoloads)
(defun get-indentation-offset()
  (save-excursion
    (goto-char (point-min))
    (while (and (= (current-indentation) 0)
                (< (line-number-at-pos (point))
                   (line-number-at-pos (point-max))))
      (forward-line))
    (if (> (current-indentation) 0)
        (current-indentation) ; for existing files, use current indent setting
      (cond ((eq major-mode 'coffee-mode) ; for new files
             2)
            ((eq major-mode 'js3-mode)
             4)
            (t 4)))))
(dolist (hook '(coffee-mode-hook js3-mode-hook))
  (add-hook hook
            (lambda ()
              (highlight-indentation-set-offset (get-indentation-offset))
              (highlight-indentation-mode)
              (highlight-indentation-current-column-mode))))
