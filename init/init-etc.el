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

;;;; UNDO TREE
(require 'undo-tree)
(global-undo-tree-mode)
;;;; END Undo Tree


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

;;;; English Writing
(require 'english-writing-mode)


(provide 'init-etc)