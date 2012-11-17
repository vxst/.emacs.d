(autoload 'php-mode "php-mode.el"
  "Major mode for editing PHP files" t)
(setq auto-mode-alist
      (cons '("\\.php" . php-mode) auto-mode-alist))

;; 添加类似elisp的函数查询，依赖php-extras
(add-hook 'php-mode-hook '(lambda ()
			    (eldoc-mode)))

(provide 'init-php)
