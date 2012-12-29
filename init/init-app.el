(defun my-async-shell-command (cmd)
  (let* ((buffer-name (format-time-string "*buffer-to-hide-%s*")))
    (async-shell-command cmd buffer-name nil)
    (delete-windows-on buffer-name nil)
    (add-to-list 'ido-ignore-buffers buffer-name)))

(defun chrome ()
  "open google-chrome with shell-command"
  (interactive)
  (my-async-shell-command "google-chrome"))

(defun gimp ()
  "open gimp with shell-command"
  (interactive)
  (my-async-shell-command "gimp"))


;; create a hash table
(setq apps-hash (make-hash-table :test 'equal))
(puthash "\\.xcf$" "gimp " apps-hash)
(puthash "\\.pdf$" "evince " apps-hash)

;; 覆盖定义
(defun dired-find-file ()
  "In Dired, visit the file or directory named on this line."
  (interactive)
  ;; Bind `find-file-run-dired' so that the command works on directories
  ;; too, independent of the user's setting.
  (let* ((find-file-run-dired t)
	 (file (dired-get-file-for-visit))
	 (use-app nil))
    (maphash (lambda (k v)
	       (when (string-match-p k file)
		 (my-async-shell-command (concat v file))
		 (setq use-app t)))
	     apps-hash)
    (unless use-app
      (find-file file))))


(provide 'init-app)
