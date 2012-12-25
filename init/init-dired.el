(defalias 'mkdir 'make-directory)

;;; Tired of seeing stale dired buffers?
;; Auto refresh buffers
(global-auto-revert-mode 1)
;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

(require 'dired-filetype-face)
(provide 'init-dired)
;;; init-dired.el ends here
