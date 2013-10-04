;; 高亮中文符号

(add-hook 'font-lock-mode-hook
          (lambda ()
            (setq font-lock-keywords
                  (append font-lock-keywords
                          '(("[（），；]"  (0 'error t)))))))

(provide 'init-check)
