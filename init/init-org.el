(setq org-agenda-files (list "~/org/new-gtd.org" "~/org/journal.org"))
(setq org-mobile-directory "~/org/mobileorg")
(setq org-hide-leading-stars t)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done 'time)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!/!)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")
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
	("e" "Emacs Notes" entry (file+headline "~/org/notes/emacs.org" "Notes")
	 "* %?\n %i\n %a")
	("p" "Emacs Notes" entry (file+headline "~/org/notes/php.org" "capture")
	 "* %?\n %i\n %a")
	("l" "Emacs Lisp Notes" entry (file+headline "~/org/notes/lisp.org" "Notes")
	 "* %?\n %i\n %a")
	("j" "Journal" entry (file+datetree "~/org/journal.org")
	 "* %?")))


(require 'org-my-exp)
(add-hook 'org-mode-hook (lambda ()
			   (local-unset-key (kbd "H-e"))
			   (local-set-key (kbd "H-e") 'org-my-exp)))

(provide 'init-org)
