(require 'Kenrituhitiyutukuwanmahe)

(defvar ksu-dir (s-concat (getenv "SRC") "/" "priv/ksu"))

(defun ksu ()
    (interactive)
    (let*
        (
            (time (ksu-current-time)))
        (delete-other-windows)
        (save-buffer)
        (ksu-rename time)
        (ksu-save-shell time)
        (ksu-exec time)
        (ksu-set-window-file time nil)))
;;  (ksu-save-shell time)))

(defun ksu-current-time ()
    (interactive)
    (let*
        (
            (time (s-replace "." "d" (hiyositiyau-now6))))
        time))

(defun ksu-rename (time)
    (interactive)
    (let*
        (
            (shell (s-concat time ".shell")))
        (rename-buffer shell)))

(defun ksu-save-shell (time)
    (interactive)
    (let*
        (
            (shell (s-concat time ".shell")))
        (--map
            (progn
                (switch-to-buffer it)
                (write-file (s-concat ksu-dir "/" it) t))
            (list shell))))

(defun ksu-exec (time)
    (interactive)
    (let*
        (
            (stdout (s-concat time ".stdout"))
            (stderr (s-concat time ".stderr")))
        (async-shell-command (region-to-string (point-min) (point-max)) stdout stderr)))

(defun ksu-set-window-file (time with-file)
    (interactive)
    (let*
        (
            (shell (s-concat time ".shell"))
            (stdout (s-concat time ".stdout"))
            (stderr (s-concat time ".stderr"))
            (stderr-height 4)
            (stdout-height (- (frame-height) stderr-height)))
        (delete-other-windows)

        (split-window-horizontally 40)

        (other-window 1)
        (if with-file
            (find-file (s-concat ksu-dir "/" stdout))
            (switch-to-buffer stdout))
        (display-ansi-colors)

        (split-window-vertically stdout-height)
        (other-window 1)
        (if with-file
            (find-file (s-concat ksu-dir "/" stderr))
            (switch-to-buffer stderr))
        
        (display-ansi-colors)

        (other-window 1)
        (switch-to-buffer shell)
        ))

(defun ksu-save (time)
    (interactive)
    (let*
        (
            (shell (s-concat time ".shell"))
            (stdout (s-concat time ".stdout"))
            (stderr (s-concat time ".stderr")))
        (--map
            (progn
                (switch-to-buffer it)
                (write-file (s-concat ksu-dir "/" it) t))
            (list stdout stderr))
        (switch-to-buffer shell)))

(defun ksu-save-current ()
    (interactive)
    (let*
        (
            (time (--> (current-buffer) (buffer-name it) (s-replace ".shell" "" it))))
        (ksu-save time)))


;;(ksu-set-window "aa")

(defun ksu-new ()
    (interactive)
    (let*
        (
            (time (s-replace "." "d" (hiyositiyau-now6)))
            (shell (s-concat time ".shell"))
            (shell-full (s-concat ksu-dir "/" shell)))
        (if
            (s-equals?
                (--> (current-buffer) (buffer-name it) (s-right 6 it))
                ".shell")
            (ksu-save-current))
        (generate-new-buffer shell)
        (switch-to-buffer shell)
        (write-file shell-full)
        (sh-mode)
        (delete-other-windows)))


(require 'ansi-color)

;; from https://stackoverflow.com/questions/23378271/how-do-i-display-ansi-color-codes-in-emacs-for-any-mode
(defun display-ansi-colors ()
    (interactive)
    (ansi-color-apply-on-region (point-min) (point-max)))

(defun kh-find-prev-file-ksu ()
    (interactive)
    (kh-find-prev-file "shell"))

(defun kh-find-next-file-ksu ()
    (interactive)
    (kh-find-next-file "shell"))

(defun ksu-prev ()
    (interactive)
    (kh-find-prev-file "shell")
    (let*
        (
            (time (--> (current-buffer) (buffer-name it) (s-replace ".shell" "" it))))
        (ksu-set-window-file time t)))

(defun ksu-next ()
    (interactive)
    (kh-find-next-file "shell")
    (let*
        (
            (time (--> (current-buffer) (buffer-name it) (s-replace ".shell" "" it))))
        (ksu-set-window-file time t)))

(provide 'Kensoukahuuntoutiyau)
