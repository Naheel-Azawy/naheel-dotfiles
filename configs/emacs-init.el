;; ---- MELPA ----
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; ---- USE PACKAGE ----
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; ---- RUN ----
(defun run-program ()
  (interactive)
  (defvar cmd)
  (setq cmd (concat "rn " (buffer-name) ))
  (shell-command cmd))
(global-set-key [C-f5] 'run-program)

;; ---- LSP ----
(use-package lsp-mode)
(use-package company-lsp)
(use-package lsp-ui)
(use-package lsp-java :after lsp)

;; ---- WEB ----
(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (setq web-mode-engines-alist
	'(("django" . "\\.html\\'")))
  (setq web-mode-ac-sources-alist
	'(("css" . (ac-source-css-property))
	  ("html" . (ac-source-words-in-buffer ac-source-abbrev))))
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-quoting t)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-current-column-highlight t))

;; ---- VLANG ----
(setq vlang-font-lock-keywords
      (let* (
             ;; define several category of keywords
             (x-keywords '("break" "const" "continue" "defer" "else" "enum" "fn" "for" "go" "goto" "if" "import" "in" "interface" "match" "module" "mut" "none" "or" "pub" "return" "struct" "type"))
             (x-types '("bool" "string" "i8" "i16" "int" "i64" "i128" "byte" "u16" "u32" "u64" "u128" "rune" "f32" "f64" "byteptr" "voidptr" "map"))
             (x-constants '("true" "false"))

             ;; generate regex string for each category of keywords
             (x-keywords-regexp (regexp-opt x-keywords 'words))
             (x-types-regexp (regexp-opt x-types 'words))
             (x-constants-regexp (regexp-opt x-constants 'words)))

        `(
          (,x-keywords-regexp . font-lock-keyword-face)
          (,x-types-regexp . font-lock-type-face)
          (,x-constants-regexp . font-lock-constant-face)
          ;; note: order above matters, because once colored, that part won't change.
          ;; in general, put longer words first
          )))
;;;###autoload
(define-derived-mode vlang-mode javascript-mode "V"
  "Major mode for editing V files"
  (setq-local font-lock-defaults '((vlang-font-lock-keywords))))
(add-to-list 'auto-mode-alist '("\\.v\\'" . vlang-mode))

;; ---- OTHER STUFF ----
(use-package vala-mode)
(use-package csharp-mode)
(use-package dart-mode)
(use-package go-mode)
(use-package rust-mode)
(use-package typescript-mode)
(use-package julia-mode)
(use-package kotlin-mode)
(use-package gnuplot-mode)
(use-package sparql-mode)
(use-package ttl-mode)
(use-package glsl-mode)
(use-package haxe-mode)
(use-package arduino-mode)
(use-package solidity-mode)

(use-package flycheck :init (global-flycheck-mode))
(use-package rainbow-mode)
(use-package iedit)
(use-package dumb-jump)
(use-package writeroom-mode)
(use-package anzu :config (global-anzu-mode +1))

;; ---- OTHER MODES ----
(setq auto-mode-alist
      (cons
       '("\\.ttl$" . ttl-mode)
       auto-mode-alist))
(setq auto-mode-alist
      (cons
       '("\\.rpg$" . sparql-mode)
       auto-mode-alist))
(setq auto-mode-alist
      (cons
       '("\\.m$" . octave-mode)
       auto-mode-alist))

;; ---- MULTIPLE CURSERS ----
(use-package multiple-cursors
  :init
  (require 'multiple-cursors)
  :bind
  ("C-c C-\\" . mc/edit-lines)
  ("M-n"      . mc/mark-next-like-this)
  ("M-p"      . mc/mark-previous-like-this)
  ("C-c \\"   . mc/mark-all-like-this))

;; ---- UNDO TREE ----
(use-package undo-tree
  :config (global-undo-tree-mode)
  :bind ("M-/" . undo-tree-redo))

;; ---- KEYS ----
(global-set-key (kbd "C-c SPC") 'evil-toggle-fold)
(global-set-key (kbd "C-x <up>")    'windmove-up)
(global-set-key (kbd "C-x <down>")  'windmove-down)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>")  'windmove-left)
(cua-mode 1)
(global-set-key (kbd "C-a") 'mark-whole-buffer)
(global-set-key (kbd "C-f") 'isearch-forward)
(global-set-key (kbd "C-z") 'undo-tree-undo)
(global-set-key (kbd "C-Z") 'undo-tree-redo)

;; ---- DOS EOL ----
(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

;; ---- DUPLICATE LINE ----
(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank))
(global-set-key (kbd "C-d") 'duplicate-line)

;; ---- XCLIP ----
(use-package xclip
  :config (xclip-mode 1))

;; ---- VISUALS ----
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode)
(xterm-mouse-mode)
(set-face-attribute 'default nil :height 140)

;; ---- THEME ----
(use-package spacemacs-theme
  :defer t
  :init
  (setq spacemacs-theme-custom-colors
	(quote
	 ((bg1 . "#000000")
	  (bg2 . "#101010")
	  (bg3 . "#0a0a0a")
	  (bg4 . "#070707")
	  (comment-bg . "#000000")
	  (cblk-bg . "#070707")
	  (cblk-ln-bg . "#1f1f1f")
	  (head1-bg . "#000000"))))
  (load-theme 'spacemacs-dark t))

;; ---- COMPANY ----
(use-package company
  :config (global-company-mode))

;; ---- HELM ----
(use-package helm
  :config
  (helm-mode 1)
  :bind
  ("M-x"     . helm-M-x)
  ("C-x r b" . helm-filtered-bookmarks)
  ("C-x C-f" . helm-find-files))

;; ---- HELM FLYSPELL ----
(use-package flyspell-correct-helm
  :bind ("C-\\" . flyspell-correct-wrapper))

;; ---- CALFW ----
(use-package calfw :config
  (use-package calfw-org
    :init
    (require 'calfw-org)
    :config
    (custom-set-faces
     '(cfw:face-title ((t (:foreground "#f0dfaf" :weight bold :height 2.0 :inherit variable-pitch))))
     '(cfw:face-header ((t (:foreground "#ffffff" :weight bold))))
     '(cfw:face-sunday ((t :foreground "#ffffff" :weight bold)))
     '(cfw:face-saturday ((t :foreground "#ffffff" :weight bold)))
     '(cfw:face-holiday ((t :background "grey10" :foreground "#ffffff" :weight bold)))
     '(cfw:face-grid ((t :foreground "DarkGrey")))
     '(cfw:face-default-content ((t :foreground "#ffffff")))
     '(cfw:face-periods ((t :foreground "cyan")))
     '(cfw:face-day-title ((t :background "grey10")))
     '(cfw:face-default-day ((t :weight bold :inherit cfw:face-day-title)))
     '(cfw:face-annotation ((t :foreground "#ffffff" :inherit cfw:face-day-title)))
     '(cfw:face-disable ((t :foreground "DarkGray" :inherit cfw:face-day-title)))
     '(cfw:face-today-title ((t :background "#5f5f87" :weight bold)))
     '(cfw:face-today ((t :background: "grey10" :weight bold)))
     '(cfw:face-select ((t :background "#2f2f2f")))
     '(cfw:face-toolbar ((t :foreground "#000000" :background "#000000")))
     '(cfw:face-toolbar-button-off ((t :foreground "#555555" :weight bold)))
     '(cfw:face-toolbar-button-on ((t :foreground "#ffffff" :weight bold))))
    (setq cfw:fchar-junction ?╋
	  cfw:fchar-vertical-line ?┃
	  cfw:fchar-horizontal-line ?━
	  cfw:fchar-left-junction ?┣
	  cfw:fchar-right-junction ?┫
	  cfw:fchar-top-junction ?┯
	  cfw:fchar-top-left-corner ?┏
	  cfw:fchar-top-right-corner ?┓)))

;; ---- ORG ----
(use-package org
  :init
  (setq org-agenda-files (list "~/MEGA/orgmode/TODO.org"))

  :config
  ;; -- BABEL LANGS --
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((C          . t)
     (vala       . t)
     (python     . t)
     (js         . t)
     (R          . t)
     (octave     . t)
     (emacs-lisp . t)
     (java       . t)
     (latex      . t)
     (awk        . t)
     (sed        . t)
     (gnuplot    . t)
     (perl       . t)
     (ditaa      . t)
     (shell      . t)))

  ;; -- RUNNERS --
  (delete '("\\.pdf\\'" . default) org-file-apps)
  (add-to-list 'org-file-apps '("\\.pdf\\'" . "zathura %s"))
  (delete '("\\.html\\'" . default) org-file-apps)
  (add-to-list 'org-file-apps '("\\.html\\'" . "browser %s"))

  ;; -- MY "DIRTY" LaTeX EXPORT --
  (setq org-latex-pdf-process '("pdflatexorgwraper %f"))

  ;; -- TODO --
  (setq org-todo-keywords
	'((sequence "TODO" "PROG" "|" "DONE" "CNCL")))
  (setq org-todo-keyword-faces
	'(("PROG" . "yellow")
	  ("CNCL" . "blue")))

  ;; -- HOOKS --
  (add-hook 'org-mode-hook #'toggle-word-wrap)
  (add-hook 'org-mode-hook #'org-bullets-mode)
  )

(use-package org-bullets)

(use-package ox-pandoc :config
  (setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")
  (setq org-reveal-mathjax t))

(use-package ox-reveal)

(with-eval-after-load 'ox-latex
  (add-to-list 'org-latex-classes
	       '("IEEEtran"
		 "\\documentclass{IEEEtran}"
		 ("\\section{%s}" . "\\section*{%s}")
		 ("\\subsection{%s}" . "\\subsection*{%s}")
		 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
		 ("\\paragraph{%s}" . "\\paragraph*{%s}")
		 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-latex-classes
	       '("usual"
		 "\\documentclass{article}
\\usepackage[backend=biber,sorting=none,style=ieee]{biblatex}
\\usepackage{float}
\\usepackage[table]{xcolor}
\\usepackage{geometry}
\\geometry{a4paper, margin=1in}
\\renewcommand{\\baselinestretch}{1.15}
\\setlength{\\parindent}{0pt}"
		 ("\\section{%s}" . "\\section*{%s}")
		 ("\\subsection{%s}" . "\\subsection*{%s}")
		 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
		 ("\\paragraph{%s}" . "\\paragraph*{%s}")
		 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-latex-classes
	       '("ieee"
		 "\\documentclass{IEEEtran}
\\usepackage[backend=biber,sorting=none,style=ieee]{biblatex}
\\usepackage{float}
\\usepackage[table]{xcolor}
\\usepackage{geometry}
\\geometry{a4paper, margin=1in}
\\renewcommand{\\baselinestretch}{1.15}
\\setlength{\\parindent}{0pt}"
		 ("\\section{%s}" . "\\section*{%s}")
		 ("\\subsection{%s}" . "\\subsection*{%s}")
		 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
		 ("\\paragraph{%s}" . "\\paragraph*{%s}")
		 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-latex-classes
	       '("beamer"
		 "\\documentclass\[presentation\]\{beamer\}"
		 ("\\section\{%s\}" . "\\section*\{%s\}")
		 ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
		 ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}"))))

;; ---- END ----

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(package-selected-packages
   (quote
    (anzu flycheck flymake-shellcheck typescript-mode rust-mode kotlin-mode julia-mode go-mode dart-mode csharp-mode flyspell-correct-helm rainbow-mode web-mode company-mode org-bullets ox-groff calfw-org calfw undo-tree spacemacs-theme xclip use-package multiple-cursors lsp-ui lsp-java company-lsp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cfw:face-annotation ((t :foreground "#ffffff" :inherit cfw:face-day-title)))
 '(cfw:face-day-title ((t :background "grey10")))
 '(cfw:face-default-content ((t :foreground "#ffffff")))
 '(cfw:face-default-day ((t :weight bold :inherit cfw:face-day-title)))
 '(cfw:face-disable ((t :foreground "DarkGray" :inherit cfw:face-day-title)))
 '(cfw:face-grid ((t :foreground "DarkGrey")))
 '(cfw:face-header ((t (:foreground "#ffffff" :weight bold))))
 '(cfw:face-holiday ((t :background "grey10" :foreground "#ffffff" :weight bold)))
 '(cfw:face-periods ((t :foreground "cyan")))
 '(cfw:face-saturday ((t :foreground "#ffffff" :weight bold)))
 '(cfw:face-select ((t :background "#2f2f2f")))
 '(cfw:face-sunday ((t :foreground "#ffffff" :weight bold)))
 '(cfw:face-title ((t (:foreground "#f0dfaf" :weight bold :height 2.0 :inherit variable-pitch))))
 '(cfw:face-today ((t :background: "grey10" :weight bold)))
 '(cfw:face-today-title ((t :background "#5f5f87" :weight bold)))
 '(cfw:face-toolbar ((t :foreground "#000000" :background "#000000")))
 '(cfw:face-toolbar-button-off ((t :foreground "#555555" :weight bold)))
 '(cfw:face-toolbar-button-on ((t :foreground "#ffffff" :weight bold))))
