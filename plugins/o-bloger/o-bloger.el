;;; This is O-bloger, which is based on Sébastien Gross's O-blog.

;; Copyright © 2012 Sébastien Gross <seb•ɑƬ•chezwam•ɖɵʈ•org> and Zeno Zeng <zenoes@qq.com>

;; Author: Zeno Zeng
;; Time-stamp: <2012-10-29 19:10:34 Zeno Zeng>
;; Keywords: emacs,org,blog
;; Created: 2012-07-16
;; Version: 0.0.2
;; Licence: WTFPL, grab your copy here: http://sam.zoy.org/wtfpl/

;; This file is NOT part of GNU Emacs.

;; Zeno Zeng: I modified the O-blog and created it for myself.  My mistakes are my own.

;;; Commentary:

;;; 初始化

(eval-when-compile
  (require 'cl nil t)
  (require 'browse-url nil t))
(require 'time-stamp nil t)
(require 'org-xhtml nil t)
(require 'dired-sync nil t)
(require 'find-func nil t)

(mapcar (lambda (x) (require (intern (format "o-blog-%s" x)) nil t))
	'("alert" "copy-files" "source" "grid" "i18n" "bootstrap"))

(defgroup o-blog nil "o-blog customization group"
  :group 'org-export)

(defcustom o-blog-async-opts nil
  "Extra options to be used when compiling with
`org-publish-blog-async'."
  :group 'o-blog
  :type 'list)

(defcustom o-blog-before-publish-hook nil
  "Hook to be run before publishing a blog.
Each hook is a function that could be called with no parameter."
  :group 'o-blog
  :type 'hook)

(defcustom o-blog-after-publish-hook nil
  "Hook to be run after publishing a blog.
Each hook is a function that could be called with no parameter."
  :group 'o-blog
  :type 'hook)

(defcustom o-blog-html-plugins-hook nil
  "Hook to be run before exporting an entry to HTML in
`ob-get-entry-text'. Each hook is a function that could be called
with no parameter.

This is a good place for o-blog parser plugins."
  :group 'o-blog
  :type 'hook)



(defstruct (ob:blog :named)
  "Blog structure

 - file: the blog source file (read-only).

 - buffer: buffer visiting the blog file (read-only).

 - publish-dir: where to publish the blog defined by the
   \"#+PUBLISH_DIR:\" header directive or out in the same
   directory as the blog source file.

 - template-dir: location of the template directory defined by
   the \"#+TEMPLATE_DIR:\" header directive or the templates
   directory of the o-blog library.

 - style-dir: path of the \"css\" files defined by the
   \"#STYLE_DIR:\" header directive or style. This directory is
   relative to \"template-dir\".

 - posts-filter: default filter for post defined by the
   \"#POSTS_FILTER:\" header directive or \"+TODO=\\\"DONE\\\".

 - static-filter: default filter for static pages defined by the
   \"#STATIC_FILTER:\" header directive or \"+PAGES={.*}\.

 - snippet-filter default filter for snippets defined by the
   \"#SNIPPET_FILTER:\" header directive or \"+SNIPPET={.*}\".

 - title: Blog title defined by the \"#+TITLE:\" header
   directive.

 - description: blog description defined by the
   \"#+DESCRIPTION:\" header directive.

 - url: Blog base URL defined by the \"#+URL:\" header.

 - language: Blog language defined by the \"#+LANGUAGE:\" header
   or \"en\".

 - default-category: default category for posts defined by the
   \"#DEFAULT_CATEGORY:\" header or \"Blog\".

 - disqus: disqus account (called a forum on Disqus) this system
   belongs to. Defined by the \"#DISQUS\" header.

 - filename-sanitizer: 1-argument function to be used to sanitize
   post filenames. Defined by \#+FILENAME_SANITIZER:\" or
   \"ob-sanitize-string\".
"
  (file nil :read-only)
  (buffer nil :read-only)
  publish-dir
  template-dir
  style-dir
  posts-filter
  static-filter
  snippet-filter
  title
  description
  url
  language
  post-build-shell
  default-category
  disqus
  filename-sanitizer)

(defstruct (ob:post :named)
  "Post structure

 - id: the post numerical id. Posts are sort by reversed
   chronological order. The most recent post get the id 0.

 - title: the post title read from the entry title.

 - timestamp: the post timestamp given by the \"CLOSED\" property
   or the current time.

 - year: numerical year computed from \"timestamp\".

 - month: numerical month computed from \"timestamp\".

 - day: numerical day computed from \"timestamp\".

 - category: category read from \"CATEGORY\" property org
   \"blog\".

 - tags: list of ob:tags.

 - template: template to use for current post read from
   \"TEMPLATE\" property or \"blog_post.html\".

 - filepath: relative path from the blog root directory to the
   post directory (directory only).

 - filename: sanitized filename generated from \"title\".

 - htmlfile: full relative path to the post html file (file and
   directory).

 - path-to-root: relative path from the post html file to the
   blog root.

 - content: raw content of the post (org-mode format).

 - content-html: HTML export of the post."
  id
  title
  timestamp
  year
  month
  day
  category
  tags
  template
  filepath
  filename
  htmlfile
  path-to-root
  content
  content-html)

(defstruct (ob:tags :named)
  "Tag structure with following slots:

 - name: string defying the tag name.
 - safe: web safe tag name for URL.
 - count: how many time the tag is used.
 - size: the font size in percent."
  name safe count size)

;;;###autoload
(defun blog-update ()
  "Simply update the blog"
  (interactive)
  (save-current-buffer
    (let* ((blog-update-time-string (format-time-string "blog-%Y-%m-%d-%H-%M-%S"))
	   (blogfile (concat "~/.cache/" blog-update-time-string ".org")))
      (copy-file "~/org/blog/blog.org" blogfile t)
      (org-publish-blog-sync blogfile)
      (kill-buffer (concat blog-update-time-string ".org")))))

;;;###autoload
(defun org-publish-blog (&optional file async)
  "Publish FILE as a blog synchronously execpt ib ASYNC is
defined, or interactivelly called with `prefix-arg'.
"
  (interactive-form
   (list (or
	  (when (eq major-mode 'org-mode) (buffer-file-name))
	  (read-file-name "Publish blog from: " nil nil t))
	 current-prefix-arg))
  (if async
      (org-publish-blog-async file)
    (org-publish-blog-sync file)))

;;;###autoload
(defun org-publish-blog-sync (file)
  "Publish FILE synchronously."
  (with-temp-buffer (set-buffer (find-file-noselect file))

    (run-hooks 'o-blog-before-publish-hook)

    (setq BLOG (ob-parse-blog-headers))


    ;; (setq blog::ini (buffer-string))
    (goto-char (point-min))

    (while (re-search-forward "blog::insert::.*" nil t)
      (progn
	(setq blog::insert (buffer-substring (point-at-bol) (point-at-eol)))
	(beginning-of-line)
	(replace-regexp blog::insert
			(replace-regexp-in-string "^*" "**"
						  (file-string
						   (replace-regexp-in-string ".*blog::insert::" "" blog::insert))))))


    (goto-char (point-min))
    (while (re-search-forward "blog::album::.*" nil t)
      (progn
	(setq blog::album (buffer-substring (point-at-bol) (point-at-eol)))
	(beginning-of-line)
	(replace-regexp blog::album
			(ob:album (replace-regexp-in-string ".*blog::album::" "" blog::album)))))


    (let* ((start-time (current-time)) ;; for statistic purposes only
	   ;; make sure we are on the correct directory.
	   (default-directory (file-name-directory file))
	   STATIC
	   (STATIC (append STATIC
			   (ob-parse-entries
			    (org-map-entries 'point-marker
					     (ob:blog-static-filter BLOG)
					     'file-with-archives))))
	   (POSTS (ob-parse-entries
	   	   (org-map-entries 'point-marker
	   			    (ob:blog-posts-filter BLOG)
	   			    'file-with-archives)))
	   (ALL-POSTS POSTS)

	   (SNIPPETS (ob-parse-entries
		      (org-map-entries 'point-marker
				       (ob:blog-snippet-filter BLOG)
				       'file-with-archives)))

	   (TAGS (ob-compute-tags POSTS)))

      ;; (erase-buffer)
      ;; (insert blog::ini)
      (save-buffer)
      (goto-char (point-min))

      (ob-write-albums)
      (ob-write-static)
      (ob-write-posts)
      (ob-write-tags)
      (ob-write-index)
      (ob-write-style)



      (let ((syncf (if (functionp 'dired-do-sync)
		       'dired-do-sync 'copy-directory)))
	(funcall syncf (format "%s/%s"
			       (ob:blog-template-dir BLOG)
			       (ob:blog-style-dir BLOG))
		 (ob:blog-publish-dir BLOG)))
      (run-hooks 'o-blog-after-publish-hook)
      (message (format "Blog %s published in %ss"
		       file
		       (format-time-string "%s.%3N"
					   (time-subtract (current-time) start-time)))))))

(defun ob-do-copy (src dst &optional copyf args)
  "Copy SRC into DST. If `dired-do-sync' is found it would be
preferred. Otherwise, `copy-directory' or `copy-files' would be
used.

A copy function COPYF and its arguments ARGS could be specified."
  (let* ((dirp (file-directory-p src))
	 (copyf (cond
		 (copyf copyf)
		 ((functionp 'dired-do-sync) 'dired-do-sync)
		 (dirp 'copy-directory)
		 (t 'copy-file)))
	 (args (or args
		   (when (eq 'copy-file copyf) '(t t t)))))
    (apply copyf src dst args)))

(defun org-blog-publish-run-processes-sentinel (proc change)
  "Sentinel in charge of cleaning `org-publish-blog-async' on success."
  (when (eq (process-status proc) 'exit)
    (let ((status  (process-exit-status proc))
	  (cmd (process-get proc :cmd))
	  (cmd-buf (process-get proc :cmd-buf)))
      (if (not (eq 0 status))
	  (progn
	    (when (process-buffer proc)
	      (set-window-buffer (selected-window) cmd-buf))
	    (error "Org blog ERROR: %s" cmd))
	(message  "Org blog OK: %s" cmd))
      (when cmd-buf (kill-buffer cmd-buf)))))

(defun org-publish-blog-async (file)
  "Publish FILE synchronously."
  (let* ((cmd-line (append command-line-args
			   `("--batch"
			     "-l" ,(concat (file-name-as-directory
					    user-emacs-directory)
					   "init.el")
			     ,@ob-async-opts
			     "--eval"
			     ,(format "(org-publish-blog \"%s\")" file))))
	 (cmd-buf (get-buffer-create (format "ORG blog build %s" file)))
	 (proc (apply 'start-process (car cmd-line)
		      cmd-buf (car cmd-line) (cdr cmd-line))))
    (message "Run: %S" cmd-line)
    (process-put proc :cmd (format "Build %s" file))
    (process-put proc :cmd-buf cmd-buf)
    (set-process-sentinel proc 'org-blog-publish-run-processes-sentinel)))

;; Internal functions

(defun o-blog-publish-linked-files()
  ;;   "Copy files (defined by \"file:\" link prefix) to page related directory."
  ;;   (save-match-data
  ;;     (save-excursion
  ;;       (goto-char (point-min))
  ;;       (let (ret)
  ;; 	(while (re-search-forward "\\(\\[file:\\)\\([^]]+\\)\\(\\]\\)" nil t)
  ;; 	  (let ((prefix (match-string-no-properties 1))
  ;; 		(file  (match-string-no-properties 2))
  ;; 		(suffix (match-string-no-properties 3)))

  ;; 	    (when (file-exists-p file)
  ;; 	      (replace-match
  ;; 	       (format "%s%s/%s/%s%s"
  ;; 		       prefix
  ;; 		       (file-relative-name "." filepath)
  ;; 		       (file-name-sans-extension htmlfile)
  ;; 		       (file-name-nondirectory file) suffix ))

  ;; 	      (add-to-list 'ret file))))

  ;; 	(when ret
  ;; 	  ;; create a redirection page as index.html into files' directory
  ;; 	  (with-temp-buffer
  ;; 	    (insert
  ;; 	     (mapconcat 'identity
  ;; 			`(,(format "* Redirect from (%s)" title)
  ;; 			  ":PROPERTIES:"
  ;; 			  ,(format ":PAGE: %s/index.html" (file-name-sans-extension htmlfile))
  ;; 			  ":TEMPLATE: page_redirect.html"
  ;; 			  ":END:")
  ;; 			"\n"))
  ;; 	    (org-mode)
  ;; 	    (goto-char (point-min))
  ;; 	    (setf STATIC (append STATIC (list (ob-parse-entry)))))

  ;; 	  ;; copy all files into their target directory.
  ;; 	  (loop for f in ret
  ;; 		do (let ((target (format "%s/%s/%s"
  ;; 					 (ob:blog-publish-dir BLOG)
  ;; 					 ;; file path is nil when exporting static page?
  ;; 					 ;;(or filepath ".")
  ;; 					 (file-name-sans-extension htmlfile)
  ;; 					 (file-name-nondirectory f))))
  ;; 		     (mkdir (file-name-directory target) t)
  ;; ;		     (ob-do-copy f target)
  ;; ))))))
  )
;; (add-hook 'o-blog-html-plugins-hook 'o-blog-publish-linked-files)

(defun ob-parse-blog-headers (&optional file)
  "Parse blog related variable from current-buffer."
  (let* ((file (or file (buffer-file-name)))
	 (blog (make-ob:blog :file file :buffer (current-buffer))))
    (setf (ob:blog-disqus blog) (ob:get-header "DISQUS"))
    (setq blog::copyright (ob:get-header "COPYRIGHT"))
    (setq blog::copyright-life (ob:get-header "COPYRIGHT_LIFE"))
    (setq blog::ftpdir (ob:get-header "FTP_DIR"))
    (setq blog::imgdir (ob:get-header "IMG_DIR"))
    (setq blog::description (ob:get-header "DESCRIPTION"))
    (setq blog::menu (ob:get-header "MENU"))
    (setq blog::title (ob:get-header "TITLE"))
    (setq blog::comments (ob:get-header "COMMENTS"))
    (setq blog::publishdir (or (ob:get-header "PUBLISH_DIR") "out"))
    (setf (ob:blog-publish-dir blog) (or (ob:get-header "PUBLISH_DIR") "out"))
    (setf (ob:blog-template-dir blog) (or (ob:get-header "TEMPLATE_DIR")
					  (concat
					   (file-name-directory
					    (file-name-directory
					     (find-library-name "o-blog")))
					   "templates")))
    (setf (ob:blog-style-dir blog) (or (ob:get-header "STYLE_DIR") "style"))
    (setf (ob:blog-posts-filter blog) (or (ob:get-header "POSTS_FILTER") "+TODO=\"DONE\""))
    (setf (ob:blog-static-filter blog) (or (ob:get-header "STATIC_FILTER") "+PAGE={.+\.html}"))
    (setf (ob:blog-snippet-filter blog) (or (ob:get-header "SNIPPET_FILTER") "+SNIPPET={.+}"))
    (setf (ob:blog-title blog) (or (ob:get-header "TITLE") "title"))
    (setf (ob:blog-description blog) (or (ob:get-header "DESCRIPTION") "Description"))
    (setf (ob:blog-url blog) (or (ob:get-header "URL") ""))
    (setf (ob:blog-language blog) (or (ob:get-header "LANGUAGE") "en"))
    (setf (ob:blog-post-build-shell blog) (ob:get-header "POST_BUILD_SHELL" t))
    (setf (ob:blog-default-category blog) (or (ob:get-header "DEFAULT_CATEGORY") "Blog"))
    (setf (ob:blog-disqus blog) (ob:get-header "DISQUS"))
    (setf (ob:blog-filename-sanitizer blog)
	  (let ((ofs (ob:get-header "FILENAME_SANITIZER")))
	    (if (and ofs (functionp (intern ofs)))
		(intern ofs)
	      'ob-sanitize-string)))
    blog))

(defun ob-parse-entries (markers)
  "Parse blog entries from current buffer.

MARKERS is a list of entries given by `org-map-entries'."
  ;; 初始化文章计数id
  (setq post::id 0)

  (save-excursion
    (loop for marker in markers
	  with posts = nil
	  ;; Parse each entry into posts
	  collect (with-current-buffer (marker-buffer marker)
		    (goto-char (marker-position marker))
		    (setq post::id (+ post::id 1))
		    (ob-parse-entry post::id))
	  into posts
	  ;; Then wee need to set the post id in all all sorted posts.
	  finally return (loop for post in (sort posts 'ob-sort-posts-by-date)
			       with id = (+ post::id 1)
			       do (setf (ob:post-id post) id)
			       and do (incf id -1)
			       and collect post))))

(defun ob-sort-posts-by-date (a b)
  "Sort both A and B posts by date (newer posts first)."
  (> (float-time (ob:post-timestamp a))
     (float-time (ob:post-timestamp b))))


(defun ob-parse-entry(post::id)
  "Parse blog entry from current position"
  (when (search-forward-regexp org-complex-heading-regexp
			       (point-at-eol)
			       t)
    (let* ((title (match-string-no-properties 4))
	   ;; tags is a list of `ob:tags'
	   ;; to be compliant with org tag syntax (no "-" org space)
	   ;; "_" would be replaced with " " and "@" by "-"
	   (tags (loop for tn in (org-get-local-tags)
		       with td
		       do (setf td
				(replace-regexp-in-string
				 "_" " "
				 (replace-regexp-in-string "@" "-" tn)))
		       and collect (make-ob:tags
				    :name td
				    :safe (ob:sanitize-string td))))

	   ;; Timestamp is taken from either the CLOSED property or the
	   ;; current timestamp.
	   (timestamp (apply 'encode-time
			     (org-parse-time-string
			      (or (org-entry-get (point) "CLOSED")
				  (time-stamp-string "%:y-%02m-%02d %02H:%02M:%02S %u")))))
	   ;; Some other time variables
	   (year (string-to-number (format-time-string "%Y" timestamp)))
	   (month (string-to-number (format-time-string "%m" timestamp)))
	   (day (string-to-number (format-time-string "%d" timestamp)))
	   
	   (category (or (org-entry-get (point) "category")
			 (car (last (org-get-outline-path)))
			 (org-entry-get (point) "ARCHIVE_OLPATH")
			 (ob:blog-default-category BLOG)))

	   (page (org-entry-get (point) "PAGE"))


	   ;;; 固定链接
	   ;;	   (filename (format "%s%.2d%.2d" year month day))
	   ;; 以id作为文件名
	   (filename (format "%s.html" post::id))
	   (filepath (format "archives"))
	   (htmlfile (format "%s/%s" filepath filename))


	   (content (ob-get-entry-text)))

      (when page
	(setq 
	 post::id (- post::id 1)  ;; page 不是 post 除去计数
	 htmlfile page
	 filename (file-name-sans-extension (file-name-nondirectory htmlfile))
	 filepath (file-name-directory htmlfile)))

      (make-ob:post :title title
		    :tags tags
		    :timestamp timestamp
		    :year year
		    :month month
		    :day day
		    :filename filename
		    :filepath filepath
		    :path-to-root (file-relative-name "." filepath)
		    :htmlfile htmlfile
		    :template (or (org-entry-get (point) "TEMPLATE")
				  (if page "blog_static.html" "blog_post.html"))
		    :content content
		    :content-html (ob-export-string-to-html content)
		    :category category
		    ))))

(defun ob-get-entry-text ()
  "Return entry text from point with not properties.

Please note that a blank line _MUST_ be present between entry
headers and body."
  (save-excursion
    (save-restriction
      (save-match-data
	(org-narrow-to-subtree)
	(let ((text (buffer-string)))
	  (with-temp-buffer
	    (insert text)
	    (goto-char (point-min))
	    (org-mode)
	    (while (<= 2 (save-match-data (funcall outline-level)))
	      (org-promote-subtree))
	    (run-hooks 'o-blog-html-plugins-hook)
	    (goto-char (point-min))
	    (when (search-forward-regexp "^\\s-*$" nil t)
	      (goto-char (match-end 0)))
	    (save-excursion
	      (insert "#+OPTIONS: H:7 num:nil  toc:nil d:nil todo:nil <:nil pri:nil tags:nil\n\n"))
	    (buffer-substring-no-properties (point) (point-max))))))))


(defun ob-export-string-to-html (string)
  "Convert STRING to html using `org-mode' syntax."
  (with-temp-buffer
    (insert string)
    (org-mode)
    (substring-no-properties (org-export-as-html nil nil nil 'string t))))


(defun ob-compute-tags (posts &optional min_r max_r)
  "Return a list of all tags sorted by usage.

Each item is: \(TAG COUNT PERCENT \)

CONTENT-LIST is a list of all articles such as generated in
`org-publish-blog'.

MIN_R and MAX_R are the minimum and maximum percentage value. If
not provided 80 and 220 are used."
  (let* ((tags (sort (loop for post in posts
			   append (loop for tn in (ob:post-tags post)
					when (ob:tags-p tn)
					collect (ob:tags-name tn)))
		     #'string<))
	 (min_r (or min_r 80))
	 (max_r (or max_r 220))
	 (min_f (length tags))
	 (max_f 0))

    (loop for item in
	  ;; Here extract uniq tags and count occurrences
	  ;; (such as uniq -c does)
	  ;; Each item of returned list is
	  ;; (VALUE COUNT)
	  (loop for (i . j) on tags
		with k = 1
		when (string= i (car j)) do (incf k)
		else collect (progn
			       (when (> k max_f) (setf max_f k))
			       (when (< k min_f) (setf min_f k))
			       (cons i (list k)))
		and do (setf k 1))

	  collect (let ((val (cadr item)))
		    (make-ob:tags
		     :name (car item)
		     :safe (ob:sanitize-string (car item))
		     :count val
		     ;; This is the tricky part
		     ;; Formula is:
		     ;; % = min_r + (val - min_f) * (max_r - min_r) / (max_f - min_f)
		     ;; the `max' is on purpose in case of max_f = min_f
		     :size (+ min_r
			      (/
			       (* (- val min_f) (- max_r min_r))
			       (max 1.0 (float (- max_f min_f))))))))))

(defun ob-eval-lisp()
  "Eval embeded lisp code defined by <lisp> tags in html fragment
when publishing a page."
  (save-excursion
    (save-restriction
      (save-match-data
	;; needed for thing-at-point
	(html-mode)
	(goto-char (point-min))
	(let ((open-tag "<lisp>\\|{lisp}\\|\\[lisp\\]")
	      (close-tag "</lisp>\\|{/lisp}\\|\\[/lisp\\]")
	      beg end sexp)
	  (while (search-forward-regexp open-tag nil t)
	    (setq beg (- (point) (length  (match-string 0))))
	    (when (search-forward-regexp close-tag nil t)
	      (setq end (point))
	      (backward-char (length (match-string 0)))
	      (backward-sexp)
	      (setq sexp (substring-no-properties (thing-at-point 'sexp)))
	      (narrow-to-region beg end)
	      (delete-region (point-min) (point-max))
	      (insert
	       (save-match-data
		 (condition-case err
		     (let ((object (eval (read sexp))))
		       (cond
			;; result is a string
			((stringp object) object)
			;; a list
			((and (listp object)
			      (not (eq object nil)))
			 (let ((string (pp-to-string object)))
			   (substring string 0 (1- (length string)))))
			;; a number
			((numberp object)
			 (number-to-string object))
			;; nil
			((eq object nil) "")
			;; otherwise
			(t (pp-to-string object))))
		   ;; error handler
		   (error
		    (format "Lisp error in %s: %s" (buffer-file-name) err)))))
	      (goto-char (point-min))
	      (widen))))))))


;; Publish functions

(defun file-string (file)
  "Read the contents of a file and return as a string."
  (with-temp-buffer
    (if (file-exists-p file)	  
	(insert-file-contents file))
    (buffer-string)))

(defun zeno-string (string)
  "处理string"
  (with-temp-buffer
    (insert string)
    (goto-char (point-min))
    (replace-string " " "")
    (buffer-string)))

(defun ob-write-file (file)
  "Write current buffer to FILE and create full path if necessary."
  ;; ZENO

  (while (re-search-forward "page::head::.*" nil t)
    (progn
      (setq page::head (buffer-substring (point-at-bol) (point-at-eol)))
      (beginning-of-line)
      (replace-regexp
       page::head "")
      (goto-char (point-min))
      (replace-regexp
       "</head>" (format "%s\n</head>"
			 (replace-regexp-in-string ".*page::head::" "" page::head)))))

  ;; menu 要放在最上面以保证解析
  (goto-char (point-min))
  (replace-string "blog::menu" blog::menu)

  (goto-char (point-min))
  (setq post::tags "")
  (if (boundp 'POST)
      (loop for tag in (ob:post-tags POST)
	    do (setq post::tags (concat post::tags (format "<a href=\"%s/tags/%s.html\">%s</a>"
							   (ob:path-to-root) (ob:tags-name tag) (ob:tags-name tag))))))
  (replace-string "post::tags" post::tags)

  (setq page::title (if (boundp 'POST) (ob:post-title POST) (ob:blog-title BLOG)))

  (goto-char (point-min))
  (if (equal blog::title page::title)
      (replace-string "<li class=\"title\">page::title</li>" ""))

  (goto-char (point-min))
  (replace-string "<li>" "正则缓冲汉字<li>")
  (goto-char (point-min))
  (replace-regexp (concat "<li>\\Cc*" page::title "</a></li>") "")
  (goto-char (point-min))
  (replace-string "正则缓冲汉字" "")

  (goto-char (point-min))
  (replace-string "blog::root" (ob:path-to-root))

  (goto-char (point-min))
  (replace-string "blog::description" blog::description)

  (goto-char (point-min))
  (replace-string "blog::comments" blog::comments)

  (goto-char (point-min))
  (replace-string "blog::title" blog::title)


  (goto-char (point-min))
  (if (string-match "life</a></li>" (buffer-string))
      (replace-string "blog::copyright" blog::copyright-life)
    (replace-string "blog::copyright" blog::copyright))

  (goto-char (point-min))
  (if (string-match "post::time" (buffer-string))
      (replace-string "post::time" (ob:format-date (ob:post-timestamp POST) "%Y-%02m-%02d %02H:%02M")))

  ;; page title放在最后
  (goto-char (point-min))
  (replace-string "page::title" page::title)


  ;; 不要使用tab进行缩进
  (setq indent-tabs-mode nil)

  (setq ob:ifpre nil)
  (goto-char (point-min))
  (delete-blank-lines)
  (while (search-forward "\n" nil t)
    (progn
      (if (string-match "</pre>" (buffer-substring (point-at-bol) (point-at-eol)))
	  (setq ob:ifpre nil))
      (unless ob:ifpre
	(indent-for-tab-command)
	(delete-blank-lines))
      (if (string-match "<pre" (buffer-substring (point-at-bol) (point-at-eol)))
	  (setq ob:ifpre t))))
  (goto-char (point-min))
  (replace-regexp "^ *</pre>" "</pre>")

  ;; 只有文件变化才输出
  (unless (equal (zeno-string (buffer-string)) (zeno-string (file-string file)))
    (progn
      (mkdir (file-name-directory file) t)
      (write-file file)
      (setq ftpfile (concat blog::ftpdir (car (last (split-string file (ob:blog-publish-dir BLOG)))))
	    diffiles (concat "~/public_html/diffiles" (car (last (split-string file (ob:blog-publish-dir BLOG))))))
      ;; 只有ftp地址设定才同步
      (if (string-match "/ftp:" blog::ftpdir)
	  (write-file ftpfile)
	(progn
	  (mkdir (file-name-directory diffiles) t)
	  (write-file diffiles))))))

(defun ob-write-index()
  "Publish all indexes (default, categories, year, month)"
  (let ((BREADCRUMB "Archives"))
    (ob-write-index-to-file "blog_index.html"
			    (format "%s/index.html"
				    (ob:blog-publish-dir BLOG))))

  (ob-write-index-to-file "blog_rss.html"
  			  (format "%s/feed/index.xml"
  				  (ob:blog-publish-dir BLOG)))


  (loop for CATEGORY in (ob:get-posts nil nil nil 'category)
	with PATH-TO-ROOT = ".."
	do
	(loop for YEAR in (ob:get-posts
			   (lambda (x) (equal CATEGORY (ob:post-category x)))
			   nil nil 'year)
	      with PATH-TO-ROOT = "../.."
	      do
	      (loop for MONTH in (ob:get-posts
				  (lambda (x) (and
					       (equal CATEGORY (ob:post-category x))
					       (= YEAR (ob:post-year x))))
				  nil nil 'month)
		    with PATH-TO-ROOT = "../../.."
		    do (ob-process-index "blog_index_month.html" CATEGORY YEAR MONTH))
	      and do (ob-process-index "blog_index_year.html" CATEGORY YEAR))
	and do (unless (equal "." CATEGORY)
		 (ob-process-index "blog_index_category.html" CATEGORY))))

(defun ob-process-index (template &optional category year month)
  "Low-level function for `ob-write-index'.
Template is read from TEMPLATE file.

If provided CATEGORY YEAR and MONTH are used to select articles."
  (let* ((fp (format "%s/%s/index.html"
		     (ob:blog-publish-dir BLOG)
		     (cond
		      ((and category year month) (format "%s/%.4d/%.2d" category year month))
		      ((and category year) (format "%s/%.4d" category year))
		      (t category))))

	 (POSTS (ob:get-posts
		 (lambda (x) (and
			      (if category (equal category (ob:post-category x)) t)
			      (if year (= year (ob:post-year x)) t)
			      (if month (= month (ob:post-month x)) t))))))
    ;; Zeno :: 不产生年月索引	 
    ;;(ob-write-index-to-file template fp)
    ))

(defun ob-write-index-to-file (template outfile)
  ""
  (with-temp-buffer
    "*ORG blog publish index*"
    (erase-buffer)
    (insert-file-contents
     (format "%s/%s" (ob:blog-template-dir BLOG) template))
    (ob-eval-lisp)
    (ob-write-file outfile)))

(defun ob-write-style ()
  "Publish css"
  (ob-write-index-to-file 
   "style/css.css"
   (format "%s/%s"
	   (ob:blog-publish-dir BLOG)
	   "style/css.css")))

(defun ob-write-albums ()
  (let ((albums (directory-files blog::imgdir)))
    (dolist (album albums)
      (unless (or (equal album ".") (equal album "..") (equal album "slimbox"))
	(when (file-directory-p (concat blog::imgdir "/" album))
	  (let*
	      ((dir (concat blog::imgdir "/" album))
	       (files (directory-files dir))
	       (ndir (concat blog::publishdir "/img/" album)))
	    (mkdir ndir t)
	    (dolist (file files)
	      (let ((filename
		     (concat ndir "/" (md5 file) "." (file-name-extension file))))

		(unless (or (equal file ".")
			    (equal file "..")
			    (file-exists-p filename))

		  (setq ftpfile (replace-regexp-in-string blog::publishdir blog::ftpdir filename))
		  
		  (if (string-match "/ftp:" blog::ftpdir)
		      (copy-file (concat dir "/" file) ftpfile t))

		  (copy-file (concat dir "/" file) filename))))))))))

(defun ob-write-static ()
  "Publish static pages"
  (loop for POST in STATIC
	do (ob-write-index-to-file
	    (ob:post-template POST)
	    (format "%s/%s"
		    (ob:blog-publish-dir BLOG)
		    (ob:post-htmlfile POST)))))

(defun ob-write-posts ()
  "Publish all posts"
  (loop for POST in POSTS
	do (ob-write-index-to-file
	    (ob:post-template POST)
	    (format "%s/%s"
		    (ob:blog-publish-dir BLOG)
		    (ob:post-htmlfile POST)))))

(defun ob-write-tags ()
  "Publish all tags into directory named \"tags\"."
  (let ((PATH-TO-ROOT "..")
	(BREADCRUMB "Tags"))
    (ob-write-index-to-file "blog_tags.html"
			    (format "%s/tags/index.html"
				    (ob:blog-publish-dir BLOG)))

    (loop for TAG in TAGS
	  do
	  (ob-write-index-to-file "blog_tags-details.html"
				  (format "%s/tags/%s.html"
					  (ob:blog-publish-dir BLOG)
					  (ob:tags-name TAG))))))

(defun ob-sanitize-string (s)
  "Sanitize string S by:

- converting all charcters ton pure ASCII
- replacing non alphanumerical chars to \"-\"
- downcasing all letters
- trimming leading and tailing \"-\""
  (loop for c across s
	with cd
	with gc
	with ret
	do (progn
	     (setf gc (get-char-code-property c 'general-category))
	     (setf cd (get-char-code-property c 'decomposition)))
	if (or (member gc '(Lu Ll Nd)) (= ?- c))
	collect (downcase
		 (char-to-string (if cd (car cd)  c)))
	into ret
	else if (member gc '(Zs))
	collect "-" into ret
	finally return (replace-regexp-in-string
			"--+" "-"
			(replace-regexp-in-string
			 "^-+\\|-+$" ""
			 (mapconcat 'identity ret "")))))

;; template accessible functions

(defun ob:album (album)
  (let (html
	(files (directory-files (concat blog::imgdir "/" album))))
    (setq html (dolist (file files html)
		 (unless (or (equal file ".") (equal file ".."))
		   (setq html
			 (concat
			  html
			  (format "<a class=\"img\" href=\"blog::root/img/%s/%s\" title=\"%s\">%s</a>\n"
				  album
				  (concat (md5 file) "." (file-name-extension file))
				  (file-name-sans-extension (file-name-sans-extension file))
				  (file-name-sans-extension (file-name-sans-extension file))))))))
    (format "#+begin_html
<script type=\"text/javascript\" src=\"http://lib.sinaapp.com/js/jquery/1.8/jquery.min.js\"></script>
<script type=\"text/javascript\" src=\"blog::root/img/slimbox/js/slimbox2.js\"></script>
page::head::<link rel=\"stylesheet\" href=\"blog::root/img/slimbox/css/slimbox2.css\" type=\"text/css\" media=\"screen\" />
%s
#+end_html" html)))

(defun ob:sanitize-string(s)
  "Sanitize string S using function defined by
`filename-sanitizer' slot in `ob:blog' structure."
  (funcall (ob:blog-filename-sanitizer BLOG) s))

(defun ob:get-posts (&optional predicate count sortfunc collect)
  "Return posts (from `POSTS' as defined in `org-publish-blog')
matching PREDICATE. Limit to COUNT results if defined and sorted
using SORTFUNC.

PREDICATE is a function run for each post with the post itself as
argument. If PREDICATE is nil, no filter would be done on posts.

SORTFUNC is used a `sort' PREDICATE.

If COLLECT is defined, only returns the COLLECT field of a
`ob:post' structure.

Examples:

 - Getting last 10 posts:
   \(ob:get-posts nil 10\)

 - Getting post from January 2012:
   \(ob:get-posts
      \(lambda \(x\)
         \(and \(= 2012 \(ob:post-year x\)\)
              \(= 1 \(ob:post-month x\)\)\)\)\)

 - getting all categories
    \(ob:get-posts nil nil nil 'category\)

"
  (let* ((posts (if predicate
		    (loop for post in POSTS
			  when (funcall predicate post)
			  collect post)
		  POSTS))
	 (len (length posts)))
    (when (and count (> count 0) (< count len))
      (setq posts (butlast posts (- len count))))
    (when sortfunc
      (setq posts (sort posts sortfunc)))
    (when collect
      (setq posts
	    (loop for post in posts
		  with ret = nil
		  collect (funcall (intern (format "ob:post-%s" collect)) post)
		  into ret
		  finally return (delete-dups ret))))
    posts))

(defun ob:get-post-by-id (id)
  "Return post which id is ID"
  (when (>= id 0)
    (nth id POSTS)))

(defun ob:get-snippet (name)
  "Get first snippet matching NAME."
  (let ((POSTS SNIPPETS))
    (car
     (ob:get-posts (lambda(x) (equal name (ob:post-title x)))))))

(defun ob:get-header (header &optional all)
  "Get HEADER from blog buffer as defined in BLOG global context
variable.

Returns only fist match except if ALL is defined."
  (with-current-buffer
      ;; Be sure we are in blog buffer
      ;; (if (boundp 'BLOG)
      ;; 	  (ob:blog-buffer BLOG)
      ;; 	(current-buffer))

    (current-buffer)

    (save-excursion
      (save-restriction
	(save-match-data
	  (widen)
	  (goto-char (point-min))
	  (let (values)
	    (while (re-search-forward (format "^#\\+%s:?[ \t]+\\(.*\\)" header) nil t)
	      (add-to-list 'values (substring-no-properties (match-string 1))))
	    (if all
		values
	      (car values))))))))

(defun ob:insert-template (template)
  "Insert TEMPLATE in current buffer."
  (insert
   (with-temp-buffer
     "*Org-Publish-Template*"
     (erase-buffer)
     (insert-file-contents (format "%s/%s" (ob:blog-template-dir BLOG) template))
     (ob-eval-lisp)
     (buffer-string))))

(defun ob:format-date (date &optional format locale)
  "Format DATE using FORMAT and LOCALE.

DATE can heither be string suitable for `parse-time-string' or a
list of interger using `current-time' format.

FORMAT is a `format-time-string' compatible definition. If not
set ISO8601 \"%Y-%m-%dT%TZ\" format would be used."
  (let* ((date (cond
		((stringp date)
		 (apply 'encode-time
			(parse-time-string date)))
		((listp date)
		 date)))
	 ;;	 (format (or format "%Y-%m-%dT%TZ"))
	 (format (or format "%Y-%m-%dT00:00:00Z"))
	 (system-time-locale locale))
    (format-time-string format date)))

(defun ob:get-last-post (&optional category nth)
  "Get the NTH last post in from CATEGORY or \"blog\" if not defined."
  (let ((POST ALL-POSTS)
	(nth (or nth 0)))
    (nth nth (ob:get-posts (lambda (x)
			     (equal (or category "blog")
				    (ob:post-category x)))))))

(defun ob:path-to-root ()
  "Return path to site root from `PATH-TO-ROOT' or `POST'
path-to-root slot."
  (cond
   ((boundp 'PATH-TO-ROOT) PATH-TO-ROOT)
   ((boundp 'POST) (ob:post-path-to-root POST))
   (t ".")))

(provide 'o-bloger)