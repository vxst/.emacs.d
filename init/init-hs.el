;; 代码折叠

(add-hook 'c-mode-common-hook   'my-hs)
(add-hook 'emacs-lisp-mode-hook 'my-hs)
(add-hook 'java-mode-hook       'my-hs)
(add-hook 'perl-mode-hook       'my-hs)
(add-hook 'sh-mode-hook         'my-hs)
(add-hook 'scheme-mode-hook     'my-hs)
(add-hook 'css-mode-hook        'my-hs)
(add-hook 'less-mode-hook       'my-hs)
(add-hook 'php-mode-hook     (lambda ()
                               (my-hs)
                               (hs-hide-level 2)))


;; dirty fix for js3-mode
(defadvice js3-mode-advice (after js3-mode)
  (my-hs))
(ad-activate 'js3-mode-advice)


;; 导出的时候就不必隐藏了。
(add-hook 'htmlize-before-hook   'hs-show-all)

(setq hs-hide-comments-when-hiding-all nil)

(defun my-hs ()
  "My hideshow mode."
  (hs-minor-mode)
  (local-set-key (kbd "C-'") 'hs-toggle-hiding)
  (hs-hide-all))

;; 依照缩进来折叠代码
;; (define-key global-map (kbd "H-'") 'my-toggle-selective-display)
(defun my-toggle-selective-display()
  "set-selective-display to current column or toggle selective-display --lgfang"
  (interactive)
  (let ((arg (progn (back-to-indentation) (current-column))))
    (set-selective-display (if (eq arg selective-display) nil arg))))

(add-hook 'html-mode-hook (lambda ()
			    (local-set-key (kbd "C-'") 'my-toggle-selective-display)))

(provide 'init-hs)
