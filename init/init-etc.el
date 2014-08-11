(global-set-key (kbd "C-c C-j") 'ace-jump-mode)

(global-set-key (kbd "S-SPC") 'set-mark-command)

(global-unset-key (kbd "C-z"))

(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))

(defun what()
  (interactive)
  (what-cursor-position t))


;; 在行首 C-k 时，同时删除该行。
(setq-default kill-whole-line t)

;; 自动更新time-stamp
(setq time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S %U")
(add-hook 'before-save-hook 'time-stamp)
;; 不要使用tab进行缩进

;;设定删除保存记录为200，可以方便以后无限恢复
(setq kill-ring-max 200)

;;允许emacs和外部其他程式的粘贴
(setq x-select-enable-clipboard t)

;; 不要tab
(setq indent-tabs-mode nil)
(setq tab-width 4)

;;;; UNDO TREE
(require 'undo-tree)
(global-undo-tree-mode)
;;;; END Undo Tree

(global-set-key (kbd "C-c m") 'set-mark-command)

(global-set-key (kbd "C-c u") 'undo-tree-undo)
(global-set-key (kbd "C-c r") 'undo-tree-redo)
(global-set-key (kbd "C-/") 'undo-tree-undo)
(global-set-key (kbd "C-.") 'undo-tree-redo)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-y") 'my-yank)
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

;; (global-set-key (kbd "C-i") 'indent-buffer)
(global-set-key (kbd "C-7") 'indent-buffer)
(global-set-key (kbd "s-x") 'execute-extended-command)
(global-set-key (kbd "C-x C-x") 'execute-extended-command)
(global-set-key (kbd "s-r") 'replace-regexp)
(global-set-key [f2] 'hs-hide-all)
(global-set-key [f6] 'toggle-truncate-lines)

;;; 全屏
;; F11全屏，原先向X发送message的方法现在似乎失效了，直接在gnome的keyboard shortcuts绑定f11到全屏就好

;;;; English Writing
(require 'english-writing-mode)

(defun my-count ()
  (interactive)
  (let ((start)
        (end))
    (if (region-active-p)
        (setq start (region-beginning)
              end (region-end))
      (setq start (point-min)
            end (point-max)))
    (let* ((cn-chars (count-cn-chars (buffer-substring start end)))
           (cn-chars-etc (count-cn-chars-etc (buffer-substring start end)))
           (chars (- end start))
           (words (count-words start end))
           (lines (count-lines start end))
           (result
            (format "汉字: %d 字符: %d 单词: %d 行数: %d"
                    (- cn-chars cn-chars-etc)
                    chars
                    words
                    lines
                    chars))
           (result
            (dolist (var '("汉字" "字符" "单词" "行数") result)
              (setq result
                    (replace-regexp-in-string
                     var
                     (propertize var 'face 'font-lock-variable-name-face)
                     result)))))
      (message result)
      )))

(defun count-cn-chars (string)
  (count-regex-occurences "\\cc" string))

(defun count-cn-chars-etc (string)
  (count-regex-occurences "[，。（）、……￥]" string))

(defun count-regex-occurences (regex string)
  (let ((count 0))
    (with-temp-buffer
      (insert string)
      (goto-char (point-min))
      (while (re-search-forward regex nil t)
        (setq count (+ count 1))))
    count))

(global-set-key (kbd "M-=") 'my-count)

(add-hook 'post-self-insert-hook
          (lambda ()
            (when (equal major-mode 'markdown-mode)
              (my-count))))

;;; Compile 

;;下面代码保证emacs在新打开compile窗口的时候只会水平分割窗口
(setq split-height-threshold 0)
(setq split-width-threshold nil)
(add-hook 'compilation-start-hook
          (lambda ()
            (split-window)))

;; 编译无错不弹窗
(setq compilation-finish-function
      (lambda (buf str)
        (unless (string-match "grep" str)
          (if (string-match "exited abnormally" str)
              (message "compilation errors, press C-x ` to visit")
            (run-at-time 0.1 nil 'delete-windows-on buf)
            (message "NO COMPILATION ERRORS! Thank you dear compiler...")))))


(defun sudo (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))


(defun toggle-letter-case ()
  "Toggle the letter case of current word or text selection.
Toggles between: “all lower”, “Init Caps”, “ALL CAPS”."
  (interactive)
  (let (p1 p2 (deactivate-mark nil) (case-fold-search nil))
    (if (region-active-p)
        (setq p1 (region-beginning) p2 (region-end))
      (let ((bds (bounds-of-thing-at-point 'word) ) )
        (setq p1 (car bds) p2 (cdr bds)) ) )

    (when (not (eq last-command this-command))
      (save-excursion
        (goto-char p1)
        (cond
         ((looking-at "[[:lower:]][[:lower:]]") (put this-command 'state "all lower"))
         ((looking-at "[[:upper:]][[:upper:]]") (put this-command 'state "all caps") )
         ((looking-at "[[:upper:]][[:lower:]]") (put this-command 'state "init caps") )
         ((looking-at "[[:lower:]]") (put this-command 'state "all lower"))
         ((looking-at "[[:upper:]]") (put this-command 'state "all caps") )
         (t (put this-command 'state "all lower") ) ) ) )

    (cond
     ((string= "all lower" (get this-command 'state))
      (upcase-initials-region p1 p2) (put this-command 'state "init caps"))
     ((string= "init caps" (get this-command 'state))
      (upcase-region p1 p2) (put this-command 'state "all caps"))
     ((string= "all caps" (get this-command 'state))
      (downcase-region p1 p2) (put this-command 'state "all lower")) )
    ))


(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-z") 'toggle-letter-case)


(provide 'init-etc)
