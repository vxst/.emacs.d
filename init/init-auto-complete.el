(require 'auto-complete)
(require 'auto-complete-config)

;;; basic config
(setq ac-auto-show-menu 0.5) ; delay
(setq ac-ignore-case nil)
(setq ac-use-fuzzy t) ; 模糊匹配
(ac-flyspell-workaround)

(setq-default
 ac-sources
 '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))

(defun my-ac-mode ()
  (auto-complete-mode 1))

(add-hook 'css-mode-hook 'ac-css-mode-setup)
(add-hook 'less-css-mode-hook 'ac-css-mode-setup)

(add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
(add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
(add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
(add-hook 'auto-complete-mode-hook 'ac-common-setup)

(define-key ac-completing-map (kbd "C-n") 'ac-next)
(define-key ac-completing-map (kbd "C-p") 'ac-previous)

(dolist (hook '(
		emacs-lisp-mode-hook
		ess-mode-hook
                html-mode-hook
                js3-mode-hook
                less-css-mode-hook
                php-mode-hook
		web-mode-hook
                ))
  (add-hook hook
	    (lambda ()
	      (auto-complete-mode 1))))

;; hook AC into completion-at-point
(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))
(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)


;; Exclude very large buffers from dabbrev
(defun sanityinc/dabbrev-friend-buffer (other-buffer)
  (< (buffer-size other-buffer) (* 1 1024 1024)))
(setq dabbrev-friend-buffer-function 'sanityinc/dabbrev-friend-buffer)


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
