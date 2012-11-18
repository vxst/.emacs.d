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

(provide 'init-etc)
