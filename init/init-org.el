(setq org-agenda-files (list "~/org/new-gtd.org"))
(setq org-mobile-directory "~/org/mobileorg")
(setq org-hide-leading-stars t)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done 'time)

;; Capture
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/tasks.org" "任务")
	 "* TODO %?\n")
	("e" "Exam" entry (file+headline "~/org/study.org" "考试")
	 "* TODO %?\n")
	("h" "Homework" entry (file+headline "~/org/study.org" "作业")
	 "* TODO %?\n")
	("e" "Emacs Notes" entry (file+headline "~/org/notes/emacs.org" "Notes")
	 "* %?\n %i\n %a")
	("p" "Emacs Notes" entry (file+headline "~/org/notes/php.org" "capture")
	 "* %?\n %i\n %a")
	("l" "Emacs Lisp Notes" entry (file+headline "~/org/notes/lisp.org" "Notes")
	 "* %?\n %i\n %a")
	("j" "Journal" entry (file+datetree "~/org/journal.org")
	 "* %?")))

(add-hook 'org-mode-hook (lambda ()
			   (local-unset-key (kbd "H-e"))
			   (local-set-key (kbd "H-e") 'org-my-exp)))

(require 'org-my-exp)
(provide 'init-org)
