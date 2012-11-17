;; Time-stamp: <2012-11-17 21:45:07 Zeno Zeng>

(add-to-list 'load-path "~/.emacs.d/init")
(add-to-list 'load-path "~/.emacs.d/modes")
(add-to-list 'load-path "~/.emacs.d/require")
(add-to-list 'load-path "~/.emacs.d/modes/less-css-mode")
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-1.4")
(add-to-list 'load-path "~/.emacs.d/elpa/popup-0.5")
(add-to-list 'load-path "~/.emacs.d/require/emacs-w3m")
(add-to-list 'load-path "~/.emacs.d/require/o-bloger")
(add-to-list 'load-path "~/.emacs.d/elpa/undo-tree-0.5.4")
(add-to-list 'load-path "~/.emacs.d/elpa/org-20120903")


(require 'init-ui)
(require 'init-personal)
(require 'init-functions)

(require 'init-elpa)
(require 'init-hs)
(require 'init-auto-complete)
(require 'init-backup)

(require 'init-w3m)
(require 'init-org)

(require 'init-js)
(require 'init-css)
(require 'init-php)

;;;; UNDO TREE
(require 'undo-tree)
(global-undo-tree-mode)
;;;; END Undo Tree



;;obloger
(require 'o-bloger)
;;htmlize
(require 'htmlize)

;; 在行首 C-k 时，同时删除该行。
(setq-default kill-whole-line t)

;; 自动更新time-stamp
(setq time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S %U")
(add-hook 'before-save-hook 'time-stamp)
;; 不要使用tab进行缩进
(setq indent-tabs-mode nil)





;;设定删除保存记录为200，可以方便以后无限恢复
(setq kill-ring-max 200)

;;允许emacs和外部其他程式的粘贴
(setq x-select-enable-clipboard t)


;;;; Modes

;; GIMP MODE
(load "~/.emacs.d/modes/gimp-mode/gimp-init.el")
(global-set-key "\C-cg" 'gimp-selector)

;; Now you can run the GIMP with `M-x run-gimp'.
;; Alternatively, connect to GIMP server with `M-x gimp-cl-connect'.

;; Type `M-x gimp-help' for help.



;; firefox
(defun ff()
  (interactive)
  (shell-command "firefox"))


;; Markdown
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.mkd" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("\\.md" . markdown-mode) auto-mode-alist))

;; Html mode
(setq auto-mode-alist
      (cons '("\\.html" . html-mode) auto-mode-alist))
;;;; END Modes




;;;;  文件加密

;;; easypg，emacs 自带
(require 'epa-file)
(epa-file-enable)
;; 总是使用对称加密
(setq epa-file-encrypt-to nil)
;;(setq epa-file-cache-passphrase-for-symmetric-encryption t)
;; 允许自动保存
;;(setq epa-file-inhibit-auto-save nil)

;;;; END 文件加密

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#000" :foreground "#fff" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "文泉驿等宽正黑"))))
 '(font-lock-comment-delimiter-face ((t (:inherit font-lock-comment-face))))
 '(font-lock-comment-face ((t (:background "#111" :foreground "#999" :height 1.0))))
 '(font-lock-constant-face ((t (:foreground "#20b2aa"))))
 '(font-lock-keyword-face ((t (:foreground "#f00"))))
 '(fringe ((t (:background "#000"))))
 '(header-line ((t (:background "#000" :foreground "#333"))))
 '(hl-paren-face ((t (:weight bold))) t)
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
 '(hl-paren-colors (quote ("#f00" "#ff0" "#0f0" "#00ced1" "#9400d3")))
 '(less-css-compile-at-save t)
 '(less-css-lessc-options (list "-x"))
 '(org-agenda-span (quote month))
 '(org-clock-out-remove-zero-time-clocks t)
 '(tags-table-list (quote ("~/src/emacs-24.1/lisp/TAGS"))))

;; 绑定全局键值
;; 也可以绑定单独到某个mode，比如cc-mode (define-key cc-mode-map (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "(")  'skeleton-pair-insert-maybe)
(global-set-key (kbd "{")  'skeleton-pair-insert-maybe)
(global-set-key (kbd "《")  'skeleton-pair-insert-maybe)
(global-set-key (kbd "（")  'skeleton-pair-insert-maybe)
;; (global-set-key (kbd "\'") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
;; (global-set-key (kbd "[")  'skeleton-pair-insert-maybe)

(global-set-key (kbd "C-/") 'undo-tree-undo)
(global-unset-key (kbd "C-."))
(global-set-key (kbd "C-;") 'undo-tree-redo)
(global-set-key (kbd "C-.") 'undo-tree-redo)
(global-set-key (kbd "C-,") 'indent-buffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-y") 'my-yank)
(global-set-key (kbd "C-'") 'hs-toggle-hiding)
;; 防止find-file时的误按
(global-unset-key "\C-xf")
;; 大小写转换，这里默认转换左边的单词
(global-set-key (kbd "M-u") (lambda () (interactive) (upcase-word -1)))
(global-set-key (kbd "M-l") (lambda () (interactive) (downcase-word -1)))
(global-set-key (kbd "M-c") (lambda () (interactive) (capitalize-word -1)))

;;(global-set-key (kbd "S-SPC C-i") 'zeno-emacs)

(global-set-key (kbd "C-c C-x C-o") 'org-agenda-clock-out)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

;; C-x C-j open the directory of current buffer
(global-set-key (kbd "C-x C-j")
                (lambda ()
                  (interactive)
                  (if (buffer-file-name)
                      (dired default-directory))))

;; 这里重启两次是为了 防止toggle类的fun出现问题
(global-set-key (kbd "H-i") '(lambda ()
                               (interactive)
                               (indent-buffer)))
(global-set-key (kbd "H-x") 'execute-extended-command)
(global-set-key (kbd "H-r") 'replace-regexp)
(global-set-key [f2] 'hs-hide-all)
(global-set-key (kbd "H-e") '(lambda ()
                               (interactive)
                               (eval-buffer)))
(global-set-key [f6] 'toggle-truncate-lines)

;; 全屏
(global-set-key [f11] '(lambda ()
                         (interactive)
                         (x-send-client-message
                          nil 0 nil "_NET_WM_STATE" 32
                          '(2 "_NET_WM_STATE_FULLSCREEN" 0))))

(global-set-key [f12] 'archive-region)



;; 填入大中小括号，双单引号的匹配
;; 放最后，不然导致缩进错误
(setq skeleton-pair t)
(setq skeleton-pair-alist '((?\" _ "\"" >)(?\' _ "\'" >)(?《 _"》">)(?（ _"）">)(?\( _ ")" >)(?\[ _ "]" >)(?\{ _ "}" >)))
