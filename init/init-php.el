(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

;; pman
;; sudo pear channel-update doc.php.net
;; sudo pear install doc.php.net/pman
(add-hook 'php-mode-hook
	  (lambda ()
	    (electric-pair-mode)
	    (define-key php-mode-map "\C-hf" 'describe-function-via-pman)))
(defun describe-function-via-pman (FUNCTION)
  "Display the full documentation of FUNCTION, using pman"
  (interactive "s")
  (let* ((str (shell-command-to-string (concat "pman " FUNCTION)))
	 (str (replace-regexp-in-string "\\\\" "" str)))
    (with-output-to-temp-buffer "*Pman*"
      (princ str))
    (balance-windows-area)))

;; fix htmlize
(defface quote
  '()
  "Face")
(defface font-lock-constant-face
  '()
  "Face")
(provide 'init-php)
