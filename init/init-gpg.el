;;;;  文件加密

;;; easypg，emacs 自带
(require 'epa-file)
(epa-file-enable)
(setq epa-file-encrypt-to "zenoes@qq.com")
(setq epa-file-cache-passphrase-for-symmetric-encryption nil)
(setq epa-file-inhibit-auto-save t)

;;;; END 文件加密
(provide 'init-gpg)
