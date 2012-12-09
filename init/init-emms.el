;; 记得在开始前装上mplayer,mpg123等等的需要软件，否则会遇到奇怪的问题

(require 'emms-setup)
(emms-standard)
(require 'emms-score)
(emms-default-players)

;; 循环设置
(setq emms-repeat-track nil)
(setq emms-repeat-playlist t)

;; 打开时自动加载，完毕后暂停
(emms-play-directory-tree "~/音乐/")
(emms-shuffle)
(emms-next)
(emms-pause)

;; global key-map
;; all global keys prefix is C-c e
;; compatible with emms-playlist mode keybindings
;; you can view emms-playlist-mode.el to get details about 
;; emms-playlist mode keys map
(global-set-key (kbd "C-c e <SPC>") 'emms-pause)
(global-set-key (kbd "C-c e n") (lambda ()
				  (interactive)
				  (emms-score-down-playing)
				  (emms-next)))
(global-set-key (kbd "C-c e p") (lambda ()
				  (interactive)
				  (emms-score-up-playing)
				  (emms-previous)))
(global-set-key (kbd "C-c e f") 'emms-show)
;; these keys maps were derivations of above keybindings
(global-set-key (kbd "C-c e t") 'emms-play-directory-tree)
(global-set-key (kbd "C-c e l") 'emms-play-playlist)
(global-set-key (kbd "C-c e u") 'emms-score-up-playing)
(global-set-key (kbd "C-c e d") 'emms-score-down-playing)

(provide 'init-emms)
