(defalias 'mkdir 'make-directory)

;;; Tired of seeing stale dired buffers?
;; Auto refresh buffers
(global-auto-revert-mode 1)
;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

;; C-x C-j open the directory of current buffer
(global-set-key (kbd "C-x C-j")
		(lambda ()
		  (interactive)
		  (if (buffer-file-name)
		      (dired default-directory))
		  ;; 如果实在dired-mode，直接返回上级目录
		  (when (equal major-mode 'dired-mode)
		    (dired "..")
		    )
		  ))


;; Make dired less verbose
(require 'dired-details)
(setq-default dired-details-hidden-string "--- ")
(dired-details-install)

(require 'dired-filetype-face)
(provide 'init-dired)
;;; init-dired.el ends here
