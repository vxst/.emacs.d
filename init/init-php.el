(autoload 'php-mode "php-mode.el"
  "Major mode for editing PHP files" t)
(setq auto-mode-alist
      (cons '("\\.php" . php-mode) auto-mode-alist))

;; 添加类似elisp的函数查询，依赖php-extras
(add-hook 'php-mode-hook '(lambda ()
 			    (local-set-key (kbd "H-f") 'php-extras-eldoc-documentation-function)))

;; The function php-extras-generate-eldoc will download the PHP manual from php.net and extract the function definitions (slow) and store them in a hash table on disk for you. If you install php-extras as an ELPA package the hash table is already generated for you.

(defun my-php-mode-stuff ()
  (local-set-key (kbd "<f1>") 'my-php-symbol-lookup))
(provide 'init-php)
