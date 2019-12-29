;;; Character sets

(defcustom my/force-default-font-for-symbols nil
  "When non-nil, force Emacs to use your default font for symbols."
  :type 'boolean)

(defun my/maybe-use-default-font-for-symbols ()
  "Force Emacs to render symbols using the default font, if so configured."
  (when my/force-default-font-for-symbols
    (set-fontset-font "fontset-default" 'symbol (face-attribute 'default :family))))

(add-hook 'after-init-hook 'my/maybe-use-default-font-for-symbols)

(add-to-list 'default-frame-alist '(font . "PragmataPro Mono Liga"))
(set-face-attribute 'default t :font "PragmataPro Mono Liga")
;;; Changing font sizes

(require 'cl)

(defun my/font-name-replace-size (font-name new-size)
  (let ((parts (split-string font-name "-")))
    (setcar (nthcdr 7 parts) (format "%d" new-size))
    (mapconcat 'identity parts "-")))

(defun my/set-frame-font-size (size)
    (set-frame-font (my/font-name-replace-size (face-font 'default) size) t t))

(defun my/increment-default-font-height (delta)
  "Adjust the default font height by DELTA on every frame.
Emacs will keep the pixel size of the frame approximately the
same.  DELTA should be a multiple of 10, to match the units used
by the :height face attribute."
  (let* ((new-height (+ (face-attribute 'default :height) delta))
         (new-point-height (/ new-height 10)))
    (my/set-frame-font-size new-point-height)
    (set-face-attribute 'default nil :height new-height)
    (message "Default font size is now %d" new-point-height)))

(defun my/increase-default-font-height ()
  (interactive)
  (my/increment-default-font-height 10)
  (if (fboundp 'powerline-reset)
      (powerline-reset)))

(defun my/decrease-default-font-height ()
  (interactive)
  (my/increment-default-font-height -10)
  (if (fboundp 'powerline-reset)
      (powerline-reset)))

(my/set-frame-font-size 11)
(set-face-attribute 'default nil :height 110)
(bind-key (kbd "C-=") 'my/increase-default-font-height)
(bind-key (kbd "C--") 'my/decrease-default-font-height)

(provide 'init-fonts)
