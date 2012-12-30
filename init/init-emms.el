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

;;修复该死的播放完后的BUG
(setq emms-player-next-function 'emms-next)

;;关闭EMMS信息异步模式
(setq emms-info-asynchronously nil)

;; default 循环设置
(setq emms-repeat-track nil)
(setq emms-repeat-playlist t)


(add-hook 'emms-player-finished-hook 'emms-random)

(setq emms-playlist-sort-function
      'emms-playlist-sort-by-score)

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
      (emms-track-set track 'my-file-url name)
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

(defun emms-delete-current-playing-file ()
  (interactive)
  (let* ((this (emms-playlist-current-selected-track))
	 (url (emms-track-get this 'my-file-url)))
    (when this
      (when (yes-or-no-p (concat "Delete " url " ?"))
	(delete-file url)
	(emms-playlist-update)
	(emms-start)
	(emms-next)
	(emms-random)
	))))


;; 覆盖默认函数
(defun emms-info-track-description (track)
  "Return a description of the current track."
  (let ((artist (emms-track-get track 'info-artist))
	(title (emms-track-get track 'info-title))
	(score (emms-score-get-score (emms-track-get track 'my-file-url))))
    (format "%-16s ->   %-30s   Score:: %s"
	    (or artist
		"")
	    title
	    (or score 0))))
(setq emms-track-description-function 'emms-info-track-description)

(global-set-key (kbd "C-c e <SPC>") 'emms-pause)
(global-set-key (kbd "C-c e n") (lambda ()
				  (interactive)
				  (emms-score-down-playing)
				  (emms-playlist-update)
				  (emms-random)))
(global-set-key (kbd "C-c e p") (lambda ()
				  (interactive)
				  (emms-previous)))
(global-set-key (kbd "C-c e s") (lambda ()
				  (interactive)
				  (emms-score-up-playing)
				  (emms-show)))
(global-set-key (kbd "C-c e g") (lambda ()
				  (interactive)
				  (emms-playlist-mode-go)
				  (emms-playlist-update)))
(global-set-key (kbd "C-c e t") 'emms-play-directory-tree)
(global-set-key (kbd "C-c e r") (lambda ()
				  (interactive)
				  (emms-play-directory-tree "~/data/music/")))
(global-set-key (kbd "C-c e u") (lambda ()
				  (interactive)
				  (emms-score-up-playing)
				  (emms-playlist-update)))
(global-set-key (kbd "C-c e d") (lambda ()
				  (interactive)
				  (emms-score-down-playing)
				  (emms-playlist-update)))
(global-set-key (kbd "C-c e D") 'emms-delete-current-playing-file)
(setq emms-score-file "~/.emms/scores")

(defun emms-playlist-update()
  "detect whether file exists and update the score"
  (interactive)
  (ignore-errors
    (emms-playlist-ensure-playlist-buffer)
    (emms-with-inhibit-read-only-t
     (save-excursion
       (goto-char (point-min))
       (let ((first-try t))
	 (while (or first-try (re-search-forward "\n"))
	   (setq first-try nil)
	   (let* ((track (emms-playlist-track-at))
		  (file (emms-track-get track 'my-file-url))
		  (score (emms-score-get-score file)))
	     (if (file-exists-p file)
		 (progn
		   (goto-char (line-beginning-position))
		   (when (re-search-forward "Score:: [-0-9]*$" nil t 1)
		     (replace-match
		      (propertize (format "Score:: %d" (or score 0))
				  'face 'emms-playlist-track-face)
		      nil nil)))
	       (emms-playlist-mode-kill-entire-track)))))))))


;; 打开时自动加载，完毕后暂停
(emms-add-directory-tree "~/data/music/")
(emms-add-directory-tree "~/git/BD_music_downloader/")
(emms-playlist-mode-go)
(emms-start)
(emms-random)
(emms-pause)
(set-emms-font)
(make-local-variable 'emms-lyrics-display-on-minibuffer)
(setq emms-lyrics-display-on-minibuffer t)
(make-local-variable 'emms-lyrics-find-lyric-function)
(setq emms-lyrics-find-lyric-function 'my-find-lrc)
(emms-uniq)
(emms-sort)

(require 'emms-tag-editor)

(provide 'init-emms)
