;; 代码折叠

(add-hook 'c-mode-common-hook   'my-hs)
(add-hook 'emacs-lisp-mode-hook 'my-hs)
(add-hook 'java-mode-hook       'my-hs)
(add-hook 'js2-mode-hook        'my-hs)
(add-hook 'perl-mode-hook       'my-hs)
(add-hook 'sh-mode-hook         'my-hs)
(add-hook 'scheme-mode-hook     'my-hs)
(add-hook 'css-mode-hook        'my-hs)
(add-hook 'less-mode-hook       'my-hs)
(add-hook 'php-mode-hook     (lambda ()
                               (my-hs)
                               (hs-hide-level 2)))

;; 导出的时候就不必隐藏了。
(add-hook 'htmlize-before-hook   'hs-show-all)

(setq hs-hide-comments-when-hiding-all nil)

(defun my-hs ()
  "My hideshow mode."
  (hs-minor-mode)
  (hs-hide-all))


(provide 'init-hs)
