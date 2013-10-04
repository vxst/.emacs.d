;;(require 'highlight-indentation-autoloads)

;; (defun get-indentation-offset()
;;   (save-excursion
;;     (goto-char (point-min))
;;     (while (and (= (current-indentation) 0)
;;                 (< (line-number-at-pos (point))
;;                    (line-number-at-pos (point-max))))
;;       (forward-line))
;;     (current-indentation)))

;; (dolist (hook '(coffee-mode-hook js3-mode-hook))
;;   (add-hook hook
;;             (lambda ()
;;               (message "%d" (get-indentation-offset))
;;               (highlight-indentation-set-offset (get-indentation-offset))
;;               (highlight-indentation-mode))))

;; 高亮无意义空白及超过80的行

(require 'whitespace)
(setq whitespace-line-colum 80)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

;; 高亮缩进

(custom-set-faces '(my-indent-face  ((((class color)) (:background "#080808"))) t))
(add-hook 'font-lock-mode-hook
          (lambda ()
            (setq font-lock-keywords
                  (append font-lock-keywords
                          '(("\\(^[ \t]*\\)\\( \\) .*$"
                             (1 'my-indent-face t)
                             (2 'my-indent-face t)))))))

(provide 'init-whitespace)
