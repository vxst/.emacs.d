;; Capture
;; (setq org-capture-templates
;;       '(("t" "Todo" entry (file+headline "~/private/doc/gtd/new-gtd.org" "Inbox")
;; 	 "* TODO %?\n")
;; 	("h" "Homework" entry (file+headline "~/private/doc/gtd/study.org" "Homework")
;; 	 "* TODO %?\n")
;; 	("s" "Study Plan" entry (file+headline "~/private/doc/gtd/study.org" "Plans")
;; 	 "* TODO %?\n")
;; 	("j" "Journal" entry (file+datetree "~/private/core/journal.org.gpg")
;; 	 "* %?")
;; 	("r" "Journal" entry (file+datetree "~/private/log/reading.org")
;; 	 "* %?")
;;         ))

(setq org-agenda-custom-commands 
      '(
	;; ("g" "Agenda GTD Summary"
	;;  org-gtd-summary)
	;; ("6" "Agenda GTD Summary 60 days"
	;;  org-gtd-summary-60-days)
	;; ("u" "Agenda Study" todo "TODO"
	;;  ((org-agenda-files '("~/private/doc/gtd/study.org")))
	;; )
	;; ("u" "Agenda View -> Study"
	;;  ((agenda
	;;    ""
	;;    ((org-agenda-files '("~/private/doc/gtd/study.org"))
	;;     (org-agenda-ndays 1)))
	;;   (todo "TODO" ((org-agenda-files '("~/private/doc/gtd/study.org"))))
	;;   (todo "NEXT" ((org-agenda-files '("~/private/doc/gtd/study.org"))))
	;;   (todo "WAITING" ((org-agenda-files '("~/private/doc/gtd/study.org"))))
	;;   (todo "HOLD" ((org-agenda-files '("~/private/doc/gtd/study.org"))))
	;;   )
	;;  "")	
	;; ("P" "Agenda View -> Physical Plan"
	;;  ((agenda
	;;    ""
	;;    ((org-agenda-files '("~/private/doc/gtd/pp.org"))
	;;     (org-agenda-ndays 1)))
	;;   (todo "TODO" ((org-agenda-files '("~/private/doc/gtd/pp.org"))))
	;;   (todo "NEXT" ((org-agenda-files '("~/private/doc/gtd/pp.org"))))
	;;   (todo "WAITING" ((org-agenda-files '("~/private/doc/gtd/pp.org"))))
	;;   (todo "HOLD" ((org-agenda-files '("~/private/doc/gtd/pp.org"))))
	;;   )
	;;  "")	
	;; ("p" "Agenda View -> Personal Programming"
	;;  ((agenda
	;;    ""
	;;    ((org-agenda-files '("~/private/doc/gtd/ppro.org"))
	;;     (org-agenda-ndays 1)))
	;;   (todo "BUG" ((org-agenda-files '("~/private/doc/gtd/ppro.org"))))
	;;   (todo "TODO" ((org-agenda-files '("~/private/doc/gtd/ppro.org"))))
	;;   (todo "NEXT" ((org-agenda-files '("~/private/doc/gtd/ppro.org"))))
	;;   (todo "WAITING" ((org-agenda-files '("~/private/doc/gtd/ppro.org"))))
	;;   (todo "HOLD" ((org-agenda-files '("~/private/doc/gtd/ppro.org"))))
	;;   )
	;;  "")	
	;; ("w" "Agenda View -> Work"
	;;  ((agenda
	;;    ""
	;;    ((org-agenda-files '("~/private/doc/gtd/work.org"))
	;;     (org-agenda-ndays 3)))
	;;   (todo "BUG" ((org-agenda-files '("~/private/doc/gtd/work.org"))))
	;;   (todo "TODO" ((org-agenda-files '("~/private/doc/gtd/work.org"))))
	;;   (todo "NEXT" ((org-agenda-files '("~/private/doc/gtd/work.org"))))
	;;   (todo "WAITING" ((org-agenda-files '("~/private/doc/gtd/work.org"))))
	;;   (todo "HOLD" ((org-agenda-files '("~/private/doc/gtd/work.org"))))
	;;   )	 
	;;  "")	
	))
;; (define-key global-map "\C-cs" 'org-gtd-summary)
;; (require 'org-gtd-summary)

(add-hook 'org-agenda-mode-hook
	  (lambda ()
	    (local-set-key [remap org-agenda-columns] 'zeno-org-agenda-columns)
            ;;	    (delete-other-windows)
	    (set-org-font)))

(org-add-agenda-custom-command
 '("d" "Today've Done"
   (
    (todo "DONE"
	  ((org-agenda-skip-function '(org-agenda-skip-subtree-if
				       'notregexp
				       (format-time-string "%Y-%m-%d")))
	   (org-agenda-overriding-header "CLOSED TODAY: ")
	   (org-agenda-todo-keyword-format "")))
    (todo "TODO"
	  ((org-agenda-skip-function '(org-agenda-skip-subtree-if
				       'notregexp
				       (format-time-string "State \"DONE\"       from \"TODO\"       \\[%Y-%m-%d")))
	   (org-agenda-overriding-header "DONE TODAY: ")
	   (org-agenda-todo-keyword-format "")))
    )
   ))
(require 'org-my-exp)
(add-hook 'org-mode-hook (lambda ()
			   (local-unset-key (kbd "s-e"))
			   (local-set-key (kbd "s-e") 'org-my-exp)))

;; Org 2 Markdown
;; by alexhenning, I modified some of the code
;; In the org file you want to export type C-c C-e g M

(load "~/.emacs.d/plugins/org-export-generic.el")

(org-set-generic-type
 "Markdown" 
 '(:file-suffix ".markdown"
		:key-binding ?M
		:title-format "%s\n"
		:title-suffix ?=
		:body-header-section-numbers t
		:body-header-section-number-format "%s) "
		:body-section-header-prefix	("\n## " "\n### " "\n#### " "\n##### " "\n###### ")
		:body-section-header-format	"%s"
		:body-section-header-suffix "\n"
		:todo-keywords-export t
		:body-line-format "  %s\n"
		:body-tags-export	t
		:body-tags-prefix	" <tags>"
		:body-tags-suffix	"</tags>\n"
		;;:body-section-prefix	"<secprefix>\n"
		;;:body-section-suffix	"</secsuffix>\n"
		:body-line-export-preformated	t
		:body-line-fixed-prefix	"<pre>\n"
		:body-line-fixed-suffix	"\n</pre>\n"
		:body-line-fixed-format	"%s\n"
		:body-list-prefix	"\n"
		:body-list-suffix	"\n"
		:body-list-format	"  * %s\n"
		;;:body-number-list-prefix	"<ol>\n"
		;;:body-number-list-suffix	"</ol>\n"
		;;:body-number-list-format	"<li>%s</li>\n"
		;;:body-number-list-leave-number	t
		:body-list-checkbox-todo	"[_] "
		:body-list-checkbox-todo-end	""
		:body-list-checkbox-done	"[X] "
		:body-list-checkbox-done-end ""
		:body-line-format	"%s"
		:body-line-wrap	75
		:body-text-prefix	""
		:body-text-suffix	""
		))



;;#+BEGIN: clocktable :maxlevel 4 :scope agenda  :tstart "<2013-01-24 四 00:00>"  :tend "<2013-02-25 一 00:00>"
