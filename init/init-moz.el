(require 'moz)
(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)

(add-hook 'javascript-mode-hook 'javascript-custom-setup)
(defun javascript-custom-setup ()
  (moz-minor-mode 1))

(defalias 'mozg 'moz-reload-global-mode)
(defalias 'mozr 'moz-reload-mode)
(defalias 'mozl 'moz-reload-lesscss-mode)

;;; Usage
;; Run M-x moz-reload-mode to switch moz-reload on/off in the
;; current buffer.
;; When active, every change in the buffer triggers Firefox
;; to reload its current page.

(defun mozs()
  (interactive)
  (call-interactively 'run-mozilla)
  (comint-send-string (inferior-moz-process) ";")
  (comint-send-string (inferior-moz-process) "repl.whereAmI(); repl.look(); content"))

;; use content.window content.documnet / document content.location


(define-minor-mode moz-reload-lesscss-mode
  "Moz Reload Minor Mode"
  nil " MozLess" nil
  (if moz-reload-lesscss-mode
      ;; Edit hook buffer-locally.
      (add-hook 'after-save-hook 'moz-lesscss-reload nil t)
    (remove-hook 'after-save-hook 'moz-lesscss-reload t)))

(define-minor-mode moz-reload-mode
  "Moz Reload Minor Mode"
  nil " Reload" nil
  (if moz-reload-mode
      ;; Edit hook buffer-locally.
      (add-hook 'post-command-hook 'moz-reload nil t)
    (remove-hook 'post-command-hook 'moz-reload t)))

(defun moz-reload ()
  (when (buffer-modified-p)
    (save-buffer)
    (moz-firefox-reload)))

(defun moz-lesscss-reload ()
  (interactive)
  (run-at-time .3 nil 'moz-firefox-reload))

(defun moz-firefox-reload ()
  ;; 强行停止之前的进程
  (comint-send-string (inferior-moz-process) ";")
  (comint-send-string (inferior-moz-process) "content.location.reload()"))

(provide 'init-moz)
