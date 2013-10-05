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
              (message "%d" (get-indentation-offset))
              (highlight-indentation-set-offset (get-indentation-offset))
              (highlight-indentation-mode)
	      (highlight-indentation-current-column-mode))))

;; 高亮无意义空白及超过80的行

(require 'whitespace)
(setq whitespace-line-colum 80)
;; (setq whitespace-style '(face empty tabs lines-tail trailing))
(setq whitespace-style '(face tabs lines-tail trailing))
(global-whitespace-mode t)



;; (require 'indent-hint-lisp)
;; (add-hook 'emacs-lisp-mode-hook 'indent-hint-lisp)


;; 高亮缩进

;; (defun highlight-col (number mode)
;;   (interactive)
;;   (let* ((regexp (concat "^.\\\\{" number "\\\\}\\\\( \\\\)"))
;;          (number (- number 1)))
;;     (message "%s" regexp)
;;     (font-lock-add-keywords 'coffee-mode
;;                             '(("^.\\{0\\}\\( \\)"
;;                                (0 (prog1 ()
;;                                     (compose-region (match-beginning 1)
;;                                                     (match-end 1)
;;                                                     ?·))))))
;;     ))
;; (highlight-col '1 'coffee-mode)
;; (highlight-col '2 'coffee-mode)
;; (highlight-col '3 'coffee-mode)


;; (let ((char "|"))
;;   (font-lock-add-keywords 'coffee-mode
;;                           '(("^ \\{0\\}\\( \\)"
;;                              (0 (prog1 ()
;;                                   (compose-region (match-beginning 1)
;;                                                   (match-end 1)
;;                                                   ?|)))))))


;; (font-lock-add-keywords 'coffee-mode
;;                         '(("^\\( \\)"
;;                            (0 (lambda ()
;;                                 (compose-region (match-beginning 1)
;;                                                 (match-end 1)
;;                                                 ?┇))))))

;; (custom-set-faces '(my-indent-face  ((((class color)) (:background "#000" :foreground "#000"))) t))
;; (add-hook 'font-lock-mode-hook
;;           (lambda ()
;;             (setq font-lock-keywords
;;                   (append font-lock-keywords
;;                           '(("^\\([ \t]*\\)\\( \\) .*$"
;;                              (1 'my-indent-face t)
;;                              (2 'my-indent-face t)))))))

(provide 'init-whitespace)
