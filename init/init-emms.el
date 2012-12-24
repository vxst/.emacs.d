;; 记得在开始前装上mplayer,mpg123等等的需要软件，否则会遇到奇怪的问题
(require 'emms-setup)
(emms-standard)
(require 'emms-info)
(require 'emms-score)
(require 'emms-playlist-sort)

(require 'emms-lyrics)
(emms-lyrics 1)
(setq emms-lyrics-dir "~/.lyrics")
(setq emms-lyrics-display-format "%s")
(setq emms-lyrics-scroll-p t)
(setq emms-lyrics-scroll-timer-interval 0.4)
(setq emms-lyrics-display-on-minibuffer nil)
(setq emms-lyrics-display-on-modeline nil)

(defun emms-fetch-lrc(key output)
  (setq key (replace-regexp-in-string " " "%20" key))
  ;; (message "%s" key)
  (unless (file-exists-p output)
    (let* ((regexp ".*<a class=\"down-lrc-btn { 'href':'\\(.*\\)")
    	   (regexp-2 "\\(.*\\)' }\" href=\"#\">.*")
    	   (lrc)
	   (html))

      (setq html (shell-command-to-string
		  (concat "curl --connect-timeout 5 --url http://music.baidu.com/search/lrc?key=" key)))

      (when (string-match regexp html)
    	(setq html (match-string 1 html))
    	(when (string-match regexp-2 html)
    	  (setq lrc (match-string 1 html))
    	  (setq lrc (shell-command-to-string (concat "curl --connect-timeout 5 --url http://music.baidu.com" lrc)))
	  (when (string-match "\\[\\(.*\\)" lrc)
	    (with-temp-buffer
	      (insert
	       (replace-regexp-in-string
		"^\n" "" 
		(replace-regexp-in-string "^[^\\[]*" "" lrc)))
	      (write-file output))))))))


(defun my-find-lrc(file)
  (let* ((orifile (emms-track-get track 'name))
	 (target (replace-regexp-in-string ".mp3" ".lrc" orifile))
	 (title (emms-track-get track 'info-title))
	 (artist (emms-track-get track 'info-artist))
	 )
    (emms-fetch-lrc
     (concat  title " " artist)
     target)
    (emms-lyrics-find-lyric file)))



;; 覆盖EMMS函数定义

(defun emms-lyrics-scroll (lyric next-lyric diff)
  "Scroll LYRIC to left smoothly in DIFF seconds.
DIFF is the timestamp differences between current LYRIC and
NEXT-LYRIC."
  (setq diff (floor diff))
  (setq emms-lyrics-scroll-timers '())
  (let ((scrolled-lyric (concat lyric " " next-lyric))
	(time 0)
	(pos 0))
    (catch 'return
      (while (< time diff)
	(setq emms-lyrics-scroll-timers
	      (append emms-lyrics-scroll-timers
		      (list
		       (run-at-time time
				    nil
				    'emms-lyrics-display
				    (if (>= (length lyric) pos)
					(substring scrolled-lyric pos)
				      (throw 'return t))))))
	(setq time (+ time emms-lyrics-scroll-timer-interval))
	;; (setq pos (1+ pos))
	))))
(defun emms-lyrics-display (lyric)
  "Display LYRIC now.
See `emms-lyrics-display-on-modeline' and
`emms-lyrics-display-on-minibuffer' on how to config where to
display."
  (when emms-lyrics-alist
    (when emms-lyrics-display-on-modeline
      (emms-lyrics-mode-line)
      (setq emms-lyrics-mode-line-string lyric)
      ;;       (setq emms-lyrics-mode-line-string ; make it fit scroller width
      ;;             (concat emms-lyrics-mode-line-string
      ;;                     (make-string
      ;;                      (abs (- emms-lyrics-scroll-width (length lyric)))
      ;;                      (string-to-char " "))))
      (force-mode-line-update))
    (when emms-lyrics-display-on-minibuffer
      (unless (minibuffer-window-active-p (selected-window))
	(let* ((lyric (concat "> " lyric))
	       (lyric (propertize lyric
				  'face 'info-title-1)
		      ))

	  (message lyric))
	))))


(defun set-emms-font ()
  (interactive)
  (message "set emms font")
  (overlay-put (make-overlay (point-min) (point-max) nil nil t)
	       'face '(:family "WenQuanYi Zen Hei Mono")))


(emms-cache-disable)

(emms-default-players)
(emms-score-enable)

(setq emms-player-next-function 'emms-random)

;;修复该死的播放完后的BUG
;;(setq emms-player-next-function 'emms-next)

;;关闭EMMS信息异步模式
(setq emms-info-asynchronously nil)

;; default 循环设置
(setq emms-repeat-track nil)
(setq emms-repeat-playlist t)


(setq emms-playlist-sort-function       ;设置播放列表用自然的方法排序: 艺术家 -> 专辑 -> 序号
      'emms-playlist-sort-by-natural-order)

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
		 (filename (replace-regexp-in-string "\\(^[ ]*\\|[ ]*$\\)" "" filename))
		 (filename (replace-regexp-in-string " *- *" "-" filename))
		 (artist-tmp)
		 )
	    (emms-track-set track 'info-artist dirname)
	    (emms-track-set track 'info-title filename)


	    ;; 特例: A-Lin
	    (when (string-match "A-Lin" filename)
	      (setq artist-tmp "A-Lin")
	      (setq filename (replace-regexp-in-string "A-Lin" "ALin" filename)))


	    (when (string-match regexp-2 filename)
	      (let ((before (match-string 1 filename))
		    (after (match-string 2 filename)))
		;; 歌曲-歌手 模式
		(if (equal dirname (replace-regexp-in-string " " "" before))
		    (progn
		      (emms-track-set track 'info-artist before)
		      (emms-track-set track 'info-title after))
		  ;; 歌手-歌曲 模式
		  (progn
		    (emms-track-set track 'info-artist after)
		    (emms-track-set track 'info-title before)))))


	    ;; 歌手-专辑-歌曲 模式
	    (when (string-match regexp-3 filename)
	      (emms-track-set track 'info-artist (match-string 1 filename))
	      (emms-track-set track 'info-title (match-string 3 filename)))


	    (if artist-tmp
		(emms-track-set track 'info-artist artist-tmp))
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
				  (emms-random)))
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
				  (set-emms-font)
				  (make-local-variable 'emms-lyrics-display-on-minibuffer)
				  (setq emms-lyrics-display-on-minibuffer t)
				  (make-local-variable 'emms-lyrics-find-lyric-function)
				  (setq emms-lyrics-find-lyric-function 'my-find-lrc)
				  ))
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
(emms-add-directory-tree "~/git/BD_music_downloader/")
(emms-next)
(emms-pause)


(require 'emms-tag-editor)

(provide 'init-emms)
