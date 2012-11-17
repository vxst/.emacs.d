;;;; Frames and Graphical Displays

;;; UI
;; 关闭Emacs启动时提示信息
;; (setq inhibit-startup-message t)
;; 各种bar
(set-scroll-bar-mode nil)
(blink-cursor-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
;; (menu-bar-mode (quote toggle))
;;; Modeline
;; 电池
(setq battery-mode-line-format "[%b%p%%]")
(display-battery-mode 1)
;; 时间
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-format "[%m-%d %a %H:%M]")
;; 不要显示load average
(setq display-time-load-average-threshold 100)
(display-time)
(setq display-time-24hr-format t)
(setq column-number-mode t)
(setq line-number-mode t)
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



(provide 'init-ui)
