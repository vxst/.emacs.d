;;; org-my-exp.el --- 

;; Copyright (C) 2012  Zeno Zeng

;; Author: Zeno Zeng <zenoes@qq.com>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:
(defun org-my-exp (&optional arg)
  (interactive "P")
  (let* ((bg (org-xor (equal arg '(16)) org-export-run-in-background))
	 (subtree-p (or (org-region-active-p)
			(eq org-export-initial-scope 'subtree)))
	 (regb (and (org-region-active-p) (region-beginning)))
	 (rege (and (org-region-active-p) (region-end)))
	 (help "Org My Exp
\[l] 论文
\[e] 英语作文")
	 (cmds
	  '((?e org-my-exp-english t)
	    (?l org-my-exp-lunwen t)))
	 r1 r2 ass
	 (cpos (point)) (cbuf (current-buffer)) bpos)
    (save-excursion
      (save-window-excursion
	(if subtree-p
	    (message "Export subtree: ")
	  (message "Export buffer: "))
	(delete-other-windows)
	(with-output-to-temp-buffer "*Org Export/Publishing Help*"
	  (princ help))
	(org-fit-window-to-buffer (get-buffer-window
				   "*Org Export/Publishing Help*"))
	(while (eq (setq r1 (read-char-exclusive)) ?1)
	  (cond (subtree-p
		 (setq subtree-p nil)
		 (message "Export buffer: "))
		((not subtree-p)
		 (setq subtree-p t)
		 (setq bpos (point))
		 (org-mark-subtree)
		 (org-activate-mark)
		 (setq regb (and (org-region-active-p) (region-beginning)))
		 (setq rege (and (org-region-active-p) (region-end)))
		 (message "Export subtree: "))))
	(when (eq r1 ?\ )
	  (let ((case-fold-search t)
		(end (save-excursion (while (org-up-heading-safe)) (point))))
	    (outline-next-heading)
	    (if (re-search-backward
		 "^[ \t]+\\(:latex_class:\\|:export_title:\\|:export_file_name:\\)[ \t]+\\S-"
		 end t)
		(progn
		  (org-back-to-heading t)
		  (setq subtree-p t)
		  (setq bpos (point))
		  (message "Select command (for subtree): ")
		  (setq r1 (read-char-exclusive)))
	      (error "No enclosing node with LaTeX_CLASS or EXPORT_TITLE or EXPORT_FILE_NAME")
	      )))))
    (if (fboundp 'redisplay) (redisplay)) ;; XEmacs does not have/need (redisplay)
    (and bpos (goto-char bpos))
    (setq r2 (if (< r1 27) (+ r1 96) r1))
    (unless (setq ass (assq r2 cmds))
      (error "No command associated with key %c" r1))
    (if (and bg (nth 2 ass)
	     (not (buffer-base-buffer))
	     (not (org-region-active-p)))
	;; execute in background
	(let ((p (start-process
		  (concat "Exporting " (file-name-nondirectory (buffer-file-name)))
		  "*Org Processes*"
		  (expand-file-name invocation-name invocation-directory)
		  "-batch"
		  "-l" user-init-file
		  "--eval" "(require 'org-exp)"
		  "--eval" "(setq org-wait .2)"
		  (buffer-file-name)
		  "-f" (symbol-name (nth 1 ass)))))
	  (set-process-sentinel p 'org-export-process-sentinel)
	  (message "Background process \"%s\": started" p))
      ;; set the mark correctly when exporting a subtree
      (if subtree-p (let (deactivate-mark) (push-mark rege t t) (goto-char regb)))

      (call-interactively (nth 1 ass))
      (when (and bpos (get-buffer-window cbuf))
	(let ((cw (selected-window)))
	  (select-window (get-buffer-window cbuf))
	  (goto-char cpos)
	  (deactivate-mark)
	  (select-window cw))))))

(defun org-my-exp-get-header (header)
  (let (values)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward (format "^#\\+%s:?[ \t]+\\(.*\\)" header) nil t)
	(add-to-list 'values (substring-no-properties (match-string 1)))))
    (car values)))

(defun org-my-exp-lunwen (arg)
  "导出org文件到论文格式"
  (interactive "P")

  (save-excursion
    (save-restriction
      (save-match-data
	(widen)
	(goto-char (point-min))

	(let* ((info-etc (org-my-exp-get-header "INFOETC"))
	       (author (org-my-exp-get-header "AUTHOR"))
	       (abstract (org-my-exp-get-header "ABSTRACT"))
	       (keywords (org-my-exp-get-header "KEYWORDS")))

	  (org-export-as-html arg 'hidden)

	  (replace-regexp "<div id=\"outline-container-1\""
			  (concat
			   "<div id=\"author\">"
			   author
			   "</div>"
			   "<div id=\"info-etc\">"
			   info-etc
			   "</div>"
			   "<div id=\"abstract\"><strong class=\"hei\"><span>摘</span>要</strong>："
			   abstract
			   "</div>"
			   "<div id=\"keywords\"><strong class=\"hei\">关键词</strong>："
			   keywords
			   "</div>"
			   "<br><br>"
			   "<div id=\"outline-container-1\""))

	  (replace-regexp "</style>"
			  "input,textarea,select{outline:none;}
body{max-width:560pt;width:90%;padding:10pt 0;margin:0 auto;font-size:12pt;}
.hei {font-family:\"Hiragino Sans GB\",\"ST Heiti\",\"LiHei Pro Medium\",\"Microsoft YaHei\",\"Wenquanyi Micro Hei\",\"WenQuanYi Zen Hei\";}
#abstract, #keywords, #author, #info-etc {font-family:\"STKaiti\",\"KaiTi\",\"AR PL KaitiM GB\",\"TW\-Kai\";}
#abstract, #keywords {padding-left:24pt;padding-top:1em;font-size:.9em;}
#abstract strong span{letter-spacing:1em;}
#author{font-size:1.5em;padding-bottom:1em;text-align:center;}
#info-etc {text-align:center;padding-bottom:1em;}
a{color:#000000;text-decoration:none;}
.outline-3{page-break-inside:avoid;}
p{text-indent:2em;line-height:1.5em;font-family:\"NSimSun\",\"STSong\",\"AR PL SungtiL GB\",\"TW\-Sung\",\"SimSun\";}p sup{line-height:.8em;}
h1,h2,h3,h4,h5,h6{font-family:\"Hiragino Sans GB\",\"ST Heiti\",\"LiHei Pro Medium\",\"Microsoft YaHei\",\"Wenquanyi Micro Hei\",\"WenQuanYi Zen Hei\";font-weight:normal;}
#footnotes{padding-top:1em;font-size:8pt;color:#000000;}#footnotes::before{content:\"参考文献\";font-size:18pt;}
#footnotes p{text-indent:0;}
#footnotes h2.footnotes{display:none;}
#footnotes .timestamp{color:#000000;}#footnotes .timestamp::before{content:\"[\";}
#footnotes .timestamp::after{content:\"]\";}
#footnotes sup{font-size:8pt;vertical-align:inherit;}#footnotes sup a::before{content:\"[\";}
#footnotes sup a::after{content:\"]\";}
#table-of-contents{display:none;}
#postamble{display:none;}
</style>"
			  nil (point-min) (point-max))
	  (save-buffer)
	  (org-open-file buffer-file-name)
	  (when org-export-kill-product-buffer-when-displayed
	    (kill-buffer (current-buffer))))))))

(defun org-my-exp-english ()
  "导出org到合理的英语作文格式"
  (interactive))



(provide 'org-my-exp)
;;; org-my-exp.el ends here
