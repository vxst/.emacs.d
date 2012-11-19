(autoload 'js3-mode "js3")

;; ;; dirty fix for (error "No JavaScript AST available")
;; (add-hook js3-mode-hook (lambda ()
;; 			  (open-line)
;; 			  (undo)))

(add-to-list 'auto-mode-alist '("\\.js$" . js3-mode))
(provide 'init-js)
