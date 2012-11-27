(require 'php+-mode)
(require 'php-eldoc)
(php+-mode-setup)

(add-hook 'php+-mode-hook
	  '(lambda ()
	     (set
	      (make-local-variable 'eldoc-documentation-function)
	      'php-eldoc-function)
	     (eldoc-mode)))

(provide 'init-php)
