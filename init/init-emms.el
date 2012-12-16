;; 记得在开始前装上mplayer,mpg123等等的需要软件，否则会遇到奇怪的问题
(require 'emms-setup)
(emms-standard)
(require 'emms-info)
(require 'emms-score)
(require 'emms-playlist-sort)

(emms-cache-disable)

(emms-default-players)
(emms-score-enable)

;;修复该死的播放完后的BUG
(setq emms-player-next-function 'emms-next)

;; ;;关闭EMMS信息异步模式
;; (setq emms-info-asynchronously nil)            

;; default 循环设置
(setq emms-repeat-track nil)
(setq emms-repeat-playlist t)

(global-set-key (kbd "C-c e <SPC>") 'emms-pause)
(global-set-key (kbd "C-c e n") (lambda ()
				  (interactive)
				  (emms-score-down-playing)
				  (emms-next)))
(global-set-key (kbd "C-c e p") (lambda ()
				  (interactive)
				  (emms-previous)
				  (emms-score-up-playing)))
(global-set-key (kbd "C-c e s") 'emms-show)
(global-set-key (kbd "C-c e t") 'emms-play-directory-tree)
(global-set-key (kbd "C-c e l") 'emms-play-playlist)
(global-set-key (kbd "C-c e u") 'emms-score-up-playing)
(global-set-key (kbd "C-c e d") 'emms-score-down-playing)

(setq emms-score-file "~/.emms/scores")


;;autodetect musci files id3 tags encodeing
(require 'emms-i18n)
;; 解决乱码
(setq emms-info-mp3info-coding-system 'gbk
      emms-cache-file-coding-system 'utf-8)

(setq emms-track-description-function
      (lambda (track)
	(emms-track-name track)))

;; 打开时自动加载，完毕后暂停
(emms-play-directory-tree "~/音乐/")
(emms-shuffle)
(emms-next)
(emms-pause)

(require 'emms-tag-editor)

(provide 'init-emms)
