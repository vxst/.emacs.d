(autoload 'php-mode "php-mode.el"
  "Major mode for editing PHP files" t)
(setq auto-mode-alist
      (cons '("\\.php" . php-mode) auto-mode-alist))

(setq php-manual-path "~/doc/php-manual/")

(provide 'init-php)
