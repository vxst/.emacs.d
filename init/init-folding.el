;; 代码折叠

(require 'yafolding)

;; (define-key yafolding-mode-map (kbd "<C-S-return>") nil)
;; (define-key yafolding-mode-map (kbd "<C-return>") nil)
;; (define-key yafolding-mode-map (kbd "C-c <C-S-return>") 'yafolding-toggle-all)
;; (define-key yafolding-mode-map (kbd "C-c <C-return>") 'yafolding-toggle-element)

;; 导出的时候就不必隐藏了。
;; (add-hook 'htmlize-before-hook   'hs-show-all)

(add-hook 'prog-mode-hook
          (lambda () (yafolding-mode)))

(provide 'init-folding)
