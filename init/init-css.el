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

(provide 'init-css)
