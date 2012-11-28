;; GIMP MODE
(unless (boundp 'hippie-expand-try-functions-list)
(setq hippie-expand-try-functions-list '()))

(load "/home/zys/.emacs.d/modes/gimp-mode/gimp-init.el")
(global-set-key "\C-cg" 'gimp-selector)

;; Now you can run the GIMP with `M-x run-gimp'.
;; Alternatively, connect to GIMP server with `M-x gimp-cl-connect'.

;; Type `M-x gimp-help' for help.

(provide 'init-gimp)
