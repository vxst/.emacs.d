;; 代码折叠
(require 'yafolding)

;; 导出的时候就不必隐藏了。
;; (add-hook 'htmlize-before-hook   'hs-show-all)

;; 依照缩进来折叠代码
(define-key global-map [C-return] 'yafolding)
(define-key global-map (kbd "C-c C-f") 'yafolding-toggle-all)

(add-hook 'js3-mode-hook
	  (lambda ()
	    (local-set-key [C-return] 'js3-mode-toggle-element)
	    (local-set-key (kbd "C-c C-f") 'js3-mode-toggle-hide-functions)
	    ))

(provide 'init-folding)
