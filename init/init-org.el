(setq org-agenda-files (list
			"~/private/doc/gtd/new-gtd.org"
			"~/private/core/journal.org.gpg"
			"~/private/doc/gtd/study.org"
			"~/private/doc/gtd/pp.org"
			"~/private/doc/gtd/work.org"
			"~/private/doc/gtd/ppro.org"))
(setq org-hide-leading-stars t)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cs" 'org-gtd-summary)
(require 'org-gtd-summary)

(add-hook 'org-agenda-mode-hook (lambda ()
				  (delete-other-windows)
				  (set-org-font)))

(add-hook 'org-mode-hook (lambda ()
			   (define-key org-mode-map [(super p)] 'org-priority-up)
			   (define-key org-mode-map [(super meta p)] 'org-priority-down)
			   (set-org-font)))

(local-set-key [(super meta u)] 'org-priority-up)

(defun set-org-font ()
  (interactive)
  (overlay-put (make-overlay (point-min) (point-max) nil nil t)
	       'face '(:family "WenQuanYi Zen Hei Mono")))


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
      '(("t" "Todo" entry (file+headline "~/private/doc/gtd/new-gtd.org" "Inbox")
	 "* TODO %?\n")
	("h" "Homework" entry (file+headline "~/private/doc/gtd/study.org" "Homework")
	 "* TODO %?\n")
	("s" "Study Plan" entry (file+headline "~/private/doc/gtd/study.org" "Plans")
	 "* TODO %?\n")
	("j" "Journal" entry (file+datetree "~/private/core/journal.org.gpg")
	 "* %?")))

;; AGENDA

(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-deadline-warning-days 7)
(setq org-agenda-ndays 1)

(setq org-agenda-custom-commands 
      '(
	("g" "Agenda GTD Summary"
	 org-gtd-summary)
	;; ("u" "Agenda Study" todo "TODO"
	;;  ((org-agenda-files '("~/private/doc/gtd/study.org")))
	;; )
	("u" "Agenda View -> Study"
	 ((agenda
	   ""
	   ((org-agenda-files '("~/private/doc/gtd/study.org"))
	    (org-agenda-ndays 1)))
	  (todo "TODO" ((org-agenda-files '("~/private/doc/gtd/study.org"))))
	  (todo "NEXT" ((org-agenda-files '("~/private/doc/gtd/study.org"))))
	  (todo "WAITING" ((org-agenda-files '("~/private/doc/gtd/study.org"))))
	  (todo "HOLD" ((org-agenda-files '("~/private/doc/gtd/study.org"))))
	  )
	 "")	
	("w" "Agenda View -> Work"
	 ((agenda
	   ""
	   ((org-agenda-files '("~/private/doc/gtd/work.org"))
	    (org-agenda-ndays 3)))
	  (todo "TODO" ((org-agenda-files '("~/private/doc/gtd/work.org"))))
	  (todo "NEXT" ((org-agenda-files '("~/private/doc/gtd/work.org"))))
	  (todo "WAITING" ((org-agenda-files '("~/private/doc/gtd/work.org"))))
	  (todo "HOLD" ((org-agenda-files '("~/private/doc/gtd/work.org"))))
	  )	 
	 "")	
	))

(require 'org-my-exp)
(add-hook 'org-mode-hook (lambda ()
			   (local-unset-key (kbd "s-e"))
			   (local-set-key (kbd "s-e") 'org-my-exp)))

(provide 'init-org)
