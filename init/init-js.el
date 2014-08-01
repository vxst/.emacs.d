(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.pac$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))

(defalias 'js 'nodejs-repl)
(provide 'init-js)
