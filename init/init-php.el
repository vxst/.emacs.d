(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

;; fix htmlize
(defface quote
  '()
  "Face")
(defface font-lock-constant-face
  '()
  "Face")
(provide 'init-php)
