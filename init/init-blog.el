;;htmlize
(require 'htmlize)

;; Jekyll
(global-set-key [f12] 'org2jekyll)
(defun org2jekyll()
  (interactive)
  (let* ((file (replace-regexp-in-string
	       "\\.org" ".html"
	       (buffer-file-name)))
	 (file (file-name-nondirectory file))
	 (file (concat "../_posts/" file))
	 (title (org2jekyll-get-header "title"))
	 (layout (org2jekyll-get-header "layout"))
	 (tags (org2jekyll-get-header "tags"))
	 (header-yaml "---\n")
	 )
    (org-export-as-html 5 nil "*Jekyll*" t)
    (switch-to-buffer "*Jekyll*")
    (message "Jekyll")
    (goto-char (point-min))
    (if title
	(setq header-yaml (concat header-yaml "title: " title "\n")))
    (when tags
      (setq header-yaml (concat header-yaml "tags: " "\n"))
      (setq tags (split-string tags ","))
      (dolist (tag tags)
	(setq tag (replace-regexp-in-string " " "" tag))
	(setq header-yaml (concat header-yaml "    - " tag "\n"))))
    (if layout
	(setq header-yaml (concat header-yaml "layout: " layout "\n"))
      (setq header-yaml (concat header-yaml "layout: default\n")))
    (setq header-yaml (concat header-yaml "---\n\n"))
    (insert header-yaml)
    (write-file file nil)
    ))
(defun org2jekyll-get-header (header)
  (let (values)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward (format "^#\\+%s:?[ \t]+\\(.*\\)" header) nil t)
	(add-to-list 'values (substring-no-properties (match-string 1)))))
    (car values)))


(provide 'init-blog)
