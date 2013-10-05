;;; Less
(setq less-css-compile-at-save nil)

;; 快捷转换
(defun toggle-less-css-compile-at-save()
  (interactive)
  (setq less-css-compile-at-save (not less-css-compile-at-save)))
(global-set-key [f10] 'toggle-less-css-compile-at-save)

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

;; search 很卡的一个dirty workround
(defun isearch-forward-noeldoc ()
  "close eldoc temperaily"
  (interactive)
  (eldoc-mode -1)
  (isearch-forward)
  (eldoc-mode 1))
(add-hook 'less-css-mode-hook (lambda ()
                                (local-set-key [remap isearch-forward] 'isearch-forward-noeldoc)))

(defun isearch-backward-noeldoc ()
  "close eldoc temperaily"
  (interactive)
  (eldoc-mode -1)
  (isearch-backward)
  (eldoc-mode 1))
(add-hook 'less-css-mode-hook (lambda ()
                                (local-set-key [remap isearch-backward] 'isearch-backward-noeldoc)))


(provide 'init-css)
