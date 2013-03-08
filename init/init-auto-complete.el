(require 'auto-complete)
(require 'auto-complete-config)

;; emacs-lisp
(defvar ac-emacs-lisp-sources
  '(ac-source-symbols))
(defvar ac-emacs-lisp-features nil)
(defvar ac-source-emacs-lisp-features
  '((init
     . (lambda ()
         (unless ac-emacs-lisp-features
           (let ((suffix (concat (regexp-opt (find-library-suffixes) t) "\\'")))
             (setq
              ac-emacs-lisp-features
              (delq nil
                    (apply 'append
                           (mapcar (lambda (dir)
                                     (if (file-directory-p dir)
                                         (mapcar (lambda (file)
                                                   (if (string-match suffix file)
                                                       (substring file 0 (match-beginning 0))))
                                                 (directory-files dir))))
                                   load-path))))))))
    (candidates . (lambda () (all-completions ac-prefix ac-emacs-lisp-features)))))
(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
	    (let ((ac-sources
		   '(ac-source-emacs-lisp-features
		     ac-source-symbols
		     ac-source-abbrev
		     ac-source-words-in-buffer
		     ac-source-words-in-same-mode-buffers
		     ac-source-files-in-current-dir
		     ac-source-filename)))
	      (auto-complete-mode))))




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
                less-css-mode-hook
		ess-mode-hook
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
