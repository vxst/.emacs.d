(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)

(global-set-key (kbd "s-e") 'my-eval-buffer)
(defun my-eval-buffer ()
  (interactive)
  (if (eq major-mode 'scheme-mode)
      (scheme-send-region (point-min) (point-max))
    (eval-buffer)))


(global-set-key [f8] 'my-run-scheme)
(defun my-run-scheme ()
  (interactive)
  (if (get-buffer "*scheme*")
      (switch-to-buffer "*scheme*")
    (progn
      (run-scheme "guile")
      (switch-to-buffer (find-file-noselect "~/git/scheme/math.scm"))
      (scheme-send-region (point-min) (point-max))
      (switch-to-buffer "*scheme*"))))

;; scheme
;; apt-get install guile-2.0
;; C-c C-r runs the command scheme-send-region
(setq scheme-program-name "guile")


(provide 'init-lisp)
