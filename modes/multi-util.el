
(defun multi-mode-position-chunk (pos re-start re-end &optional inclusive)
  (save-excursion
    (goto-char (point-min))
    (let ((outer-start nil)
          (inner-start nil)
          (outer-end nil)
          (outer-start nil))
      (block "while-loop"
        (while (and (re-search-forward re-end nil t)
                    (not outer-end))
          (when (> (point) pos)
            (setq outer-end (point))
            (return-from "while-loop" nil))))
      (if outer-end
          (progn
            (setq inner-end (- outer-end (length (match-string 0))))
            (goto-char outer-end)
            (when (and (re-search-backward re-start nil t))
              (setq outer-start (point))
              (setq inner-start (+ outer-start (length (match-string 0))))))
        (when (re-search-forward re-start nil t)
          (setq inner-start (point)
                outer-start (- inner-start (length (match-string 0))))))
      (cond ((or (and (not inclusive)
                      inner-start inner-end
                      (>= pos inner-start)
                      (< pos inner-end))
                 (and inclusive
                      outer-start outer-end
                      (>= pos outer-start)
                      (< pos outer-end)))
             `((:outer-start . ,outer-start)
               (:inner-start . ,inner-start)
               (:inner-end . ,inner-end)
               (:outer-end . ,outer-end)))
            ((and (not outer-start) outer-end)
             `((:outer-start . ,(point-min))
               (:inner-start . ,(point-min))
               (:inner-end . ,inner-end)
               (:outer-end . ,outer-end)))
            ((and outer-start (not outer-end))
             `((:outer-start . ,outer-start)
               (:inner-start . ,inner-start)
               (:inner-end . ,(point-max))
               (:outer-end . ,(point-max))))
            (t nil))
      )))

(defun multi-mode-mode-chunk (pos re-start re-end inside-mode outside-mode)
  (let* ((chunk-inside (condition-case e (multi-mode-position-chunk pos re-start re-end) (error (print e))))
         (inside-start (cdr (assoc :inner-start chunk-inside)))
         (inside-end (cdr (assoc :inner-end chunk-inside))))
    (if (and chunk-inside
             inside-start
             inside-end
             (/= inside-start inside-end)
             (>= pos inside-start)
             (< pos inside-end))
        (list inside-mode inside-start inside-end)
      (let* ((chunk-outside (condition-case nil (multi-mode-position-chunk pos re-end re-start t) (error nil)))
             (outside-start (cdr (assoc :outer-start chunk-outside)))
             (outside-end (cdr (assoc :outer-end chunk-outside))))
        (list outside-mode outside-start outside-end)))))

;; (defun multi-mode-position-inside-chunk-p (pos re-start re-end)
;;   (let ((chunk (condition-case nil (multi-mode-position-chunk pos re-start re-end) (error nil))))
;;     (and chunk
;;          (> pos (cdr (assoc :inner-start chunk)))
;;          (< pos (cdr (assoc :inner-end chunk))))))

;; (defun multi-mode-position-outside-chunk-p (pos re-start re-end)
;;   (let ((chunk (condition-case nil (multi-mode-position-chunk pos re-end re-start) (error nil))))
;;     (and chunk
;;          (>= pos (cdr (assoc :outer-start chunk)))
;;          (< pos (cdr (assoc :outer-end chunk))))))

;; (defun test-pos-inside-chunk-p ()
;;   (interactive)
;;   (print (multi-mode-position-inside-chunk-p (point) "<script[^>]*>" "<\/script>")))

;; (defun test-pos-outside-chunk-p ()
;;   (interactive)
;;   (print (multi-mode-position-outside-chunk-p (point) "<script[^>]*>" "<\/script>")))


(provide 'multi-util)