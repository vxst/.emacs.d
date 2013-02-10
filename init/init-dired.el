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
		  ;; 如果在dired-mode，直接返回上级目录
		  (when (equal major-mode 'dired-mode)
		    (dired ".."))
		  (if (buffer-file-name)
		      (dired default-directory))
		  ))

;; just press ~ to go home. 
(add-hook 'ido-setup-hook
 (lambda ()
   ;; Go straight home
   (define-key ido-file-completion-map
     (kbd "~")
     (lambda ()
       (interactive)
       (if (looking-back "/")
           (insert "~/")
         (call-interactively 'self-insert-command)))))

;; Make dired less verbose
(require 'dired-details)
(setq-default dired-details-hidden-string "--- ")
(dired-details-install)

(require 'dired-filetype-face)
(provide 'init-dired)
;;; init-dired.el ends here
