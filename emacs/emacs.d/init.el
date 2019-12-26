;;; init.el -- My Emacs configuration
;-*-Emacs-Lisp-*-

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; Leave this here, or package.el will just add it again.
(package-initialize)

(require 'package)
(setq package-enable-at-startup nil)

(defconst directories-to-load (list (expand-file-name "lisp" user-emacs-directory) "~/dotfiles_private/emacs.d"))

;; Add all directories within "lisp"
(defun load-directory (directory)
  (add-to-list 'load-path directory)
  (let ((files (directory-files-and-attributes directory t)))
    (dolist (file files)
      (let ((filename (car file))
	    (dir (nth 1 file)))
	(when (and dir
		   (not (string-suffix-p "." filename)))
	  (add-to-list 'load-path (car file)))))))

(dolist (dir directories-to-load) (load-directory dir))

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package evil :ensure t
  :config  (require 'evil (evil-mode t)))

(global-set-key "\C-c\C-e" 'evil-mode)

(use-package magit :ensure t)

(use-package evil-magit :ensure t
  :config (require 'evil-magit))

(use-package helm :ensure t)

(use-package base16-theme
  :ensure t
  :config
  (load-theme 'base16-oceanicnext t))

;; Set the cursor color based on the evil state
(defvar my/base16-colors base16-oceanicnext-colors)
(setq evil-emacs-state-cursor   `(,(plist-get my/base16-colors :base0D) box)
      evil-insert-state-cursor  `(,(plist-get my/base16-colors :base0D) bar)
      evil-motion-state-cursor  `(,(plist-get my/base16-colors :base0E) box)
      evil-normal-state-cursor  `(,(plist-get my/base16-colors :base0B) box)
      evil-replace-state-cursor `(,(plist-get my/base16-colors :base08) bar)
      evil-visual-state-cursor  `(,(plist-get my/base16-colors :base09) box))

(use-package vterm :ensure t)
(global-set-key "\M-t" 'vterm)

(require 'init-fonts)
(require 'init-slack)
(require 'liga-mode)
