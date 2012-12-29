(defun chrome ()
  "open google-chrome with shell-command"
  (interactive)
  (shell-command "google-chrome"))

(require 'application)
(setq application-caller-list
      '(
	(".*\\.pdf$" . "evince")
	))


(provide 'init-app)
