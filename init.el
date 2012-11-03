;; Time-stamp: <2012-11-03 08:48:41 Zeno Zeng>
(setq user-login-name "Zeno Zeng")
;;;; load-path

(add-to-list 'load-path "~/.emacs.d/modes")
(add-to-list 'load-path "~/.emacs.d/modes/ac-mode")
(add-to-list 'load-path "~/.emacs.d/init")
(add-to-list 'load-path "~/.emacs.d/init/emacs-w3m")
(add-to-list 'load-path "~/.emacs.d/o-bloger")
(add-to-list 'load-path "~/.emacs.d/elpa/undo-tree-0.5.2/")
(add-to-list 'load-path "~/.emacs.d/elpa/org-20120903")

;;;; UNDO TREE
(require 'undo-tree)
(global-undo-tree-mode)

;;;; END Undo Tree

;;;; 有道 API ::依赖xml.el,xml-parse.el
;;获取要翻译的词典  
(defun get-current-word ()  
  (interactive)  
  (let ((begin (point-min)) (end (point-max)))  
    (save-excursion        
      (when (not mark-active)          
	(backward-word)  
	(mark-word))  
      (setq begin (region-beginning)  
	    end (region-end)))  
    (buffer-substring begin end)))  

;;抓取翻译结果  
(defun get-translate-result (word)  
  (shell-command-to-string (concat (format "curl 'http://fanyi.youdao.com/openapi.do?keyfrom=ZenoBlog&key=636489742&type=data&doctype=xml&version=1.1&q=%s' 2>/dev/null" word))))  

;;分析翻译结果,并返回显示字符串  
(defun analytic-translate-result (translateresult)  
  (let* ((root (with-temp-buffer (insert translateresult)  
				 (xml-parse-region (point-min) (point-max))))  
	 (youdao-fanyi (car root))  
	 (basic (car (xml-get-children youdao-fanyi 'basic)))  
	 (explains-ex (xml-get-children (car (xml-get-children basic 'explains)) 'ex))  
	 (phonetic-texts (car (xml-node-children (car (xml-get-children basic 'phonetic)))))   
	 (explains-texts (concat phonetic-texts "\n")))  
    (loop for ex in explains-ex  
	  do (setq explains-texts (concat explains-texts  (car (xml-node-children ex)) "\n")))  
    explains-texts))  

;;主函数  
(defun lookup-word ()  
  (interactive)  
  (let* ((word (get-current-word))  
	 (translate-result (get-translate-result word))  
	 (explains-texts (analytic-translate-result translate-result)))  
    (tooltip-show explains-texts t)))  
;;绑定到Ctrl-c f组合键上  
(global-set-key (kbd "C-c f") 'lookup-word)  
;;;; END 有道 API

;;;; Frames and Graphical Displays

;;; UI
;; 关闭Emacs启动时提示信息
;; (setq inhibit-startup-message t)
;; 各种bar
(set-scroll-bar-mode nil)
(blink-cursor-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
;; (menu-bar-mode (quote toggle))
;;; Modeline
;; 电池
(setq battery-mode-line-format "[%b%p%%]")
(display-battery-mode 1)
;; 时间
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-format "[%m-%d %a %H:%M]")
;; 不要显示load average
(setq display-time-load-average-threshold 100)
(display-time)
(setq display-time-24hr-format t)
(setq column-number-mode t)
(setq line-number-mode t)
;; 标题栏 
(setq frame-title-format "%f")
;; bu显示匹配括号
(show-paren-mode nil)
;; 匹配括号时不跳至另一括号
;;(setq show-paren-style 'parentheses)
;; "yes or no" =>  "y or n"
(fset 'yes-or-no-p 'y-or-n-p)
;; 高亮显示mark
(transient-mark-mode t)
;; 开启语法高亮。
(global-font-lock-mode 1)
;; 开启 ido mode
(ido-mode nil)
;; highlight-parentheses
(require 'highlight-parentheses)
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

;; 光标靠近鼠标指针时，让鼠标指针自动让开，别挡住视线。
(mouse-avoidance-mode 'animate)

;; MY YANK
;; 例子：
;; C-u 100 C-y
;; 复制一百次
(defun my-yank (arg)
  "Yank ARG times."
  (interactive "p")
  (dotimes (var arg)
    (yank)))

;; 设置个人信息
(setq user-full-name "Zeno Zeng")
(setq user-mail-address "i@zva.me")

;;;; PHP Mode
(setq php-manual-path "~/doc/php-manual/")
;;;; END PHP Mode


;;;; Org Mode
(setq org-log-done t)

;;obloger
(require 'o-bloger)
;;htmlize
(require 'htmlize)

;; 在行首 C-k 时，同时删除该行。
(setq-default kill-whole-line t)

;; 自动更新time-stamp
(setq time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S %u")
(add-hook 'before-save-hook 'time-stamp)
;; 不要使用tab进行缩进
(setq indent-tabs-mode nil)

;; 一键缩进
(defun indent-buffer ()
  "Indent the current buffer"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\n" nil t)
      (ignore-errors
        (indent-for-tab-command)))))

;;设定删除保存记录为200，可以方便以后无限恢复
(setq kill-ring-max 200)

;;允许emacs和外部其他程式的粘贴
(setq x-select-enable-clipboard t)

;;; w3m
(require 'w3m)
;;设置w3m为emacs的默认浏览器
(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(global-set-key "\C-xm" 'browse-url-at-point)

;;;; Modes

;; GIMP MODE
(load "~/.emacs.d/modes/gimp-mode/gimp-init.el")
(global-set-key "\C-cg" 'gimp-selector)

;; Now you can run the GIMP with `M-x run-gimp'.
;; Alternatively, connect to GIMP server with `M-x gimp-cl-connect'.

;; Type `M-x gimp-help' for help.

;; 代码折叠

(add-hook 'c-mode-common-hook   'my-hs)
(add-hook 'emacs-lisp-mode-hook 'my-hs)
(add-hook 'java-mode-hook       'my-hs)
(add-hook 'ess-mode-hook        'my-hs)
(add-hook 'perl-mode-hook       'my-hs)
(add-hook 'sh-mode-hook         'my-hs)
(add-hook 'scheme-mode-hook     'my-hs)
(add-hook 'css-mode-hook     'my-hs)
(add-hook 'php-mode-hook     (lambda ()
                               (my-hs)
                               (hs-hide-level 2)))


;; 导出的时候就不必隐藏了。
(add-hook 'htmlize-before-hook   'hs-show-all)

(setq hs-hide-comments-when-hiding-all nil)

(defun my-hs ()
  "My hideshow mode."
  (hs-minor-mode)
  (hs-hide-all))

(defun archive-region (beg end)
  (interactive (list (point) (mark)))
  (let ((file (concat (replace-regexp-in-string "/home/zys/" "/home/zys/.archive/" (buffer-file-name)))))
    (mkdir (file-name-directory file) t)
    (append-to-file beg end file)
    (kill-region beg end)))

;; AC
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/modes/ac-mode/dict")
(ac-config-default)

;; Markdown
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.mkd" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("\\.md" . markdown-mode) auto-mode-alist))

;; PHP
;; (autoload 'html-php-mode "html-php.el"
;;   "multi-mode PHP embedded in HTML" t)
(autoload 'php-mode "php-mode.el"
  "Major mode for editing PHP files" t)
;; (setq auto-mode-alist
;;       (cons '("\\.php" . html-php-mode) auto-mode-alist))
(setq auto-mode-alist
      (cons '("\\.php" . php-mode) auto-mode-alist))
;; Less
(autoload 'less-css-mode "less-css-mode.el"
  "Major mode for editing less-css files" t)
(setq auto-mode-alist
      (cons '("\\.less" . less-css-mode) auto-mode-alist))
;; Html mode
(setq auto-mode-alist
      (cons '("\\.html" . html-mode) auto-mode-alist))
;; Rainbow
(dolist (hook '(css-mode-hook
		html-mode-hook
		python-mode-hook
		less-css-mode-hook
		lisp-mode-hook))
  (add-hook hook (lambda () (rainbow-mode 1))))
;;;; END Modes


;;;; Firefox
(defun ff()
  "Start Firefox and clock in."
  (interactive)
  (save-excursion
    (eshell-command "firefox")))
;;;; END Firefox

;;;; Backup
(defun backup-this-file ()
  "Backup this file"
  (interactive)
  (unless
      (or (string-match ".jpg" (buffer-name))
          (string-match "ftp" (buffer-file-name)))
    (let ((bakfile (concat (replace-regexp-in-string "/home/zys/" "/home/zys/.backups/" (buffer-file-name))
			   (format-time-string "/%Y-%m-%d/%H:%M:%S" (current-time))
			   "."
			   (file-name-extension (buffer-file-name)))))
      (save-buffer)
      (mkdir (file-name-directory bakfile) t)
      (copy-file (buffer-file-name) bakfile t)
      )))
(defadvice find-file (after zeno-advice-find-file-clock)
  (backup-this-file))
(ad-activate 'find-file)
(defadvice ido-find-file (after zeno-advice-ido-find-file-clock)
  (backup-this-file))
(ad-activate 'ido-find-file)
;; 备份文档路径
(setq backup-directory-alist (quote (("." . "~/.backups"))))
;;生成临时文件
(setq-default make-backup-file t)
(setq make-backup-file t)
(setq make-backup-files t)
(setq delete-old-versions t)
;;自动存盘
(setq auto-save-mode t)
;;击键100次自动保存
(setq auto-save-interval 100)


;;;; END Backup

;;;; ORG MODE
;;(setq org-agenda-files (list  "~/org/tasks.org"))
(setq org-hide-leading-stars t)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done 'time)

;; Tex
(setq org-latex-to-pdf-process
      '("xelatex -interaction nonstopmode %b"
	"xelatex -interaction nonstopmode %b"))

;; (require 'org-latex)
;; (unless (boundp 'org-export-latex-classes)
;;   (setq org-export-latex-classes nil))
;; (add-to-list 'org-export-latex-classes
;; 	     '("article"
;; 	       "\\documentclass[11pt]{article}"
;; 	       ("\\section{%s}" . "\\section*{%s}")
;; 	       ("\\subsection{%s}" . "\\subsection*{%s}")
;; 	       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
;; 	       ("\\paragraph{%s}" . "\\paragraph*{%s}")
;; 	       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
;; (add-to-list 'org-export-latex-classes
;; 	     '("simpledoc"
;; 	       "\\documentclass[11pt]{article}
;; \\usepackage[utf8]{inputenc}
;; \\usepackage[T1]{fontenc}
;; \\usepackage{fixltx2e}
;; \\usepackage{graphicx}
;; \\usepackage{longtable}
;; \\usepackage{float}
;; \\usepackage{wrapfig}
;; \\usepackage{soul}
;; \\usepackage{textcomp}
;; \\usepackage{marvosym}
;; \\usepackage{wasysym}
;; \\usepackage{latexsym}
;; \\usepackage{amssymb}
;; \\tolerance=1000
;; \\usepackage{fontspec}
;; \\usepackage{xeCJK}
;; \\usepackage{titlesec}
;; \\usepackage{indentfirst}
;; \\usepackage{geometry}
;; \\usepackage[hidelinks,CJKbookmarks=true]{hyperref}%不显示链接的边框和颜色
;; \\setcounter{tocdepth}{1}
;; \\setcounter{secnumdepth}{0}
;;          [NO-DEFAULT-PACKAGES]"
;; 	       ("\\section{%s}"."\\section*{%s}\n\\addcontentsline{toc}{section}{}\n\\phantomsection")
;; 	       ("\\subsection{%s}" . "\\subsection*{%s}")
;; 	       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
;; 	       ("\\paragraph{%s}" . "\\paragraph*{%s}")
;; 	       ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
;; (add-to-list 'org-export-latex-classes
;; 	     '("book"
;; 	       "\\documentclass[11pt]{book}"
;; 	       ("\\part{%s}" . "\\part*{%s}")
;; 	       ("\\chapter{%s}" . "\\chapter*{%s}")
;; 	       ("\\section{%s}" . "\\section*{%s}")
;; 	       ("\\subsection{%s}" . "\\subsection*{%s}")
;; 	       ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
;; 	     )
;; 不产生目录
;; (defun org-export-latex-no-toc (depth)  
;;   (when depth
;;     (format "%% Org-mode is exporting headings to %s levels.\n"
;; 	    depth)))
;; (setq org-export-latex-format-toc-function 'org-export-latex-no-toc)

(require 'org-publish)
(setq org-publish-project-alist
      '(("orgfiles"
	 :base-directory "~/org/notes/publish/"
	 :base-extension "org"
	 :publishing-directory "/ftp:zvame@216.18.217.25#21:/domains/zenoes.com/public_html/notes/"
	 ;;	 :publishing-directory "~/public_html/notes/"
	 :publishing-function org-publish-org-to-html
	 :headline-levels 6
	 :section-numbers nil
	 :table-of-contents nil
	 :style "<link rel=\"stylesheet\" href=\"style/style.css\" type=\"text/css\"/>"
	 :style-extra "
<script src=\"http://lib.sinaapp.com/js/jquery/1.7.2/jquery.min.js\"></script>
<script src=\"style/functions.js\"></script>"
	 :style-include-default nil
	 :style-include-scripts nil
	 :creator-info nil
	 :html-preamble t)
        
        
	("other"
	 :base-directory "~/org/notes/"
	 :base-extension "css\\|js"
	 :publishing-directory "/ftp:zvame@216.18.217.25#21:/domains/zenoes.com/public_html/notes/style/"
	 :publishing-function org-publish-attachment)
        
	("np" :components ("notepublish" "other"))
        
	("notes" :components ("orgfiles" "other"))))


;; Capture
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/tasks.org" "任务")
	 "* TODO %?\n")
	("e" "Exam" entry (file+headline "~/org/study.org" "考试")
	 "* TODO %?\n")
	("h" "Homework" entry (file+headline "~/org/study.org" "作业")
	 "* TODO %?\n")
	("e" "Emacs Notes" entry (file+headline "~/org/notes/emacs.org" "Notes")
	 "* %?\n %i\n %a")
	("p" "Emacs Notes" entry (file+headline "~/org/notes/php.org" "capture")
	 "* %?\n %i\n %a")
	("l" "Emacs Lisp Notes" entry (file+headline "~/org/notes/lisp.org" "Notes")
	 "* %?\n %i\n %a")
	("j" "Journal" entry (file+datetree "~/org/journal.org")
	 "* %?")))

;;;; END Orgmode

;;;;  文件加密

;;; easypg，emacs 自带
(require 'epa-file)
(epa-file-enable)
;; 总是使用对称加密
(setq epa-file-encrypt-to nil)
;; 允许缓存密码，否则编辑\保存时每次保存都要输入密码
;;(setq epa-file-cache-passphrase-for-symmetric-encryption t)
;; 允许自动保存
;;(setq epa-file-inhibit-auto-save nil)

;;;; END 文件加密

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#000" :foreground "#fff" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "unknown" :family "文泉驿等宽正黑"))))
 '(font-lock-comment-delimiter-face ((t (:inherit font-lock-comment-face))))
 '(font-lock-comment-face ((t (:background "#111" :foreground "#999" :height 1.0))))
 '(font-lock-constant-face ((t (:foreground "#20b2aa"))))
 '(font-lock-keyword-face ((t (:foreground "#f00"))))
 '(fringe ((t (:background "#000"))))
 '(header-line ((t (:background "#000" :foreground "#333"))))
 '(hl-paren-face ((t (:weight bold))) t)
 '(mode-line ((t (:background "#000" :foreground "#999" :box (:line-width 1 :color "#999") :height 0.75))))
 '(mode-line-highlight ((t (:box (:line-width 2 :color "grey40" :style released-button) :height 0.6))))
 '(mode-line-inactive ((t (:inherit mode-line :background "#000" :foreground "#333"))))
 '(org-clock-overlay ((t (:background "#000"))))
 '(org-level-1 ((t (:inherit outline-1))))
 '(org-level-4 ((t (:background "black" :foreground "hot pink"))))
 '(region ((t (:background "#333" :foreground "#fff"))))
 '(secondary-selection ((t (:background "#111")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(chm-view-delay 1)
 '(hl-paren-colors (quote ("#f00" "#ff0" "#0f0" "#00ced1" "#9400d3")))
 '(org-agenda-span (quote month))
 '(org-clock-out-remove-zero-time-clocks t)
 '(tags-table-list (quote ("~/src/emacs-24.1/lisp/TAGS"))))

;; 绑定全局键值
;; 也可以绑定单独到某个mode，比如cc-mode (define-key cc-mode-map (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "(")  'skeleton-pair-insert-maybe)
(global-set-key (kbd "{")  'skeleton-pair-insert-maybe)
(global-set-key (kbd "《")  'skeleton-pair-insert-maybe)
(global-set-key (kbd "（")  'skeleton-pair-insert-maybe)
;; (global-set-key (kbd "\'") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
;; (global-set-key (kbd "[")  'skeleton-pair-insert-maybe)

;; 填入大中小括号，双单引号的匹配
(setq skeleton-pair t)
(setq skeleton-pair-alist '((?\" _ "\"" >)(?\' _ "\'" >)(?《 _"》">)(?（ _"）">)(?\( _ ")" >)(?\[ _ "]" >)(?\{ _ "}" >)))
                            
                            
;;;; Keymap
                            
			    (global-set-key (kbd "C-/") 'undo-tree-undo)
			    (global-unset-key (kbd "C-."))
			    (global-set-key (kbd "C-;") 'undo-tree-redo)
			    (global-set-key (kbd "C-.") 'undo-tree-redo)
			    (global-set-key (kbd "C-,") 'indent-buffer)
			    (global-set-key (kbd "C-x C-b") 'ibuffer)
			    (global-set-key (kbd "C-y") 'my-yank)
			    (global-set-key (kbd "C-'") 'hs-toggle-hiding)
			    ;; 防止find-file时的误按
			    (global-unset-key "\C-xf")
			    ;; 大小写转换，这里默认转换左边的单词
			    (global-set-key (kbd "M-u") (lambda () (interactive) (upcase-word -1)))
			    (global-set-key (kbd "M-l") (lambda () (interactive) (downcase-word -1)))
			    (global-set-key (kbd "M-c") (lambda () (interactive) (capitalize-word -1)))
                            
			    ;;(global-set-key (kbd "S-SPC C-i") 'zeno-emacs)
                            
			    (global-set-key (kbd "C-c C-x C-o") 'org-agenda-clock-out)
                            
			    (define-key global-map "\C-cl" 'org-store-link)
			    (define-key global-map "\C-ca" 'org-agenda)
			    (define-key global-map "\C-cc" 'org-capture)
                            
			    ;; C-x C-j open the directory of current buffer
			    (global-set-key (kbd "C-x C-j")
					    (lambda ()
					      (interactive)
					      (if (buffer-file-name)
						  (dired default-directory))))
                            
			    ;; 这里重启两次是为了 防止toggle类的fun出现问题
			    (global-set-key [f1] '(lambda ()
						    (interactive)
						    (indent-buffer)))
			    (global-set-key [f2] 'hs-hide-all)
			    (global-set-key [f5] '(lambda ()
						    (interactive)
						    (eval-buffer)))
			    (global-set-key [f6] 'toggle-truncate-lines)
                            
			    ;; 全屏
			    (global-set-key [f11] '(lambda ()
						     (interactive)
						     (x-send-client-message
						      nil 0 nil "_NET_WM_STATE" 32
						      '(2 "_NET_WM_STATE_FULLSCREEN" 0))))
                            
			    (global-set-key [f12] 'archive-region)
                            
                            
			    (setq less-css-compile-at-save t)
			    (autoload 'espresso-mode "espresso")
                            
			    (defun my-js2-indent-function ()
			      (interactive)
			      (save-restriction
				(widen)
				(let* ((inhibit-point-motion-hooks t)
				       (parse-status (save-excursion (syntax-ppss (point-at-bol))))
				       (offset (- (current-column) (current-indentation)))
				       (indentation (espresso--proper-indentation parse-status))
				       node)
                                  
				  (save-excursion
                                    
				    ;; I like to indent case and labels to half of the tab width
				    (back-to-indentation)
				    (if (looking-at "case\\s-")
					(setq indentation (+ indentation (/ espresso-indent-level 2))))
                                    
				    ;; consecutive declarations in a var statement are nice if
				    ;; properly aligned, i.e:
				    ;;
				    ;; var foo = "bar",
				    ;;     bar = "foo";
				    (setq node (js2-node-at-point))
				    (when (and node
					       (= js2-NAME (js2-node-type node))
					       (= js2-VAR (js2-node-type (js2-node-parent node))))
				      (setq indentation (+ 4 indentation))))
                                  
				  (indent-line-to indentation)
				  (when (> offset 0) (forward-char offset)))))
                            
			    (defun my-indent-sexp ()
			      (interactive)
			      (save-restriction
				(save-excursion
				  (widen)
				  (let* ((inhibit-point-motion-hooks t)
					 (parse-status (syntax-ppss (point)))
					 (beg (nth 1 parse-status))
					 (end-marker (make-marker))
					 (end (progn (goto-char beg) (forward-list) (point)))
					 (ovl (make-overlay beg end)))
				    (set-marker end-marker end)
				    (overlay-put ovl 'face 'highlight)
				    (goto-char beg)
				    (while (< (point) (marker-position end-marker))
				      ;; don't reindent blank lines so we don't set the "buffer
				      ;; modified" property for nothing
				      (beginning-of-line)
				      (unless (looking-at "\\s-*$")
					(indent-according-to-mode))
				      (forward-line))
				    (run-with-timer 0.5 nil '(lambda(ovl)
							       (delete-overlay ovl)) ovl)))))
                            
			    (defun my-js2-mode-hook ()
			      (require 'espresso)
			      (setq espresso-indent-level 8
				    indent-tabs-mode nil
				    c-basic-offset 8)
			      (c-toggle-auto-state 0)
			      (c-toggle-hungry-state 1)
			      (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
			      (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
			      (define-key js2-mode-map [(meta control \;)] 
				'(lambda()
				   (interactive)
				   (insert "/* -----[ ")
				   (save-excursion
				     (insert " ]----- */"))
				   ))
			      (define-key js2-mode-map [(return)] 'newline-and-indent)
			      (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
			      (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
			      (define-key js2-mode-map [(control meta q)] 'my-indent-sexp)
			      (if (featurep 'js2-highlight-vars)
				  (js2-highlight-vars-mode))
			      (message "My JS2 hook"))
                            
			    (add-hook 'js2-mode-hook 'my-js2-mode-hook)
                            
                            
