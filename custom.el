
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(chm-view-delay 1)
 '(coffee-tab-width 4)
 '(emms-cache-get-function (quote emms-cache-get))
 '(emms-cache-modified-function (quote emms-cache-dirty))
 '(emms-cache-set-function (quote emms-cache-set))
 '(emms-playlist-default-major-mode (quote emms-playlist-mode))
 '(emms-playlist-update-track-function (quote emms-playlist-mode-update-track-function))
 '(emms-repeat-playlist t)
 '(emms-track-description-function (quote emms-info-track-description))
 '(emms-track-initialize-functions (quote (emms-info-initialize-track)))
 '(golden-ratio-exclude-modes
   (quote
    ("shell-mode" "calendar-mode" "gud-mode" "ediff-mode" "eshell-mode" "help-mode" "org-mode")))
 '(haskell-mode-hook (quote (turn-on-haskell-doc turn-on-haskell-indent)))
 '(hl-paren-colors (quote ("#f00" "#ff0" "#0f0" "#00ced1" "#9400d3")))
 '(indent-tabs-mode nil)
 '(js2-bounce-indent-p nil)
 '(js2-indent-switch-body t)
 '(js2-strict-inconsistent-return-warning nil)
 '(js2-strict-missing-semi-warning t)
 '(js3-allow-member-expr-as-function-name t)
 '(js3-auto-indent-p t)
 '(js3-consistent-level-indent-inner-bracket t)
 '(js3-curly-indent-offset 2)
 '(js3-enter-indents-newline t)
 '(js3-global-externs
   (quote
    ("$" "localStorage" "JSON" "setInterval" "clearInterval" "setTimeout" "console")))
 '(js3-indent-level 2)
 '(js3-indent-on-enter-key t)
 '(less-css-lessc-options (list "-x"))
 '(message-log-max 1000)
 '(org-agenda-files (quote ("~/work/ali/udata/udata.org")))
 '(org-agenda-log-mode-items (quote (closed clock state)))
 '(org-agenda-menu-two-columns t)
 '(org-agenda-move-date-from-past-immediately-to-today nil)
 '(org-agenda-skip-deadline-prewarning-if-scheduled 0)
 '(org-agenda-span (quote day))
 '(org-agenda-start-with-clockreport-mode t)
 '(org-clock-out-remove-zero-time-clocks t)
 '(org-default-priority 67)
 '(org-extend-today-until 0)
 '(org-use-effective-time t)
 '(safe-local-variable-values
   (quote
    ((eval when
           (and
            (buffer-file-name)
            (file-regular-p
             (buffer-file-name))
            (string-match-p "^[^.]"
                            (buffer-file-name)))
           (emacs-lisp-mode)
           (when
               (fboundp
                (quote flycheck-mode))
             (flycheck-mode -1))
           (unless
               (featurep
                (quote package-build))
             (let
                 ((load-path
                   (cons ".." load-path)))
               (require
                (quote package-build))))
           (package-build-minor-mode)))))
 '(scss-compile-at-save nil)
 '(sgml-basic-offset 4)
 '(show-trailing-whitespace t)
 '(sml/battery-format " ")
 '(sml/show-battery t)
 '(sml/show-client t)
 '(sml/show-time nil)
 '(tags-table-list (quote ("~/src/emacs-24.1/lisp/TAGS")))
 '(web-mode-code-indent-offset 4)
 '(web-mode-css-indent-offset 4)
 '(web-mode-disable-auto-indentation t)
 '(web-mode-enable-block-face t)
 '(web-mode-enable-current-element-highlight t)
 '(web-mode-enable-heredoc-fontification t)
 '(web-mode-enable-part-face t)
 '(web-mode-markup-indent-offset 4))
(put 'narrow-to-region 'disabled nil)



;; (string 15 0)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#000" :foreground "#fff" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :width normal :foundry "unknown" :family "Source Code Pro"))))
 '(candy-script-title-1 ((t (:inherit info-title-1))))
 '(emms-lyrics-minibuffer-face ((t (:foreground "green yellow" :height 300))))
 '(error ((t (:foreground "Red" :weight bold))))
 '(font-lock-comment-delimiter-face ((t (:inherit font-lock-comment-face))))
 '(font-lock-comment-face ((t (:foreground "#999" :height 1.0))))
 '(font-lock-constant-face ((t (:foreground "#20b2aa"))))
 '(font-lock-keyword-face ((t (:foreground "#f00"))))
 '(fringe ((t (:background "#000"))))
 '(header-line ((t (:background "#000" :foreground "#333"))))
 '(highlight-indentation-current-column-face ((t (:foreground "#B22222" :stipple (8 1 " ")))))
 '(highlight-indentation-face ((t (:foreground "#333" :stipple (8 1 " ")))))
 '(hl-paren-face ((t (:weight bold))) t)
 '(js3-private-function-call-face ((t (:foreground "firebrick"))))
 '(mode-line ((t (:background "#000" :foreground "#999" :box (:line-width 1 :color "#999") :height 0.75))))
 '(mode-line-highlight ((t (:box (:line-width 2 :color "#000" :style released-button) :height 0.6))))
 '(mode-line-inactive ((t (:inherit mode-line :background "#010101" :foreground "#999"))))
 '(org-clock-overlay ((t (:background "#000"))))
 '(org-column ((t (:background "black" :strike-through nil :underline nil :slant normal :weight normal :height 120 :family "WenQuanYi Zen Hei Mono"))))
 '(org-column-title ((t (:inherit org-column :background "black" :foreground "white"))))
 '(org-level-1 ((t (:inherit outline-1))))
 '(org-level-4 ((t (:background "black" :foreground "hot pink"))))
 '(org-todo ((t (:foreground "red" :weight bold))))
 '(org-warning ((t (:foreground "red" :weight bold))))
 '(region ((t (:background "#333" :foreground "#fff"))))
 '(secondary-selection ((t (:background "#111"))))
 '(yafolding-ellipsis-face ((t nil)) t))
