;; 代码折叠
(require 'yafolding)

;; 导出的时候就不必隐藏了。
;; (add-hook 'htmlize-before-hook   'hs-show-all)

;; 依照缩进来折叠代码
(define-key global-map (kbd "C-'") 'yafolding)

(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
	    (yafolding-hide-all 1)))

(provide 'init-folding)
