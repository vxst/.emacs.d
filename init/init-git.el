;; M-x magit-status to see git status, and in the status buffer:
;; s to stage files
;; c c to commit (type in your commit message then C-c C-c to save the message and commit)
;; b b to switch to a branch
;; Other handy keys:

;; P P to do a git push
;; F F to do a git pull
;; try to press TAB

(defalias 'st 'magit-status)
(provide 'init-git)
