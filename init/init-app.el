(defun my-async-shell-command (cmd)
  (let* ((buffer-name (format-time-string "*buffer-to-hide-%s*")))
    (async-shell-command cmd buffer-name nil)
    (delete-windows-on buffer-name nil)
    (add-to-list 'ido-ignore-buffers buffer-name)))

(defun chrome ()
  "open google-chrome with shell-command"
  (interactive)
  (my-async-shell-command "google-chrome --proxy-pac-url=http://localhost/proxy/auto.pac"))

(defun rss ()
  "open my RSS Reader"
  (interactive)
  (let ((origin-buffer (buffer-name)))
    (switch-to-buffer (find-file-noselect "~/private/doc/gtd/new-gtd.org"))
    (save-excursion
      (goto-char (point-min))
      (re-search-forward "** RSS")
      (org-clock-in))
    (my-async-shell-command "thunderbird")
    (switch-to-buffer origin-buffer)))

(defun yacy ()
  "start yacy"
  (interactive)
  (shell-command "/home/zys/pro/yacy/startYACY.sh"))

(defun qmail ()
  "open QQ mail"
  (interactive)
  (let ((origin-buffer (buffer-name)))
    (switch-to-buffer (find-file-noselect "~/private/doc/gtd/new-gtd.org"))
    (save-excursion
      (goto-char (point-min))
      (re-search-forward "** Mail")
      (org-clock-in))
    (my-async-shell-command "google-chrome mail.qq.com")
    (switch-to-buffer origin-buffer)))

(defun taobao ()
  "open taobao"
  (interactive)
  (let ((origin-buffer (buffer-name)))
    (switch-to-buffer (find-file-noselect "~/private/doc/gtd/new-gtd.org"))
    (save-excursion
      (goto-char (point-min))
      (re-search-forward "** Taobao")
      (org-clock-in))
    (my-async-shell-command "google-chrome taobao.com")
    (switch-to-buffer origin-buffer)))

(defun push ()
  (interactive)
  (my-async-shell-command "git commit -a -m 'auto async shell push' && git push")
  )
(global-set-key [f10] 'push)

(defun weibo ()
  (interactive)
  (let ((origin-buffer (buffer-name)))
    (switch-to-buffer (find-file-noselect "~/private/doc/gtd/new-gtd.org"))
    (save-excursion
      (goto-char (point-min))
      (re-search-forward "** 微博")
      (org-clock-in))
    (my-async-shell-command "google-chrome weibo.com")
    (switch-to-buffer origin-buffer)))

(defun tieba ()
  (interactive)
  (let ((origin-buffer (buffer-name)))
    (switch-to-buffer (find-file-noselect "~/private/doc/gtd/new-gtd.org"))
    (save-excursion
      (goto-char (point-min))
      (re-search-forward "** 贴吧")
      (org-clock-in))
    (my-async-shell-command "google-chrome tieba.baidu.com")
    (switch-to-buffer origin-buffer)))

(defun zhihu ()
  (interactive)
  (let ((origin-buffer (buffer-name)))
    (switch-to-buffer (find-file-noselect "~/private/doc/gtd/new-gtd.org"))
    (save-excursion
      (goto-char (point-min))
      (re-search-forward "** 知乎")
      (org-clock-in))
    (my-async-shell-command "google-chrome zhihu.com")
    (switch-to-buffer origin-buffer)))


(defun renren ()
  (interactive)
  (let ((origin-buffer (buffer-name)))
    (switch-to-buffer (find-file-noselect "~/private/doc/gtd/new-gtd.org"))
    (save-excursion
      (goto-char (point-min))
      (re-search-forward "** 人人")
      (org-clock-in))
    (my-async-shell-command "google-chrome renren.com")
    (switch-to-buffer origin-buffer)))

(defun github ()
  (interactive)
  (let ((origin-buffer (buffer-name)))
    (switch-to-buffer (find-file-noselect "~/private/doc/gtd/new-gtd.org"))
    (save-excursion
      (goto-char (point-min))
      (re-search-forward "** Github")
      (org-clock-in))
    (my-async-shell-command "google-chrome github.com")
    (switch-to-buffer origin-buffer)))


(defun gimp ()
  "open gimp"
  (interactive)
  (let ((origin-buffer (buffer-name)))
    (switch-to-buffer (find-file-noselect "~/private/doc/gtd/new-gtd.org"))
    (save-excursion
      (goto-char (point-min))
      (re-search-forward "* GMIP")
      (org-clock-in))
    (my-async-shell-command "gimp")
    (switch-to-buffer origin-buffer)))


;; create a hash table
(setq apps-hash (make-hash-table :test 'equal))
(puthash "\\.xcf$" "gimp " apps-hash)
(puthash "\\.pdf$" "evince " apps-hash)

;; 覆盖定义
(defun dired-find-file ()
  "In Dired, visit the file or directory named on this line."
  (interactive)
  ;; Bind `find-file-run-dired' so that the command works on directories
  ;; too, independent of the user's setting.
  (let* ((find-file-run-dired t)
	 (file (dired-get-file-for-visit))
	 (use-app nil))
    (maphash (lambda (k v)
	       (when (string-match-p k file)
		 (my-async-shell-command (concat v file))
		 (setq use-app t)))
	     apps-hash)
    (unless use-app
      (find-file file))))


(provide 'init-app)