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


(provide 'init-functions)
