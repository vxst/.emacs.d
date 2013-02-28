;; 函数库

(defun file-string )

;; MY YANK
;; 例子：
;; C-u 100 C-y
;; 复制一百次
(defun my-yank (arg)
  "Yank ARG times."
  (interactive "p")
  (dotimes (var arg)
    (yank)))

;; 一键缩进
(defun indent-buffer ()
  "Indent the current buffer"
  (interactive)
  
  (condition-case nil
      ;; 尝试直接缩进区域
      (indent-region (point-min) (point-max))
    ;; 尝试逐行缩进
    (ignore-errors
      (save-excursion
        (goto-char (point-min))
        (while (search-forward "\n" nil t)                
          (ignore-errors
            (indent-for-tab-command)))))))

(global-set-key [remap delete-horizontal-space] 'zeno-delete-horizontal-space)

(defun zeno-delete-horizontal-space ()
  (interactive)
  (let ((start)
        (end))
    (if (region-active-p)
	(progn
	  (setq start (region-beginning)
		end (region-end))
	  (save-excursion
	    (save-restriction
	      (narrow-to-region start end)
	      (goto-char (point-min))
	      (delete-horizontal-space)
	      (while (search-forward "\n" nil t)
		(ignore-errors
		  (move-beginning-of-line nil)
		  (delete-horizontal-space)))
	      ))
	  )
      (delete-horizontal-space))))

(provide 'init-functions)
