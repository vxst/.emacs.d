;; 备份文档路径
(setq backup-directory-alist (quote (("~/.backups"))))
;;生成临时文件
(setq-default make-backup-file t)
(setq make-backup-file t)
(setq make-backup-files t)
(setq delete-old-versions t)
;;自动存盘
(setq auto-save-mode t)
;;击键100次自动保存
(setq auto-save-interval 100)
(provide 'init-backup)
