;;; init.el -- My Emacs configuration
;-*-Emacs-Lisp-*-

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(require 'package)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

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

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;;; esc quits
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))

(global-display-line-numbers-mode)

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))
(global-set-key "\C-c\C-e" 'evil-mode)
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(evil-define-key 'normal 'global (kbd "C-/") 'comment-line)

(use-package evil-escape
  :ensure t
  :requires evil
  :config
  (evil-escape-mode t)
  (setq-default evil-escape-key-sequence "ii"
    evil-escape-delay 0.2))

(use-package evil-collection
  :after (evil helm)
  :ensure t
  :config
  (setq evil-collection-setup-minibuffer t)
  (evil-collection-init))

(use-package magit :ensure t)

(use-package evil-magit :ensure t
  :config (require 'evil-magit))

(use-package helm :ensure t)
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(evil-define-key 'normal 'global
  ",b" 'helm-projectile-switch-to-buffer)
(evil-define-key 'normal 'global
  ";" 'helm-M-x)
(evil-define-key 'normal 'global (kbd "C-f") 'helm-projectile-find-file)

(use-package base16-theme
  :ensure t
  :config
  (load-theme 'base16-oceanicnext t))

(use-package all-the-icons :ensure t)

;; Set the cursor color based on the evil state
(defvar my/base16-colors base16-oceanicnext-colors)
(setq evil-emacs-state-cursor   `(,(plist-get my/base16-colors :base0D) box)
      evil-insert-state-cursor  `(,(plist-get my/base16-colors :base0D) bar)
      evil-motion-state-cursor  `(,(plist-get my/base16-colors :base0E) box)
      evil-normal-state-cursor  `(,(plist-get my/base16-colors :base0B) box)
      evil-replace-state-cursor `(,(plist-get my/base16-colors :base08) bar)
      evil-visual-state-cursor  `(,(plist-get my/base16-colors :base09) box))

(use-package vterm :ensure t)
(global-set-key "\M-t" 'projectile-run-vterm)

(use-package emojify :ensure t)
(add-hook 'after-init-hook #'global-emojify-mode)

(use-package company :ensure t)
(add-hook 'after-init-hook 'global-company-mode)

(require 'init-fonts)
(require 'init-slack)
(require 'liga-mode)
(require 'init-powerline)
(require 'init-projectile)
(require 'init-treemacs)
