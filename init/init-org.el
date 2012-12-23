(setq org-agenda-files (list
			"~/org/new-gtd.org"
			"~/db/core/journal.org.gpg"
			"~/git/doc/study.org"
			"~/git/doc/pp.org"
			"~/org/work.org"
			"~/org/ppro.org"))
(setq org-mobile-directory "~/org/mobileorg")
(setq org-hide-leading-stars t)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cs" 'org-gtd-summary)
(require 'org-gtd-summary)

(define-key global-map "\C-cp" 'org-personal-agenda)


;; 全屏显示agenda视图
(add-hook 'org-agenda-mode-hook (lambda ()
				  (delete-other-windows)))

(setq org-log-done 'time)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")
	      (sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(e)")
	      (sequence "TRY(y)" "|"  "FAILED(f@/!)" ))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "orange red" :weight bold)
              ("NEXT" :foreground "deepskyblue" :weight bold)
              ("DONE" :foreground "LawnGreen" :weight bold)
              ("WAITING" :foreground "tomato" :weight bold)
              ("HOLD" :foreground "deep pink" :weight bold)
              ("CANCELLED" :foreground "gray" :weight bold)
	      ("FAILED" :foreground "dark grey" :weight bold))))

;; Capture
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/new-gtd.org" "Inbox")
	 "* TODO %?\n")
	("h" "Homework" entry (file+headline "~/org/study.org" "Homework")
	 "* TODO %?\n")
	("e" "Emacs Notes" entry (file+headline "~/org/notes/emacs.org" "Notes")
	 "* %?\n %i\n %a")
	("p" "Emacs Notes" entry (file+headline "~/org/notes/php.org" "capture")
	 "* %?\n %i\n %a")
	("l" "Emacs Lisp Notes" entry (file+headline "~/org/notes/lisp.org" "Notes")
	 "* %?\n %i\n %a")
	("j" "Journal" entry (file+datetree "~/org/journal.org.gpg")
	 "* %?")))

(defalias 'zeno 'org-gtd-summary)

(require 'org-my-exp)
(add-hook 'org-mode-hook (lambda ()
			   (local-unset-key (kbd "H-e"))
			   (local-set-key (kbd "H-e") 'org-my-exp)))

(provide 'init-org)
