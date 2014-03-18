(dolist (hook '(clojure-mode-hook emacs-lisp-mode-hook scheme-mode-hook))
  (add-hook hook
            (lambda ()
              (paredit-mode))))

(provide 'init-paredit)
