(require 'auto-complete)
(require 'auto-complete-config)
(set-default 'ac-sources
             '(ac-source-dictionary
               ac-source-words-in-buffer
               ac-source-words-in-same-mode-buffers))

(defun my-ac-mode ()
  (auto-complete-mode 1)
  (ac-flyspell-workaround))

(dolist (hook '(
                js3-mode-hook
                html-mode-hook
                php-mode-hook
		emacs-lisp-mode-hook
                less-css-mode-hook
                ))
  (add-hook hook 'my-ac-mode))

;; 绑定全局键值
;; 也可以绑定单独到某个mode，比如cc-mode (define-key cc-mode-map (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "(")  'skeleton-pair-insert-maybe)
(global-set-key (kbd "{")  'skeleton-pair-insert-maybe)
(global-set-key (kbd "《")  'skeleton-pair-insert-maybe)
(global-set-key (kbd "（")  'skeleton-pair-insert-maybe)
;; (global-set-key (kbd "\'") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
;; (global-set-key (kbd "[")  'skeleton-pair-insert-maybe)

;; 填入大中小括号，双单引号的匹配
(setq skeleton-pair t)
(setq skeleton-pair-alist '((?\" _ "\"" >)(?\' _ "\'" >)(?《 _"》">)(?（ _"）">)(?\( _ ")" >)(?\[ _ "]" >)(?\{ _ "}" >)))

(provide 'init-auto-complete)
