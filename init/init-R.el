;; 安装Ess-mode, sudo apt-get install ess
(require 'ess-site)

(setq ess-mode-R-shown nil)
(define-key ess-mode-map (kbd "M-e")
  (lambda ()
    (interactive)
    (ess-eval-region (point-min) (point-max) t)
    (unless ess-mode-R-shown
      (setq ess-mode-R-shown t)
      (split-window-below)
      (switch-to-buffer "*R*"))))

(setq ess-eval-visibly-p nil) ;otherwise C-c C-r (eval region) takes forever
(setq ess-ask-for-ess-directory nil) ;otherwise you are prompted each time you start an interactive R session
(require 'ess-eldoc) ;to show function arguments while you are typing them

(add-hook 'ess-mode-hook 'ess-switch-process) ; 确保R进程开启，保证eldoc运行
(provide 'init-R)
