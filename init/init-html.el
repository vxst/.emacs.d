(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

;; yas-minor-mode will ruin web-mode's highlighing
;; (add-hook 'web-mode-hook
;;           (lambda ()
;;             (yas-minor-mode nil)))

;; Block face: can be used to set blocks background (see web-mode-block-face)
(setq web-mode-enable-block-face t)
;; Part face: can be used to set parts background (see web-mode-part-face)
(setq web-mode-enable-part-face t)
;; Comment keywords (see web-mode-comment-keyword-face)
(setq web-mode-enable-comment-keywords t)
;; Highlight current HTML element (see web-mode-current-element-highlight-face)
(setq web-mode-enable-current-element-highlight t)
;; Heredoc (cf. PHP strings) fontification (when the identifier is <<<EOTHTML or <<<EOTJAVASCRIPT)
(setq web-mode-enable-heredoc-fontification t)

(provide 'init-html)
