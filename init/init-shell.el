(defun my-async-shell-command (cmd)
  (let* ((buffer-name (format-time-string "*buffer-to-hide-%s*")))
    (async-shell-command cmd buffer-name nil)
    (delete-windows-on buffer-name nil)
    (add-to-list 'ido-ignore-buffers buffer-name)))

(defun sh()
  (interactive)
  (message "%s" default-directory)
  (my-async-shell-command (concat "nohup gnome-terminal --working-directory="
                                  (replace-regexp-in-string "~"
                                                            "/home/zenozeng"
                                                            default-directory)
                                  " > /dev/null")))

(provide 'init-shell)
