(setq org-agenda-files (list  "~/org/mobileorg/index.org" "~/org/life.org"))
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

;; Org Bible

;; active Babel languages
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((R . t)
;;    (emacs-lisp . t)
;;    (scheme . t)
;;    ))


;; Org Export Generic
(require 'org-export-generic)

(org-set-generic-type
 "really-basic-text" 
 '(:file-suffix     ".txt"
   :key-binding     ?R
   :title-format "=== %s ===\n"
   :body-header-section-numbers t
   :body-header-section-number-format "%s) "
   :body-section-header-prefix  "\n"
   :body-section-header-suffix "\n"
   :body-line-format "  %s\n"
   :body-line-wrap   75
   ))

(provide 'init-org)
