(require 'dired-x)
(require 'dired-single)

;;;;;;;;;;;;;;;;;;
;;;
;;; ALIAS
;;;
;;;;;;;;;;;;;;;;;;

(defalias 'mkdir 'make-directory)
(defalias 'mnt 'media)
(defalias 'usb 'media)

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
(define-key dired-mode-map (kbd "U")
  (lambda()
    (interactive)
    (dired-do-shell-command "gnome-terminal -x sudo umount * ")))
(define-key dired-mode-map (kbd "C-i") 'dired-umonut-device)


(setq dired-recursive-copies t)
(setq dired-recursive-deletes t)
(setq dired-guess-shell-alist-user
      (list
       (list "\\.tar\\.bz2$" "tar jxvf * &")
       '("\\.xcf$" "gimp * &")
       '("\\.tar\\.gz$" "tar zxvf * &")
       '("\\.chm$" "chmsee * &")
       '("\\.tar$" "tar xvvf * &")
       '("\\.ps$" "gv * &")
       '("\\.html?$" "firefox * &" "urxvt -e w3m * &")
       '("\\.pdf$" "acroread * &" "evince * &")
       '("\\.\\(jpe?g\\|gif\\|png\\|bmp\\|xbm\\|xpm\\|fig\\|eps\\)$" "gthumb * &" "gqview * &" "display * &" "xloadimage * &" )
       '("\\.\\([Ww][Mm][Vv]\\|[Vv][Oo][Bb]\\|[Mm][Pp][Ee]?[Gg]\\|asf\\|[Rr][Aa]?[Mm]\\)$" "mplayer * &")
       '("\\.rmvb$" "mplayer * &")
       '("\\.RMVB$" "mplayer * &")
       ))

;; TODO: debian 设置 自动挂载 （udev)
;; TODO: emacs 里设置 umount
;; TODO: d -> put to trash instead of rm

;; (defun mount()
;;   ;; 挂载当前所指向的设备
;;   (interactive)
;;   ())
;; (defun umount()
;;   ;; 卸载当前所指向的设备
;;   (interactive)
;;   ())


;; DiredOmitMode
(setq-default dired-omit-files-p t)
(setq dired-omit-files "^\\.?#\\|^session\\.\\|^\\..*$")


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

;; Make dired less verbose
;; (require 'dired-details)
;; (setq-default dired-details-hidden-string "--- ")
;; (dired-details-install)

(require 'dired-filetype-face)
(provide 'init-dired)
;;; init-dired.el ends here
