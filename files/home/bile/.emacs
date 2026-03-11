;; -*- lexical-binding: t -*-
(setq load-prefer-newer t)
(message "Loading .emacs...")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package Management & Bootstrap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(setq package-archives '(("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(setq package-archive-priorities '(("melpa-stable" . 10)
                                   ("melpa" . 5)
                                   ("gnu" . 0)))
(package-initialize)

;; Suppress byte-compile warnings for cleaner startup
(setq byte-compile-warnings '(not obsolete))

;; Install use-package if not present
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Server & Files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Start Emacs server
(require 'server)
(message "Starting Emacs server...")
(condition-case err
    (progn
      (server-start)
      (message "Emacs server started"))
  (error (message "Failed to start server: %s" err)))

;; Backup settings
(setq backup-directory-alist `((".*" . ,(expand-file-name "backups" user-emacs-directory)))
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t
      auto-save-default t
      auto-save-timeout 20
      auto-save-interval 200)

;; Add custom lisp path
(setq load-path (cons (expand-file-name "~/.emacs.d/lisp") load-path))

;; File associations
(add-to-list 'auto-mode-alist '("\\.icpp\\'" . c++-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User Information
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq user-mail-address "trapexit@spawn.link")
(setq user-full-name "Antonio SJ Musumeci")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'after-make-frame-functions
          (lambda (frame)
            (when (display-graphic-p frame)
              (set-foreground-color "white")
              (set-background-color "black"))))

(global-display-line-numbers-mode 1)
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;; Mouse support
(require 'mouse-drag nil 'noerror)
(when (fboundp 'mouse-drag-drag)
  (global-set-key [down-mouse-2] 'mouse-drag-drag))

(when (not (display-graphic-p))
  (xterm-mouse-mode t)
  (mouse-wheel-mode t))
(mouse-wheel-mode t)
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Editing Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq scroll-step 1)
(setq-default indent-tabs-mode nil)
(setq require-final-newline t)

;; Window movement
(windmove-default-keybindings)

;; Compilation
(setq compilation-scroll-output 'follow-output)

;; Electric pair
(electric-pair-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom UI Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-font-lock-extra-types '("FILE" "\\sw+_t"))
 '(case-fold-search t)
 '(column-number-mode t)
 '(current-language-environment "English")
 '(font-use-system-font t)
 '(frame-background-mode 'dark)
 '(global-cwarn-mode t)
 '(global-display-line-numbers-mode t)
 '(global-font-lock-mode t nil (font-lock))
 '(inhibit-startup-screen t)
 '(ispell-dictionary nil)
 '(package-selected-packages
   '(company dumb-jump flycheck iedit magit projectile smart-tab
     volatile-highlights which-key yasnippet helm))
 '(save-place-mode 1 nil (saveplace))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(warning-suppress-log-types '((comp)))
 '(warning-suppress-types '((comp)))
 '(whitespace-action '(auto-cleanup)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 158 :width normal :foundry "PfEd" :family "DejaVu Sans Mono"))))
 '(font-lock-builtin-face ((((class color) (background dark)) (:foreground "magenta"))))
 '(font-lock-comment-face ((((class color) (background dark)) (:foreground "cyan" :weight bold))))
 '(font-lock-constant-face ((((class color) (background dark)) (:foreground "yellow" :weight bold))))
 '(font-lock-doc-face ((t (:foreground "#00ff00" :weight bold))))
 '(font-lock-function-name-face ((((class color) (background dark)) (:foreground "lightblue" :weight bold))))
 '(font-lock-keyword-face ((((class color) (background dark)) (:foreground "red" :weight bold))))
 '(font-lock-string-face ((((class color) (background dark)) (:foreground "#00ff00" :weight bold))))
 '(font-lock-type-face ((((class color) (background dark)) (:foreground "red" :weight bold))))
 '(font-lock-variable-name-face ((((class color) (background dark)) (:foreground "white" :weight bold))))
 '(show-paren-match ((((class color)) (:background "red")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Completion & Navigation (using only Helm)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package helm
  :ensure t
  :config
  (helm-mode))

(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.0))

(use-package dumb-jump
  :ensure t
  :defer t
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(use-package projectile
  :ensure t
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Development Tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

(use-package yasnippet
  :ensure t
  :defer t
  :config
  (yas-global-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package smart-tab
  :ensure t
  :config
  (global-smart-tab-mode 1))

(use-package volatile-highlights
  :ensure t
  :config
  (volatile-highlights-mode t))

(use-package iedit
  :ensure t)

(use-package doom-modeline
  :ensure t
  :config
  (doom-modeline-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C/C++ Mode Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-c-mode-common-setup ()
  "Common setup for C/C++ modes."
  (add-hook 'before-save-hook #'delete-trailing-whitespace nil t)
  (turn-on-auto-fill)
  (flyspell-prog-mode)
  (local-set-key (kbd "C-c C-o") 'ff-find-other-file)
  (local-set-key (kbd "C-c C-r") 'ff-find-related-file))

(add-hook 'c-mode-common-hook #'my-c-mode-common-setup)
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Spell Checking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun flyspell-on-for-buffer-type ()
  "Enable Flyspell appropriately for the major mode of the current buffer. Uses `flyspell-prog-mode' for modes derived from `prog-mode', so only strings and comments get checked. All other buffers get `flyspell-mode' to check all text. If flyspell is already enabled, does nothing."
  (interactive)
  (if (not (symbol-value 'flyspell-mode))
      (progn
        (if (derived-mode-p 'prog-mode)
            (progn
              (message "Flyspell on (code)")
              (flyspell-prog-mode))
          (progn
            (message "Flyspell on (text)")
            (flyspell-mode 1))))))

(defun flyspell-toggle ()
  "Turn Flyspell on if it is off, or off if it is on. When turning on, it uses `flyspell-on-for-buffer-type' so code-vs-text is handled appropriately."
  (interactive)
  (if (symbol-value 'flyspell-mode)
      (progn
        (message "Flyspell off")
        (flyspell-mode -1))
    (flyspell-on-for-buffer-type)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Error Navigation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-next-error ()
  "Move point to next error and highlight it"
  (interactive)
  (progn
    (next-error)
    (end-of-line)
    (beginning-of-line)))

(defun my-previous-error ()
  "Move point to previous error and highlight it"
  (interactive)
  (progn
    (previous-error)
    (end-of-line)
    (beginning-of-line)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utility Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun eshell/clear ()
  "clear the eshell buffer"
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

(defun code-compile()
  (interactive)
  (let ((current-makefile (expand-file-name "Makefile" default-directory))
        (parent-makefile (expand-file-name "Makefile" (expand-file-name ".." default-directory))))
    (if (file-exists-p parent-makefile)
        (progn
          (set (make-local-variable 'compile-command)
               (concat "cd " (file-name-directory parent-makefile) " && make -f " parent-makefile))
          (compile compile-command))
      (unless (file-exists-p current-makefile)
        (set (make-local-variable 'compile-command)
             (let ((file (file-name-nondirectory buffer-file-name)))
               (format "%s -o %s %s"
                       (if (equal (file-name-extension file) "cpp") "g++" "gcc")
                       (file-name-sans-extension file)
                       file)))
        (compile compile-command)))))

;; This is intentional behavior. The user wants a commit per save and
;; then rebases at the end of a project.
(defun git-commit-on-save ()
  "Auto-commit on save for tracked file types in git repositories."
  (when (and buffer-file-name
             (locate-dominating-file default-directory ".git")
             (or (eq major-mode 'c-mode)
                 (eq major-mode 'c++-mode)
                 (eq major-mode 'markdown-mode)))
    (let ((default-directory (locate-dominating-file default-directory ".git")))
      (shell-command
       (format "git add %s && git commit -m %s"
               (shell-quote-argument (file-relative-name buffer-file-name default-directory))
               (shell-quote-argument (concat "Auto-commit " (file-name-nondirectory buffer-file-name))))))))
(add-to-list 'display-buffer-alist '("*Async Shell Commands*" display-buffer-no-window (nil)))
(add-hook 'after-save-hook #'git-commit-on-save)

;; Git commit message template
(setq git-commit-summary-max-length 50)

;; Auto-pull/rebase shortcut
(defun git-pull-rebase ()
  (interactive)
  (let ((default-directory (locate-dominating-file default-directory ".git")))
    (magit-pull-from-upstream nil nil "-r")))
(global-set-key (kbd "C-c r") #'git-pull-rebase)

;; Key Bindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "C-c j") 'just-one-space)
(global-set-key (kbd "C-c C-j") 'just-one-space)
(global-set-key (kbd "C-c C-;") 'iedit-mode)
(global-set-key (kbd "C-c ;") 'iedit-mode-toggle-on-function)

(global-set-key (kbd "C-c f") 'find-file-at-point)
(global-set-key (kbd "C-x C-k") 'kill-current-buffer)
(global-set-key (kbd "C-c a") 'align)
(global-set-key (kbd "C-c d") 'delete-trailing-whitespace)
(global-set-key (kbd "C-c g") 'goto-line)
(global-set-key (kbd "C-c s") 'sort-lines)
(global-set-key (kbd "C-c c") 'compile)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key (kbd "C-c t") 'flyspell-toggle)

(global-set-key [f9] 'code-compile)

;; Move to beginning/end of buffer with shift key combo
(global-set-key (kbd "C-c <up>") 'beginning-of-buffer)
(global-set-key (kbd "C-c <down>") 'end-of-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Garbage Collection & Performance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      company-minimum-prefix-length 1)
