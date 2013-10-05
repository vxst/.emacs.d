;; 缩进提示线

(require 'highlight-indentation-autoloads)
(defun get-indentation-offset()
  (save-excursion
    (goto-char (point-min))
    (while (and (= (current-indentation) 0)
                (< (line-number-at-pos (point))
                   (line-number-at-pos (point-max))))
      (forward-line))
    (current-indentation)))
(dolist (hook '(coffee-mode-hook js3-mode-hook))
  (add-hook hook
            (lambda ()
              (highlight-indentation-set-offset (get-indentation-offset))
              (highlight-indentation-mode)
              (highlight-indentation-current-column-mode))))


;; 高亮无意义空白及超过80的行

(require 'whitespace)
(setq whitespace-line-colum 80)
(setq whitespace-style '(face tabs lines-tail trailing))
(global-whitespace-mode t)

(provide 'init-whitespace)
