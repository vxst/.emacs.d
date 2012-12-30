;;;; Frames and Graphical Displays

;; Turn off mouse interface
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;;; UI
;; 关闭Emacs启动时提示信息
;; (setq inhibit-startup-message t)
;; 各种bar
(blink-cursor-mode -1)
;; (menu-bar-mode (quote toggle))
;;; Modeline
;; 电池
;; (setq battery-mode-line-format "[%b%p%%]")
;; (display-battery-mode)
;; ;; 时间
;; (setq display-time-24hr-format t)
;; (setq display-time-day-and-date t)
;; (setq display-time-format "[%m-%d %a %H:%M]")
;;  ;; 不要显示load average
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
(setq golden-ratio-exclude-modes '("shell-mode"
                                   "calendar-mode"
                                   "gud-mode"
                                   "ediff-mode"
                                   "eshell-mode"))
(setq golden-ratio-exclude-buffer-names
      '(" *org tags*"
        " *Org todo*"
        ))
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

(provide 'init-ui)
