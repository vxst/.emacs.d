(require 'emms-setup)

(emms-devel)
(emms-default-players)

;; 不要在modeline显示
(emms-mode-line-disable)
(emms-playing-time-disable-display)
(emms-lyrics-disable)

;; 打开时自动加载，完毕后暂停
(emms-add-directory-tree "~/音乐/")
(emms-shuffle)
(emms-start)
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
