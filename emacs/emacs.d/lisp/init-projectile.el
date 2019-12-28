(use-package helm-projectile
  :commands (helm-projectile helm-projectile-switch-project helm-projectile-switch-to-buffer helm-projectile-find-file)
  :ensure t)

(use-package projectile
  :ensure t
  :defer 1
  :config
  (projectile-mode)
  (setq projectile-enable-caching t)
  (setq projectile-mode-line
        '(:eval
          (format " Proj[%s]"
                  (projectile-project-name)))))

(provide 'init-projectile)
