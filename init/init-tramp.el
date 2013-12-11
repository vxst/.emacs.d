;; There is no TRAMP equivalent to ssh user@host -i private-key.pem.
;; However, if you run the shell command ssh-add private-key.pem,
;; then ssh (and thus TRAMP) will automatically use private-key.pem for
;; authentication. Simply ssh user@host will work on the shell,
;; and opening the file /user@host:~/filename.txt will work in emacs,
;; without it prompting for a password.
(provide 'init-tramp)
