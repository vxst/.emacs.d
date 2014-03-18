(require 'paredit)

(dolist (hook '(clojure-mode-hook
                emacs-lisp-mode-hook
                scheme-mode-hook))
  (add-hook hook
            (lambda ()
              (paredit-mode 1))))

(define-key paredit-mode-map (kbd "C-9") 'paredit-wrap-round)

(provide 'init-paredit)
