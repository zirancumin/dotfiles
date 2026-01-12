(global-display-line-numbers-mode 1)

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

;; Geiser + Guile
(use-package geiser)
(use-package geiser-guile
  :after geiser)

(setq geiser-active-implementations '(guile))
(setq geiser-default-implementation 'guile)

(add-hook 'scheme-mode-hook #'geiser-mode)

