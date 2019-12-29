;;; init.el -- My Emacs configuration
;-*-Emacs-Lisp-*-

;;; Commentary:
;;; Short init.el to bootstrap config.org

;;; Code:
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

(defconst directories-to-load
  (list
    (expand-file-name "lisp" user-emacs-directory)
    (expand-file-name "site-lisp" user-emacs-directory)
    "~/dotfiles_private/emacs.d"))

(dolist (dir directories-to-load) (load-directory dir))

;; use different custom file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; packages
(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(setq package-enable-at-startup nil)
(package-initialize)

;; workaround bug in Emacs 26.2
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Setting up the package manager. Install if missing.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t))

(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))

(require 'init-fonts)
(require 'init-slack)
(require 'liga-mode)
(require 'init-powerline)
(require 'init-projectile)
(require 'init-treemacs)
(require 'init-spelling)

(provide 'init)
;;; init.el ends here
