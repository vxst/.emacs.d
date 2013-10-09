;; 高亮中文符号
;; add-hook 'font-lock-mode-hook

(dolist (hook '(coffee-mode-hook js3-mode-hook less-css-mode-hook))
  (add-hook hook
            (lambda ()
              (setq font-lock-keywords
                    (append font-lock-keywords
                            '(("[（），；“”]"  (0 'error t))))))))

(provide 'init-check)
