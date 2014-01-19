(require 'package)
(add-to-list 'package-archives 
             '("marmalade" .
               "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
(defalias 'elpa 'list-packages)
(provide 'init-elpa)
