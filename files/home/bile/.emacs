;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;;(use-package vterm
;;    :ensure t)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(add-to-list 'auto-mode-alist '("\\.icpp\\'" . c++-mode))

(use-package projectile
  :ensure t
  :pin melpa-stable
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))

;; (use-package lsp-mode
;;   :ensure t
;;   :commands (lsp lsp-deferred)
;;   :init
;;   (setq lsp-keymap-prefix "C-o")
;;   :config
;;   (lsp-enable-which-key-integration t)
;;   (setq lsp-clients-clangd-args
;;         '("-j=4"
;;           "--malloc-trim"
;;           "--background-index"
;;           "--log=error"
;;           "--header-insertion=never"))
;;   (setq lsp-enable-on-type-formatting nil)
;;   (setq lsp-enable-indentation nil))

;; (use-package lsp-ui
;;   :commands lsp-ui-mode
;;   :ensure t)

(use-package ccls
  :ensure t
  :config
  (setq ccls-executable "ccls")
  (setq lsp-prefer-flymake nil)
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode)
  :config
  (setq flycheck-gcc-include-paths '("/usr/include"))
  (setq flycheck-clang-include-paths '("/usr/include")))

(use-package yasnippet
  :ensure t
  :config (yas-global-mode))

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package helm-lsp
  :ensure t)

(use-package helm
  :ensure t
  :config (helm-mode))

(use-package lsp-treemacs
  :ensure t)

;(use-package company
;  :config
;  (global-company-mode 1))
;  (global-set-key (kbd "<tab>") 'company-complete))

(with-eval-after-load 'company
  (define-key company-active-map (kbd "TAB") 'company-complete)
  (define-key company-active-map (kbd "<tab>") 'company-complete))

(setq package-selected-packages '(lsp-mode lsp-treemacs helm-lsp
    projectile hydra flycheck company avy which-key helm-xref dap-mode))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
;; (helm-mode)
;; (require 'helm-xref)
;; (define-key global-map [remap find-file] #'helm-find-files)
;; (define-key global-map [remap execute-extended-command] #'helm-M-x)
;; (define-key global-map [remap switch-to-buffer] #'helm-mini)

(which-key-mode)
;;(add-hook 'c-mode-hook 'lsp)
;;(add-hook 'c++-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (require 'dap-cpptools)
  (yas-global-mode))



(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

(setq load-path (cons (expand-file-name "/home/bile/.emacs.d/lisp") load-path))

;;(add-to-list 'load-path "/home/bile/.emacs.d/dockerfile-mode/")
;;(require 'dockerfile-mode)
;;(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

(setq user-mail-address "trapexit@spawn.link")
(setq user-full-name "Antonio SJ Musumeci")
(set-foreground-color "white")
(set-background-color "black")
;;(set-scroll-bar-mode nil)

;;(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
;;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(require 'mouse-drag)
(global-set-key [down-mouse-2] 'mouse-drag-drag)

;;(require 'tooltip)
;;(tooltip-mode 0)
;;(tool-bar-mode nil)

(global-display-line-numbers-mode 1)
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

(icomplete-mode t)

(setq scroll-set 1)
(setq-default indent-tabs-mode nil)

(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

(setq require-final-newline 'query)

(xterm-mouse-mode t)
(mouse-wheel-mode t)
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1) ((control) . nil)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-font-lock-extra-types '("FILE" "\\sw+_t"))
 '(case-fold-search t)
 '(column-number-mode t)
 '(current-language-environment "English")
 '(ecb-options-version "2.32")
 '(font-use-system-font t)
 '(frame-background-mode 'dark)
 '(global-cwarn-mode t)
 '(global-display-line-numbers-mode t)
 '(global-font-lock-mode t nil (font-lock))
 '(highlight-indent-guides-method 'character)
 '(inhibit-startup-screen t)
 '(ispell-dictionary nil)
 '(lsp-enable-indentation nil)
 '(package-selected-packages
   '(## ccls company-c-headers dap-mode dockerfile-mode dumb-jump eat
        flycheck helm-lsp helm-xref iedit lsp-ui magit
        projectile-git-autofetch smart-tab which-key yasnippet))
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
 '(font-lock-doc-face ((t (:foreground "green" :weight bold))))
 '(font-lock-function-name-face ((((class color) (background dark)) (:foreground "lightblue" :weight bold))))
 '(font-lock-keyword-face ((((class color) (background dark)) (:foreground "red" :weight bold))))
 '(font-lock-string-face ((((class color) (background dark)) (:foreground "green" :weight bold))))
 '(font-lock-type-face ((((class color) (background dark)) (:foreground "red" :weight bold))))
 '(font-lock-variable-name-face ((((class color) (background dark)) (:foreground "white" :weight bold))))
 '(show-paren-match ((((class color)) (:background "red")))))



;(global-set-key "\C-j" 'next-multiframe-window)
;(global-set-key "\C-x\C-m" 'execute-extended-command)
;(global-set-key "\M-m" 'mark-defun)
;(global-set-key (kbd "C-c C-f") 'flyspell-toggle)

(windmove-default-keybindings '(shift))
(require 'iedit)
(global-set-key (kbd "C-c C-;") 'iedit-mode)
(global-set-key (kbd "C-c ;") 'iedit-mode-toggle-on-function)

(global-set-key (kbd "C-c f") 'find-file-at-point)

(global-set-key (kbd "C-x C-k") 'kill-current-buffer)

(global-set-key (kbd "C-<") 'beginning-of-buffer)
(global-set-key (kbd "C->") 'end-of-buffer)
(global-set-key (kbd "C-c a") 'align)
(global-set-key (kbd "C-c d") 'delete-trailing-whitespace)
(global-set-key (kbd "C-c g") 'goto-line)
(global-set-key (kbd "C-c s") 'sort-lines)
(global-set-key (kbd "C-c c") 'compile)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(setq compilation-scroll-output 'follow-output)

(defun flyspell-on-for-buffer-type ()
  "Enable Flyspell appropriately for the major mode of the current buffer.  Uses `flyspell-prog-mode' for modes derived from `prog-mode', so only strings and comments get checked.  All other buffers get `flyspell-mode' to check all text.  If flyspell is already enabled, does nothing."
  (interactive)
  (if (not (symbol-value flyspell-mode)) ; if not already on
      (progn
	(if (derived-mode-p 'prog-mode)
	    (progn
	      (message "Flyspell on (code)")
	      (flyspell-prog-mode))
	  ;; else
	  (progn
	    (message "Flyspell on (text)")
	    (flyspell-mode 1)))
	;; I tried putting (flyspell-buffer) here but it didn't seem to work
	)))

(defun flyspell-toggle ()
  "Turn Flyspell on if it is off, or off if it is on.  When turning on, it uses `flyspell-on-for-buffer-type' so code-vs-text is handled appropriately."
  (interactive)
  (if (symbol-value flyspell-mode)
      (progn ; flyspell is on, turn it off
	(message "Flyspell off")
	(flyspell-mode -1))
                                        ; else - flyspell is off, turn it on
    (flyspell-on-for-buffer-type)))

(defun my-next-error ()
  "Move point to next error and highlight it"
  (interactive)
  (progn
    (next-error)
    (end-of-line-nomark)
    (beginning-of-line-mark)
    )
  )
(defun my-previous-error ()
  "Move point to previous error and highlight it"
  (interactive)
  (progn
    (previous-error)
    (end-of-line-nomark)
    (beginning-of-line-mark)
    )
  )

(add-hook 'c-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'delete-trailing-whitespace nil t)))
(add-hook 'c++-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'delete-trailing-whitespace nil t)))

(add-hook 'c-mode-hook 'turn-on-auto-fill)
(add-hook 'c-mode-common-hook
          (lambda() (local-set-key (kbd "C-c C-o") 'ff-find-other-file)))
(add-hook 'c-mode-common-hook
          (lambda() (local-set-key (kbd "C-c C-r") 'ff-find-related-file)))
(add-hook 'c++-mode-hook 'turn-on-auto-fill)
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'c-mode-common-hook
          (lambda() (flyspell-prog-mode)))

(defun eshell/clear ()
  "clear the eshell buffer"
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

;(setq load-path (cons "/usr/lib/erlang/lib/tools-2.9.1/emacs" load-path))
;(setq erlang-root-dir "/usr/lib/erlang")
;(setq exec-path (cons "/usr/lib/erlang/bin" exec-path))
;(require 'erlang-start)

(use-package smart-tab)
(global-smart-tab-mode 1)

;(require '6502-mode)

(when (require 'volatile-highlights nil 'noerror)
  (volatile-highlights-mode t))

;; (require 'eglot)
;; (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
;; (add-hook 'c-mode-hook 'eglot-ensure)
;; (add-hook 'c++-mode-hook 'eglot-ensure)

(defun git-commit ()
  ""
  (when (or (eq major-mode 'c-mode)
            (eq major-mode 'c++-mode)
            (eq major-mode 'markdown-mode))
    (async-shell-command (format "git commit -a -m '%s'" (file-name-nondirectory buffer-file-name)))))
(add-to-list 'display-buffer-alist '("*Async Shell Commands*" display-buffer-no-window (nil)))
(add-hook 'after-save-hook 'git-commit)


;; (global-set-key (kbd "s-[") 'tab-bar-switch-to-prev-tab)
;; (global-set-key (kbd "s-]") 'tab-bar-switch-to-next-tab)
;; (global-set-key (kbd "s-t") 'tab-bar-new-tab)
;; (global-set-key (kbd "s-w") 'tab-bar-close-tab)
;; (when (< 26 emacs-major-version)
;;   (tab-bar-mode 1)                           ;; enable tab bar
;;   (setq tab-bar-show 1)                      ;; hide bar if <= 1 tabs open
;;   (setq tab-bar-close-button-show nil)       ;; hide tab close / X button
;;   (setq tab-bar-new-tab-choice "*dashboard*");; buffer to show in new tabs
;;   (setq tab-bar-tab-hints t)                 ;; show tab numbers
;;   (setq tab-bar-format '(tab-bar-format-tabs tab-bar-separator))
;;   (setq tab-bar-select-tab-modifiers "super"))

;; (defun code-compile()
;;   (interactive)
;;   (unless (file-exists-p "Makefile")
;;     (set (make-local-variable 'compile-command)
;; 	 (let ((file (file-name-nondirectory buffer-file-name)))
;; 	   (format "%s -o %s %s"
;; 		   (if (equal (file-name-extension file) "cpp") "g++" "gcc")
;; 		   (file-name-sans-extension file)
;; 		   file)))
;;     (compile compile-command)))

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

(global-set-key [f9] 'code-compile)
