;; Less
(autoload 'less-css-mode "less-css-mode-rm-flymake.el"
  "Major mode for editing less-css files" t)
(setq auto-mode-alist
      (cons '("\\.less" . less-css-mode) auto-mode-alist))

;; Rainbow
(dolist (hook '(css-mode-hook
                html-mode-hook
                python-mode-hook
                less-css-mode-hook
                lisp-mode-hook))
  (add-hook hook (lambda () (rainbow-mode 1))))

(require 'css-eldoc)
(add-hook 'css-mode-hook
	  '(lambda ()
	     (set
	      (make-local-variable 'eldoc-documentation-function)
	      'css-eldoc-function)
	     (eldoc-mode)))
(add-hook 'less-mode-hook
	  '(lambda ()
	     (set
	      (make-local-variable 'eldoc-documentation-function)
	      'css-eldoc-function)
	     (eldoc-mode)))

(provide 'init-css)
