;; 代码折叠

;; 导出的时候就不必隐藏了。
;; (add-hook 'htmlize-before-hook   'hs-show-all)

;; 依照缩进来折叠代码
(define-key global-map (kbd "C-'") 'zeno-floding)

;;;###autoload
(defun zeno-floding ()
  "floding based on indeneation"
  (interactive)

  (defun get-overlay ()
    (save-excursion
      ;; if at the behind of the overlay
      (if (car (overlays-at (- (point) 1)))
	  (backward-char))
      ;; check if have the overlay
      (my-next-line)
      (back-to-indentation)
      (let ((overlay (car (overlays-at (+ (point) 1)))))
	(if overlay
	    (message "%s" (prin1-to-string (overlay-properties overlay))))
	(if (and
	     overlay
	     (member "zeno-folding" (overlay-properties overlay)))
	    overlay))))

  (defun get-first-line-data()
    (save-excursion
      (while (and
	      (line-string-match-p "^[ \t]*$")
	      (next-line-exists-p))
	(my-next-line))
      (if (line-string-match-p "^[ {\t]*$")
	  (setq first-line-data "{"))
      (if (line-string-match-p "^[ \\(\t]*$")
	  (setq first-line-data "("))
      ))

  (defun get-last-line-data()
    (save-excursion
      (while (and
	      (line-string-match-p "^[ \t]*$")
	      (previous-line-exists-p))
	(previous-line))
      (if (line-string-match-p "^[ }\t]*$")
	  (setq last-line-data "}"))
      (if (line-string-match-p "^[ \\)\t]*$")
	  (setq last-line-data ")"))
      ))

  (defun show ()
    (delete-overlay (get-overlay)))

  (defun hide ()
    (save-excursion
      (let* ((parent-level (get-column))
	     (beg (line-end-position))
	     (end beg)
	     (first-line-data)
	     (last-line-data))
	(my-next-line)
	(get-first-line-data)
	(when (is-child)
	  (while (and (is-child)
		      (search-forward "\n" nil t nil)))
	  (unless (is-child)
	    (previous-line))
	  (setq end (line-end-position))
	  (get-last-line-data)
	  (let ((new-overlay (make-overlay beg end)))
	    (overlay-put new-overlay 'invisible t)
	    (overlay-put new-overlay 'intangible t)
	    (overlay-put new-overlay 'category "zeno-folding")

	    ;; for emacs-lisp-mode
	    (if (and
		 (equal major-mode 'emacs-lisp-mode)
		 (not last-line-data))
		(setq last-line-data ")"))

	    (if first-line-data
		(overlay-put new-overlay 'before-string
			     (concat first-line-data "..."))
	      (overlay-put new-overlay 'before-string "..."))
	    (if last-line-data
		(overlay-put new-overlay 'after-string last-line-data)))))))

  (defun get-column()
    (back-to-indentation)
    (current-column))

  (defun line-string-match-p(regexp)
    (string-match-p regexp
		    (buffer-substring-no-properties
		     (line-beginning-position)
		     (line-end-position))))

  (defun next-line-exists-p()
    (save-excursion
      (search-forward "\n" nil t nil)))

  (defun previous-line-exists-p()
    (save-excursion
      (search-backward "\n" nil t nil)))

  (defun is-child()
    (or (> (get-column) parent-level)
	(line-string-match-p "^[ {}\t]*$")))

  (defun my-next-line()
    (search-forward "\n" nil t nil))

  (if (get-overlay)
      (show)
    (hide)))


(provide 'init-hs)
