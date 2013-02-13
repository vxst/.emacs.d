;; 安装Ess-mode, sudo apt-get install ess
(require 'ess-site)

(define-key ess-mode-map [f2] 'ess-r-args-show)
(define-key ess-mode-map (kbd "s-e")
  (lambda ()
    (interactive)
    (ess-eval-region (point-min) (point-max) t)))
(define-key ess-mode-map [f3] 'ess-r-args-insert)
(define-key inferior-ess-mode-map [f2] 'ess-r-args-show)
(define-key inferior-ess-mode-map [f3] 'ess-r-args-insert)

(setq ess-eval-visibly-p nil) ;otherwise C-c C-r (eval region) takes forever
(setq ess-ask-for-ess-directory nil) ;otherwise you are prompted each time you start an interactive R session
(require 'ess-eldoc) ;to show function arguments while you are typing them
;; 确保R进程开启，保证eldoc运行
(add-hook 'ess-mode-hook 'ess-switch-process)
(provide 'init-R)
