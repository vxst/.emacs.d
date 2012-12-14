;; Time-stamp: <2012-12-14 11:29:36 Zeno Zeng>

(add-to-list 'load-path "~/.emacs.d/init")
(add-to-list 'load-path "~/.emacs.d/plugins")
(add-to-list 'load-path "~/.emacs.d/plugins/less-css-mode")
(add-to-list 'load-path "~/.emacs.d/plugins/js3-mode")
(add-to-list 'load-path "~/.emacs.d/plugins/emms-3.0")
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-1.4")
(add-to-list 'load-path "~/.emacs.d/elpa/php+-mode-20121004.1439")
(add-to-list 'load-path "~/.emacs.d/elpa/popup-0.5")
(add-to-list 'load-path "~/.emacs.d/elpa/gitty-1.0")
(add-to-list 'load-path "~/.emacs.d/plugins/emacs-w3m")
(add-to-list 'load-path "~/.emacs.d/plugins/o-bloger")
(add-to-list 'load-path "~/.emacs.d/elpa/undo-tree-0.5.4")
(add-to-list 'load-path "~/.emacs.d/elpa/org-20120903")

(require 'init-ui)
(require 'init-personal)
(require 'init-functions)

(require 'init-gimp)
(require 'init-js)
(require 'init-css)
(require 'init-php)
(require 'init-markdown)
(require 'init-html)
(require 'init-lisp)

(require 'init-elpa)
(require 'init-elget)
(require 'init-hs)
(require 'init-auto-complete)
(require 'init-backup)
(require 'init-vc)
(require 'init-dired)
(require 'init-shell)

(require 'init-w3m)
(require 'init-emms)
(require 'init-org)


(require 'init-etc)



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#000" :foreground "#fff" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "Source Code Pro"))))
 '(font-lock-comment-delimiter-face ((t (:inherit font-lock-comment-face))))
 '(font-lock-comment-face ((t (:background "#111" :foreground "#999" :height 1.0))))
 '(font-lock-constant-face ((t (:foreground "#20b2aa"))))
 '(font-lock-keyword-face ((t (:foreground "#f00"))))
 '(fringe ((t (:background "#000"))))
 '(header-line ((t (:background "#000" :foreground "#333"))))
 '(hl-paren-face ((t (:weight bold))) t)
 '(js3-private-function-call-face ((t (:foreground "firebrick"))))
 '(mode-line ((t (:background "#000" :foreground "#999" :box (:line-width 1 :color "#999") :height 0.75))))
 '(mode-line-highlight ((t (:box (:line-width 2 :color "grey40" :style released-button) :height 0.6))))
 '(mode-line-inactive ((t (:inherit mode-line :background "#000" :foreground "#333"))))
 '(org-clock-overlay ((t (:background "#000"))))
 '(org-level-1 ((t (:inherit outline-1))))
 '(org-level-4 ((t (:background "black" :foreground "hot pink"))))
 '(region ((t (:background "#333" :foreground "#fff"))))
 '(secondary-selection ((t (:background "#111")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(chm-view-delay 1)
 '(emms-cache-get-function (quote emms-cache-get))
 '(emms-cache-modified-function (quote emms-cache-dirty))
 '(emms-cache-set-function (quote emms-cache-set))
 '(emms-player-next-function (quote emms-next))
 '(emms-playlist-default-major-mode (quote emms-playlist-mode))
 '(emms-playlist-update-track-function (quote emms-playlist-mode-update-track-function))
 '(emms-repeat-playlist t)
 '(emms-track-description-function (quote emms-info-track-description))
 '(emms-track-initialize-functions (quote (emms-info-initialize-track)))
 '(golden-ratio-exclude-modes (quote ("shell-mode" "calendar-mode" "gud-mode" "ediff-mode" "eshell-mode" "help-mode" "org-mode")))
 '(hl-paren-colors (quote ("#f00" "#ff0" "#0f0" "#00ced1" "#9400d3")))
 '(js3-allow-member-expr-as-function-name t)
 '(js3-auto-indent-p t)
 '(js3-consistent-level-indent-inner-bracket t)
 '(js3-curly-indent-offset 2)
 '(js3-enter-indents-newline t)
 '(js3-global-externs (quote ("$" "localStorage" "JSON" "setInterval" "clearInterval" "setTimeout" "console")))
 '(js3-indent-level 2)
 '(js3-indent-on-enter-key t)
 '(less-css-compile-at-save t)
 '(less-css-lessc-options (list "-x"))
 '(org-agenda-span (quote month))
 '(org-clock-out-remove-zero-time-clocks t)
 '(sml/show-battery nil)
 '(sml/show-client t)
 '(sml/show-time t)
 '(tags-table-list (quote ("~/src/emacs-24.1/lisp/TAGS"))))
