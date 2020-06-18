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

;; ---- VISUALS ----
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode)
(global-hl-line-mode 1)
(xterm-mouse-mode)
(set-face-attribute 'default nil :height 140)
(setq-default tab-width 4)
;;(setq-default show-trailing-whitespace nil)

;; ---- THEME ----
(use-package spacemacs-theme
  :defer t
  :init
  (setq spacemacs-theme-custom-colors
        (quote
         ((act1          . "#222226")
          (act2          . "#5d4d7a")
          (base          . "#b2b2b2")
          (base-dim      . "#686868")
          (bg1           . "#000000") ;; changed
          (bg2           . "#101010") ;; changed
          (bg3           . "#0a0a0a") ;; changed
          (bg4           . "#070707") ;; changed
          (border        . "#5d4d7a")
          (cblk          . "#cbc1d5")
          (cblk-ln       . "#827591")
          (cblk-bg       . "#070707") ;; changed
          (cblk-ln-bg    . "#1f1f1f") ;; changed
          (cursor        . "#e3dedd")
          (const         . "#a45bad")
          (comment       . "#2aa1ae")
          (comment-light . "#2aa1ae")
          (comment-bg    . "#000000") ;; changed
          (comp          . "#111111") ;; changed
          (err           . "#e0211d")
          (func          . "#bc6ec5")
          (head1         . "#4f97d7")
          (head1-bg      . "#000000") ;; changed
          (head2         . "#2d9574")
          (head2-bg      . "#293235")
          (head3         . "#67b11d")
          (head3-bg      . "#293235")
          (head4         . "#b1951d")
          (head4-bg      . "#32322c")
          (highlight     . "#444155")
          (highlight-dim . "#3b314d")
          (keyword       . "#4f97d7")
          (lnum          . "#44505c")
          (mat           . "#86dc2f")
          (meta          . "#9f8766")
          (str           . "#2d9574")
          (suc           . "#86dc2f")
          (ttip-sl       . "#5e5079")
          (ttip          . "#dddddd") ;; changed
          (ttip-bg       . "#111111") ;; changed
          (type          . "#ce537a")
          (var           . "#7590db")
          (war           . "#dc752f")
          (aqua          . "#2d9574")
          (aqua-bg       . "#293235")
          (green         . "#67b11d")
          (green-bg      . "#293235")
          (green-bg-s    . "#29422d")
          (cyan          . "#28def0")
          (red           . "#f2241f")
          (red-bg        . "#3c2a2c")
          (red-bg-s      . "#512e31")
          (blue          . "#4f97d7")
          (blue-bg       . "#293239")
          (blue-bg-s     . "#2d4252")
          (magenta       . "#a31db1")
          (yellow        . "#b1951d")
          (yellow-bg     . "#32322c"))))
  (load-theme 'spacemacs-dark t))

;; ---- REMOVE BG COLOR ----
(defun on-frame-open (&optional frame)
  "If the FRAME created in terminal don't load background color."
  (unless (display-graphic-p frame)
    (set-face-background 'default "unspecified-bg" frame)))
(add-hook 'after-make-frame-functions 'on-frame-open)

;; ---- SCROLL ----
(setq scroll-step           1
      scroll-conservatively 10000
      scroll-margin 5)

;; ---- MODELINE ----
(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; ---- GIT ----
(use-package git-gutter
  :config (global-git-gutter-mode 1))

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

;; ---- OTHER LANGS ----
(use-package basic-mode)
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
(use-package dockerfile-mode)
(use-package fish-mode)
(use-package elvish-mode)
(use-package xonsh-mode)
(use-package cmake-mode)
(use-package ein)
(use-package js2-mode
  :mode "\\.js\\'"
  :config (custom-set-faces
           '(js2-external-variable ((t (:foreground "brightblack"))))))

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

;; ---- TOYS ----
(use-package flycheck :init (global-flycheck-mode))
(use-package rainbow-mode)
(use-package iedit)
(use-package dumb-jump)
(use-package writeroom-mode)
(use-package anzu :config (global-anzu-mode +1))

;; ---- MULTIPLE CURSERS ----
(use-package multiple-cursors
  :init
  (require 'multiple-cursors)
  :bind
  ("C-]" . mc/mark-next-like-this))

;; ---- KEYS ----
(global-set-key (kbd "C-x <up>")    'windmove-up)
(global-set-key (kbd "C-x <down>")  'windmove-down)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>")  'windmove-left)
;; because no one knows how to use emacs...
(cua-mode 1)
(global-set-key (kbd "C-a") 'mark-whole-buffer)
(global-set-key (kbd "C-f") 'isearch-forward)
(define-key isearch-mode-map "\C-f" 'isearch-repeat-forward)
(define-key isearch-mode-map "\C-v" 'isearch-yank-pop)
(global-set-key (kbd "C-s") 'save-buffer)
(use-package undo-tree
  :config (global-undo-tree-mode))
(global-set-key (kbd "C-z") 'undo-tree-undo)
(global-set-key (kbd "M-z") 'undo-tree-redo)

;; ---- ORIGAMI ----
(use-package origami
  :init (global-origami-mode)
  :bind ("C-c SPC" . origami-recursively-toggle-node))

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

;; ---- SPACES ----
(defun infer-indentation-style ()
  ;; if our source file uses tabs, we use tabs, if spaces spaces, and if
  ;; neither, we use the current indent-tabs-mode
  ;; https://www.emacswiki.org/emacs/NoTabs
  (let ((space-count (how-many "^  " (point-min) (point-max)))
        (tab-count (how-many "^\t" (point-min) (point-max))))
    (if (> space-count tab-count) (setq indent-tabs-mode nil))
    (if (> tab-count space-count) (setq indent-tabs-mode t))))
(setq-default indent-tabs-mode nil)

;; ---- BACKUP ----
(setq backup-directory-alist `(("." . "~/.cache/emacs-saves")))

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
  (setq org-agenda-files (list "~/Dropbox/orgmode/TODO.org")
        org-log-done 'time
        org-image-actual-width 500)

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
  (setq org-latex-pdf-process '("pdflatexorgwraper -p %f"))

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

(use-package org-ref)

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
\\usepackage{geometry}
\\geometry{a4paper, margin=1in}
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
\\usepackage{geometry}
\\geometry{a4paper, margin=1in}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-latex-classes
               '("qutad"
                 "\\documentclass{qutad}"
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

;; ---- QUELPA ----
(unless (package-installed-p 'quelpa)
  (with-temp-buffer
    (url-insert-file-contents "https://github.com/quelpa/quelpa/raw/master/quelpa.el")
    (eval-buffer)
    (quelpa-self-upgrade)))

;; ---- VLANG ----
(quelpa
 '(vlang-mode :fetcher url
              :url "https://raw.githubusercontent.com/naheel-azawy/vlang-mode.el/master/vlang-mode.el"))
(require 'vlang-mode)

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
    (ranger dockerfile-mode basic-mode vlang-mode quelpa xonsh-mode elvish-mode undo-fu js2-mode ein cmake-mode origami fish-mode doom-modeline git-gutter smooth-scroll sublimity org-ref anzu flycheck flymake-shellcheck typescript-mode rust-mode kotlin-mode julia-mode go-mode dart-mode csharp-mode flyspell-correct-helm rainbow-mode web-mode company-mode org-bullets ox-groff calfw-org calfw undo-tree spacemacs-theme xclip use-package multiple-cursors lsp-ui lsp-java company-lsp))))
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
 '(cfw:face-toolbar-button-on ((t :foreground "#ffffff" :weight bold)))
 '(js2-external-variable ((t (:foreground "brightblack")))))
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

