;; 高亮无意义空白及超过80的行

(require 'whitespace)
;; (setq whitespace-line-colum 80)
;; (setq whitespace-style '(face tabs lines-tail trailing))
(setq whitespace-style '(face trailing))

;; 注意 whitespace-mode 会破坏 web-mode 的高亮
(dolist (hook '(
                c-mode-hook
                emacs-lisp-mode-hook
                ess-mode-hook
                coffee-mode-hook
                js3-mode-hook
                less-css-mode-hook
                php-mode-hook
                ))
  (add-hook hook
            (lambda ()
              (whitespace-mode))))


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
    (if (> (current-indentation) 1) ;; indentation should nerver less than 2
        (current-indentation) ; for existing files, use current indent setting
      (cond ((eq major-mode 'coffee-mode) 2)
            ((eq major-mode 'js3-mode) 4)
            ((eq major-mode 'less-css-mode) 4)
            (t 4)))))
(dolist (hook '(coffee-mode-hook js3-mode-hook less-css-mode-hook))
  (add-hook hook
            (lambda ()
              (highlight-indentation-set-offset (get-indentation-offset))
              (highlight-indentation-mode)
              (highlight-indentation-current-column-mode))))
