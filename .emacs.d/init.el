(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(ido-mode 1)
(ido-everywhere 1)
(global-display-line-numbers-mode 1)

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default make-backup-files nil)
(setq-default isearch-lazy-count t)

;; Package manage setting
(require 'package)
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)   ; auto install packages not installed

;; which-key
(use-package which-key
  :ensure t
  :config
  (which-key-mode 1))

;; markdown-mode
(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'"       . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

;; undo/redo
(use-package undo-fu
  :ensure t
  :bind (("C-/"   . undo-fu-only-undo)
         ("C-?"   . undo-fu-only-redo)))
(use-package undo-fu-session
  :ensure t
  :config
  ;; Persistence
  (setq undo-fu-session-directory "~/.emacs.d/undo-session/")
  (global-undo-fu-session-mode))

;; undo tree
(use-package vundo
  :ensure t
  :bind ("C-x u" . vundo))

;; Geiser + Guile
(use-package geiser)
(use-package geiser-guile
  :after geiser)

(setq geiser-active-implementations '(guile))
(setq geiser-default-implementation 'guile)

(add-hook 'scheme-mode-hook #'geiser-mode)

