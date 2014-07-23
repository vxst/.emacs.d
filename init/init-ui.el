(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;;; UI
;; 关闭Emacs启动时提示信息
(setq inhibit-startup-message t)

;; 关闭蜂鸣提示音
(setq ring-bell-function 'ignore)

;; 各种bar
(blink-cursor-mode -1)
;; (menu-bar-mode (quote toggle))
;;; Modeline
;; 电池
;; (setq battery-mode-line-format "%b%p%")
;; (display-battery-mode)
;; ;; 时间
;; (setq display-time-24hr-format t)
;; (setq display-time-day-and-date t)
;; (setq display-time-format " %m-%d %a %H:%M")
;; 不要显示load average
;; (setq display-time-load-average-threshold 100)
;; (display-time)
;; (setq display-time-24hr-format t)
;; (setq column-number-mode t)
;; (setq line-number-mode t)
;; 标题栏
(setq frame-title-format "%f")
;; bu显示匹配括号
(show-paren-mode nil)
;; 匹配括号时不跳至另一括号
;;(setq show-paren-style 'parentheses)
;; "yes or no" =>  "y or n"
(fset 'yes-or-no-p 'y-or-n-p)
;; 高亮显示mark
(transient-mark-mode t)
;; 开启语法高亮。
(global-font-lock-mode 1)
;; 开启 ido mode
(ido-mode nil)
(global-set-key "\C-xk" (lambda ()
                          (interactive)
                          (kill-buffer (buffer-name))))

;; highlight-parentheses
(require 'highlight-parentheses)
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

;; 光标靠近鼠标指针时，让鼠标指针自动让开，别挡住视线。
(mouse-avoidance-mode 'animate)


;; 黄金比例显示当前窗口
(require 'golden-ratio)
(setq golden-ratio-exclude-modes '("calendar-mode"
                                   "gud-mode"
                                   "ediff-mode"
                                   "eshell-mode"))
(setq golden-ratio-exclude-buffer-names
      '(" *org tags*"
        " *Org todo*"))
(golden-ratio-enable)

;; SmartMode Line
(require 'smart-mode-line)
(sml/setup)
(add-to-list 'sml/replacer-regexp-list '("^~/Dropbox/Projects/In-Development/" ":ProjDev:"))
(add-to-list 'sml/replacer-regexp-list '("^~/Documents/Work/" ":Work:"))

;; Added in the right order, they even work sequentially:
(add-to-list 'sml/replacer-regexp-list '("^:DB:Documents" ":DDocs:"))
(add-to-list 'sml/replacer-regexp-list '("^~/Dropbox/" ":DB:"))
(add-to-list 'sml/replacer-regexp-list '("^~/Git-Projects/" ":Git:"))
(add-to-list 'sml/replacer-regexp-list '("^:Git:\\(.*\\)/src/main/java/" ":G/\\1/SMJ:"))

;; Show line numbers temporarily, while prompting for the line number input
(global-set-key [remap goto-line] 'goto-line-with-feedback)
(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (goto-line (read-number "Goto line: ")))
    (linum-mode -1)))

;; 这些设置是在X下的frame创建时才有效的，而启动服务器的时候是没有创建frame的。
(defun frame-setting()
  ;; 确保不显示额外的信息在modeline
  (setq global-mode-string '("" ""))
  (set-cursor-color "#fff")
  (set-mouse-color "#fff")
  ;; (set-face-attribute 'default nil
  ;;                     :family "WenQuanYi Zen Hei Mono"
  ;;                     :height 120)
  ;; (set-fontset-font t 'han (font-spec :family "WenQuanYi Zen Hei Mono"))
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(default ((t (:inherit nil :stipple nil :background "#000" :foreground "#fff" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :width normal :foundry "unknown" :family "M+ 1mn regular"))))
   '(emms-lyrics-minibuffer-face ((t (:foreground "green yellow" :height 300))))
   '(font-lock-comment-delimiter-face ((t (:inherit font-lock-comment-face))))
   '(font-lock-comment-face ((t (:foreground "#999" :height 1.0))))
   '(font-lock-constant-face ((t (:foreground "#20b2aa"))))
   '(font-lock-keyword-face ((t (:foreground "#f00"))))
   '(fringe ((t (:background "#000"))))
   '(header-line ((t (:background "#000" :foreground "#333"))))
   '(hl-paren-face ((t (:weight bold))) t)
   '(js3-private-function-call-face ((t (:foreground "firebrick"))))
   '(mode-line ((t (:background "#000" :foreground "#999" :box (:line-width 1 :color "#999") :height 0.75))))
   '(mode-line-highlight ((t (:box (:line-width 2 :color "#000" :style released-button) :height 0.6))))
   '(mode-line-inactive ((t (:inherit mode-line :background "#010101" :foreground "#999"))))
   '(org-clock-overlay ((t (:background "#000"))))
   ;; '(org-column ((t (:background "black" :strike-through nil :underline nil :slant normal :weight normal :height 120 :family "WenQuanYi Zen Hei Mono"))))
   '(org-column-title ((t (:inherit org-column :background "black" :foreground "white"))))
   '(org-level-1 ((t (:inherit outline-1))))
   '(org-level-4 ((t (:background "black" :foreground "hot pink"))))
   '(org-todo ((t (:foreground "red" :weight bold))))
   '(org-warning ((t (:foreground "red" :weight bold))))
   '(region ((t (:background "#333" :foreground "#fff"))))
   '(secondary-selection ((t (:background "#111"))))))


(if (and (fboundp 'daemonp) (daemonp))
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (with-selected-frame frame
                  (frame-setting))))
  (frame-setting))

(provide 'init-ui)
