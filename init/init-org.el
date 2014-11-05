(require 'org)
(require 'org-faces)
(require 'org-clock)

(setq org-hide-leading-stars t)
(define-key global-map "\C-ca" 'org-agenda)

(add-hook 'org-mode-hook (lambda ()
			   (define-key org-mode-map [(super p)] 'org-priority-up)
			   (define-key org-mode-map [(super meta p)] 'org-priority-down)
			   (setq truncate-lines nil) ;; 强制换行
			   (set-org-font)))

(local-set-key [(super meta p)] 'org-priority-down)
(local-set-key [(super p)] 'org-priority-up)

(setq org-global-properties
      (quote (("COLUMNS" . "%38ITEM(Item)  %7TODO(Status) %5Effort(Estimates){:} %5CLOCKSUM_T(Clock){Total}"))))

(defun set-org-font ()
  (interactive)
  (overlay-put (make-overlay (point-min) (point-max) nil nil t)
	       'face '(:family "WenQuanYi Zen Hei Mono")))

(defun zeno-org-agenda-columns ()
  (interactive)
  (dolist (org-agenda-file org-agenda-files)
    (switch-to-buffer (find-file-noselect org-agenda-file))
    (org-clock-sum-today))
  (switch-to-buffer "*Org Agenda*")
  (org-agenda-columns))

(setq org-log-done 'time)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "DOING(o)" "|")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")
	      (sequence "REPORT(r)" "BUG(b)" "|" "FIXED(e)")
	      (sequence "TRY(y)" "|"  "FAILED(f@/!)" ))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "orange red" :weight bold)
              ("NEXT" :foreground "deepskyblue" :weight bold)
              ("DOING" :foreground "skyblue" :weight bold)
              ("DONE" :foreground "LawnGreen" :weight bold)
              ("WAITING" :foreground "tomato" :weight bold)
              ("HOLD" :foreground "deep pink" :weight bold)
              ("CANCELLED" :foreground "gray" :weight bold)
	      ("FAILED" :foreground "dark grey" :weight bold))))


;; AGENDA

(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-deadline-warning-days 7)
(setq org-agenda-ndays 7)

(add-hook 'org-agenda-mode-hook
	  (lambda ()
	    (local-set-key [(super t)] 'org-agenda-todo-yesterday)))


(provide 'init-org)
