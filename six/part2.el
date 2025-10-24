(defvar grid-size 1000)
(defvar grid
  (vconcat
   (cl-loop repeat grid-size
            collect (make-vector grid-size 0))))
(defun grid-set (i j light)
  (aset (aref grid i) j (max 0 (+ (grid-get i j) light))))
(defun grid-get (i j)
  (aref (aref grid i) j))
(defun toggle (i j) (grid-set i j 2))
(defun turn-on (i j) (grid-set i j 1))
(defun turn-off (i j) (grid-set i j -1))
(defun light-range (i1 j1 i2 j2 f)
  (cl-loop for i from i1 to i2 do
           (cl-loop for j from j1 to j2 do
                    (funcall f i j)
                    )))
(defun total-brightness ()
  (seq-reduce
   (lambda (acc col)
     (+ acc (seq-reduce #'+ col 0)))
   grid
   0))

;; (turn-on 2 2)
;; (dotimes (i 4)
;;   (dotimes (j 4)
;;     (toggle i j)))
;; ;; (message "(%d,%d)" i j)))
;; (message "%s" grid)

(defun run-each-line (file-name callback)
  (with-temp-buffer
    (progn
      (insert-file-contents file-name)
      (goto-char (point-min))
      (while (not (eobp))
        (let* ((lb (line-beginning-position))
               (le (line-end-position))
               (ln (buffer-substring-no-properties lb le))
               (cmd (string-trim ln)))
          (funcall callback cmd)
          (forward-line 1)
          ))
      )))
(defun process-command (cmd)
  (string-match
   (rx (group (one-or-more digit))
       ","
       (group (one-or-more digit))
       " through "
       (group (one-or-more digit))
       ","
       (group (one-or-more digit))
       )
   cmd)
  (let ((i1 (string-to-number (match-string 1 cmd)))
        (j1 (string-to-number (match-string 2 cmd)))
        (i2 (string-to-number (match-string 3 cmd)))
        (j2 (string-to-number (match-string 4 cmd))))
    ;; (message "from (%d,%d) to (%d,%d)" i1 j1 i2 j2)
    (cond
     ((string-prefix-p "turn on"  cmd) (light-range i1 j1 i2 j2 'turn-on))
     ((string-prefix-p "turn off" cmd) (light-range i1 j1 i2 j2 'turn-off))
     ((string-prefix-p "toggle"   cmd) (light-range i1 j1 i2 j2 'toggle))
     (t (message "no match"))
     )
    )
  )

;; (dolist (cmd '(
;;                ;; "toggle 393,804 through 510,976"
;;                ;; "turn off 6,964 through 411,976"
;;                ;; "turn off 33,572 through 978,590"
;;                ;; "turn on 579,693 through 650,978"
;;                "turn off 0,0 through 999,999"
;;                ))
;;   (process-command cmd))

(defvar input-file "./input")
(run-each-line input-file 'process-command)
(message "total brightness: %d" (total-brightness))
