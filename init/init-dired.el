(require 'dired-x)

;;;;;;;;;;;;;;;;;;
;;;
;;; ALIAS
;;;
;;;;;;;;;;;;;;;;;;

(defalias 'mkdir 'make-directory)
(defun media()
  (interactive)
  (dired "/media/"))
(defun home()
  (interactive)
  (dired "~"))

;;;;;;;;;;;;;;;;;;
;;;
;;; Keymap
;;;
;;;;;;;;;;;;;;;;;;

(define-key dired-mode-map (kbd "h") 'dired-omit-mode)
(define-key dired-mode-map (kbd "s") 'dired-do-shell-command)
(define-key dired-mode-map (kbd "S") 'dired-shell)
(setq dired-recursive-copies t)
(setq dired-recursive-deletes t)
(setq dired-guess-shell-alist-user
      (list
       (list ".*" "xdg-open * &")))

;;;;;;;;;;;;;;;;;;
;;;
;;; Config
;;;
;;;;;;;;;;;;;;;;;;
(setq delete-by-moving-to-trash t)


;; DiredOmitMode
(setq-default dired-omit-files-p t)
(setq dired-omit-files "^\\.?#\\|^\\..*$")


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
		  (if (equal major-mode 'dired-mode)
                      (dired "..")
                    (if (buffer-file-name)
                        (dired default-directory)
                      (dired "~"))
                    )))

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
                  (call-interactively 'self-insert-command))))))

(require 'dired-filetype-face)
(provide 'init-dired)
;;; init-dired.el ends here
