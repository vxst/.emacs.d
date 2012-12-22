
;; 记得在开始前装上mplayer,mpg123等等的需要软件，否则会遇到奇怪的问题
(require 'emms-setup)
(emms-standard)
(require 'emms-info)
(require 'emms-score)
(require 'emms-playlist-sort)


(defun set-emms-font ()
  (interactive)
  (message "set emms font")
  (overlay-put (make-overlay (point-min) (point-max) nil nil t)
               'face '(:family "WenQuanYi Zen Hei Mono")))



(emms-cache-disable)

(emms-default-players)
(emms-score-enable)

;;修复该死的播放完后的BUG
(setq emms-player-next-function 'emms-next)

;;关闭EMMS信息异步模式
(setq emms-info-asynchronously nil)            

;; default 循环设置
(setq emms-repeat-track nil)
(setq emms-repeat-playlist t)

(defun kid-emms-info-simple-plus (track)
  "Get info from the filename.
mp3 标签的乱码问题总是很严重，幸好我系统里面的音乐文件
都放得比较有规律，所以我决定直接从文件名获取标签信息。"
  (when (eq 'file (emms-track-type track))
    (let ((name (emms-track-name track))
	  (regexp "/\\([^/]+\\)/\\([^/]+\\)\\.[^.]+$")
	  (regexp-2 "^\\([^-]+\\)-\\([^-]+\\)$")
	  (regexp-3 "^\\([^-]+\\)-\\([^-]+\\)-\\([^-]+\\)$")
	  )
      (if (string-match regexp name)
	  (let* ((dirname (match-string 1 name))
		 (filename (match-string 2 name))
		 (filename (replace-regexp-in-string " " "" filename)))
            (emms-track-set track 'info-artist dirname)
            (emms-track-set track 'info-title filename)

	    ;; 歌手-歌曲 模式
	    (when (string-match regexp-2 filename)
	      (emms-track-set track 'info-artist (match-string 1 filename))
	      (emms-track-set track 'info-title (match-string 2 filename)))

	    ;; 歌手-专辑-歌曲 模式
	    (when (string-match regexp-3 filename)
	      (emms-track-set track 'info-artist (match-string 1 filename))
	      (emms-track-set track 'info-title (match-string 3 filename)))
	    )
          (emms-track-set track
                          'info-title
                          (file-name-nondirectory name))))))
(setq emms-info-functions (list 'kid-emms-info-simple-plus))


(defun kid-emms-info-track-description (track)
  "Return a description of the current track."
  (let ((artist (emms-track-get track 'info-artist))
        (title (emms-track-get track 'info-title)))
    (format "%-16s ->   %s"
            (or artist
                "")
            title)))
(setq emms-track-description-function 'kid-emms-info-track-description)

(global-set-key (kbd "C-c e <SPC>") 'emms-pause)
(global-set-key (kbd "C-c e n") (lambda ()
				  (interactive)
				  (emms-score-down-playing)
				  (emms-next)))
(global-set-key (kbd "C-c e p") (lambda ()
				  (interactive)
				  (emms-previous)
				  (emms-score-up-playing)))
(global-set-key (kbd "C-c e s") (lambda ()
				  (interactive)
				  (emms-score-up-playing)
				  (emms-show)))
(global-set-key (kbd "C-c e g") (lambda ()
				  (interactive)
				  (emms-playlist-mode-go)
				  (set-emms-font)))
(global-set-key (kbd "C-c e t") 'emms-play-directory-tree)
(global-set-key (kbd "C-c e r") (lambda ()
				  (interactive)
				  (emms-play-directory-tree "~/data/music/")))
(global-set-key (kbd "C-c e u") 'emms-score-up-playing)
(global-set-key (kbd "C-c e d") 'emms-score-down-playing)

(setq emms-score-file "~/.emms/scores")


;;autodetect musci files id3 tags encodeing
;; (require 'emms-i18n)
;; ;; 解决乱码
;; (setq emms-info-mp3info-coding-system 'gbk
;;       emms-cache-file-coding-system 'utf-8)



;; 打开时自动加载，完毕后暂停
(emms-play-directory-tree "~/data/music/")
(emms-next)
(emms-pause)


(require 'emms-tag-editor)

(provide 'init-emms)
