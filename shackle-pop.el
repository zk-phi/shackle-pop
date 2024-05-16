(require 'shackle)
;; shackle.el also requires cl-lib, so this makes it no slower to load
(require 'cl-lib)

(defvar shackle-pop-auto-close t
  "When non-nil, popup windows are automatically closed after
`keyboard-quit' is requested.")

(defvar shackle-pop-auto-reuse t
  "When non-nil and if a popup window is already shown, do not
create another but just reuse it.")

(defvar shackle-pop-close-timer-delay 0.05
  "Delay for the idle timer to monitor `keyboard-quit'.")

(defvar shackle-pop-auto-align t
  "When non-nil, popups will be aligned even when (:align t) is not
specified in the rule.")

(defvar shackle-pop--timer-object nil)
(defvar shackle-pop--windows nil)

(defun shackle-pop--maybe-start-timer ()
  (unless shackle-pop--timer-object
    (setq shackle-pop--timer-object
          (run-with-idle-timer
           shackle-pop-close-timer-delay
           shackle-pop-close-timer-delay
           (lambda ()
             (when (eq last-command 'keyboard-quit)
               (dolist (wnd shackle-pop--windows)
                 (and (window-live-p wnd) (delete-window wnd)))
               (setq shackle-pop--windows nil))
             (unless shackle-pop--windows
               (cancel-timer shackle-pop--timer-object)
               (setq shackle-pop--timer-object nil)))))))

(defun shackle-pop--maybe-clear-windows ()
  (when (= (length (window-list)) 1)
    (setq shackle-pop--windows nil)))
(add-hook 'window-configuration-change-hook 'shackle-pop--maybe-clear-windows)

(define-advice shackle-display-buffer (:around (fn buffer alist plist))
  (let* ((popup-p (plist-get plist :popup))
         (reused-window
          (and shackle-pop-auto-reuse
               popup-p
               shackle-pop--windows
               (cl-some (lambda (w) (and (window-live-p w) w)) shackle-pop--windows))))
    (cond (reused-window
           (set-window-buffer reused-window buffer)
           (when (plist-get plist :select)
             (select-window reused-window))
           reused-window)
          (t
           (let* ((plist (nconc plist `(:align ,shackle-pop-auto-align)))
                  (wnd (funcall fn buffer alist plist)))
             (when (and popup-p shackle-pop-auto-close)
               (push wnd shackle-pop--windows)
               (shackle-pop--maybe-start-timer))
             wnd)))))

(defun shackle-pop-popup-buffer (buffer)
  (shackle-display-buffer buffer nil '(:select t :popup t)))

(provide 'shackle-pop)
