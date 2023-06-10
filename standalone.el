;; This is to support loading from a non-standard .emacs.d
;; via emacs -q --load "/path/to/standalone.el"
;; see https://emacs.stackexchange.com/a/4258/22184

(setq user-init-file (or load-file-name (buffer-file-name)))
(setq user-emacs-directory (file-name-directory user-init-file))
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("tromey" . "http://tromey.com/elpa/"))
(setq package-user-dir (expand-file-name "elpa/" user-emacs-directory))
(package-initialize)

;; Install use-package that we require for managing all other dependencies
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-expand-minimally t))


;;disable splash screen and startup message
(setq inhibit-startup-message t) 
(setq initial-scratch-message nil)

;; configure backups
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;; no backups
;; (setq make-backup-files nil)

;; To disable the menu bar, place the following line in your .emacs file:
(menu-bar-mode -1)
;; To disable the scrollbar, use the following line:
;; (scroll-bar-mode -1)
;; To disable the toolbar, use the following line:
(tool-bar-mode -1) 

;; show column number
(column-number-mode t)

;; Display Line Numbers but not relative but absolute
(global-display-line-numbers-mode)
(setq display-line-numbers t)

;; M-q line filling 
(setq-default fill-column 120)

;; treat snakecase as one word with M-f, M-b
(global-superword-mode t)

;; Bell - Get visual indication of an exception
(setq visible-bell 1)

; when you visit a file, point goes to the last place where it was when you previously visited the same file
(save-place-mode 1)

;; Toggle diacritic folding
(setq search-default-mode 'char-fold-to-regexp) ; cafe = café

;; Fido Mode
(fido-mode 1)
(fido-vertical-mode 1)

;; activate filesets -  edit a certain group of files,
(filesets-init)

;; Org Mode
;; Locations
(setq org-directory "~/Documents/org")

(setq org-agenda-files (list "~/Documents/org/job.org"
                             "~/Documents/org/f&e.org" 
                             "~/Documents/org/private.org"))

;; allow refiling headlines (with C-c C-w) to these targets
(setq org-refile-targets '((org-agenda-files :maxlevel . 1)))

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; Keep track of when a  TODO item was marked as done.
(setq org-log-done 'time)

;; Indentation under Org Headlines
(setq org-adapt-indentation t)

;; Org Mode Captures
(setq org-capture-templates
      '(("t" "Unspecified TODO" entry (file+headline "~/Documents/org/todo.org" "New")
         (file "./todo.template") :empty-lines 1)
	("f" "F&E TODO" entry (file+headline "~/Documents/org/f&e.org" "New")
         (file "./todo.template") :empty-lines 1)
	))

;; Org Mode - write Changes / Logs into Drawer LOGBOOK, Time tracking into CLOCKING
(setq org-log-into-drawer "LOGBOOK")
(setq org-clock-into-drawer "CLOCKING")


;; Org Mode - enforce task order
(setq org-enforce-todo-dependencies t)
(setq org-enforce-todo-checkbox-dependencies t)

;;Diary by Edward M. Reingold
(setq org-agenda-include-diary t)

(use-package yaml-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-hook 'yaml-mode-hook
	  (lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
  )

(use-package which-key
  :ensure t
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-city-lights t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package magit
   :ensure t)

;; Some common sense settings
(fset 'yes-or-no-p 'y-or-n-p)

(load-file (expand-file-name "init.el" user-emacs-directory))
