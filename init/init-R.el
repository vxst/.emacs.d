(autoload 'R "ess-site.el" "ESS" t)
(autoload 'R-mode "ess-site.el" "ESS" t)
(autoload 'R-mode-hook "ess-site.el" "ESS" t)
(autoload 'r-mode "ess-site.el" "ESS" t)
(autoload 'Rd-mode "ess-site.el" "ESS" t)
(autoload 'noweb-mode "ess-site.el" "ESS" t)
(autoload 'ess-eldoc "ess-site.el" "ESS" t)
(add-to-list 'auto-mode-alist '("\\.R$" . R-mode))
(add-to-list 'auto-mode-alist '("\\.r$" . R-mode))
(add-to-list 'auto-mode-alist '("\\.Rd$" . Rd-mode))
(add-to-list 'auto-mode-alist '("\\.Rnw$" . noweb-mode))

(setq ess-mode-R-shown nil)
(add-hook 'R-mode-hook (lambda()
			(local-set-key (kbd "M-e")
				       (lambda ()
					 (interactive)
					 (ess-eval-region (point-min) (point-max) t)
					 (unless ess-mode-R-shown
					   (setq ess-mode-R-shown t)
					   (split-window-below)
					   (switch-to-buffer "*R*"))))))

(setq ess-eval-visibly-p nil) ;otherwise C-c C-r (eval region) takes forever
(setq ess-ask-for-ess-directory nil) ;otherwise you are prompted each time you start an interactive R session

(add-hook 'R-mode-hook 'ess-switch-process) ; 确保R进程开启，保证eldoc运行
(provide 'init-R)
