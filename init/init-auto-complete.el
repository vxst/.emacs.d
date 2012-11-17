(require 'auto-complete)
(require 'auto-complete-config)
(set-default 'ac-sources
             '(ac-source-dictionary
               ac-source-words-in-buffer
               ac-source-words-in-same-mode-buffers))

(defun my-ac-mode ()
  (auto-complete-mode 1)
  (ac-flyspell-workaround))

(dolist (hook '(
                js2-mode-hook
                html-mode-hook
                php-mode-hook
		emacs-lisp-mode-hook
                less-css-mode-hook
                ))
  (add-hook hook 'my-ac-mode))

(provide 'init-auto-complete)
