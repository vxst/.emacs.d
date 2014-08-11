;; Time-stamp: <2014-08-11 21:32:25 Zeno Zeng>

;; (add-to-list 'load-path "~/code/org-gtd-summary")
(add-to-list 'load-path "~/code/yafolding.el/")
;; (add-to-list 'load-path "~/code/candy-script-mode")
(add-to-list 'load-path "~/.emacs.d/init")
(add-to-list 'load-path "~/.emacs.d/plugins")
(add-to-list 'load-path "~/.emacs.d/plugins/less-css-mode")
(add-to-list 'load-path "~/.emacs.d/plugins/js3-mode")
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-1.4")
(add-to-list 'load-path "~/.emacs.d/elpa/popup-0.5")
(add-to-list 'load-path "~/.emacs.d/elpa/gitty-1.0")
(add-to-list 'load-path "~/.emacs.d/plugins/emacs-w3m")
(add-to-list 'load-path "~/.emacs.d/elpa/undo-tree-0.5.4")
(add-to-list 'load-path "~/.emacs.d/elpa/org-20121231")
(add-to-list 'load-path "~/.emacs.d/elpa/smart-mode-line-20130421.1855")
(add-to-list 'load-path "~/.emacs.d/elpa/slime-20130929.1345")
(add-to-list 'load-path "~/.emacs.d/elpa/slime-js-0.0.1")
(add-to-list 'load-path "~/.emacs.d/elpa/slime-repl-20100404")
(add-to-list 'load-path "~/.emacs.d/elpa/web-mode-20131009.12")


(require 'moz)

(require 'init-ui)
(require 'init-personal)
(require 'init-functions)
(require 'init-file)

(require 'init-tramp)

(require 'init-move)

                                        ; (require 'init-gimp)
(require 'init-js)
(require 'init-css)
(require 'init-php)
(require 'init-R)
(require 'init-c)
(require 'init-markdown)
(require 'init-html)
(require 'init-lisp)
;; (require 'init-candy)

(require 'init-elpa)

(require 'init-folding)
(require 'init-auto-complete)
(require 'init-paredit)
(require 'init-backup)
(require 'init-vc)
(require 'init-dired)
(require 'init-shell)
;; sth
(require 'init-w3m)
(require 'init-moz)
(require 'init-org)
(require 'init-blog)

(require 'init-snippet)

(require 'init-multiple-cursors)

(require 'init-gpg)
(require 'init-alias)
(require 'init-whitespace)
(require 'init-check)
(require 'init-git)
(require 'init-etc)

(global-set-key "\M-\C-y" 'kill-ring-search)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(desktop-save-mode 1)
(setq desktop-buffers-not-to-save
      (concat "\\("
              "^nn\\.a[0-9]+\\|\\.log\\|(ftp)\\|^tags\\|^TAGS"
              "\\|\\.emacs.*\\|\\.diary\\|\\.newsrc-dribble\\|\\.bbdb"
              "\\)$"))
(add-to-list 'desktop-modes-not-to-save 'dired-mode)
(add-to-list 'desktop-modes-not-to-save 'Info-mode)
(add-to-list 'desktop-modes-not-to-save 'info-lookup-mode)
(add-to-list 'desktop-modes-not-to-save 'fundamental-mode)
