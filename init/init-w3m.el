;;; w3m
(require 'w3m)
;;设置w3m为emacs的默认浏览器
(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(global-set-key "\C-xm" 'browse-url-at-point)

(provide 'init-w3m)
