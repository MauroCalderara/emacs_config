(require 'package)
(add-to-list 'package-archives 
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)

;;;;;;;;;;;;;;;;;;;
;; general settings

;; no file sprawl
(setq make-backup-files nil)
(setq auto-save-default nil)

;; use english dates
(setq system-time-locale "en_US.UTF-8")

;; transient mark mode
(transient-mark-mode 1)

;; load split configuration
(load "~/.emacs.d/conf.d/key-chord.el")
(load "~/.emacs.d/conf.d/evil-conf.el")
(load "~/.emacs.d/conf.d/org-mode-conf.el")
(load "~/.emacs.d/conf.d/org-mode-extra-conf.el")

