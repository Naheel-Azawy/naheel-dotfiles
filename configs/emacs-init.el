;;; emacs-init.el --- Personal config file  -*- lexical-binding: t; -*-

;;; Commentary:

;; Copyright 2020-2021 Naheel Azawy.  All rights reserved.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; Author: Naheel Azawy
;; Version: 1.0.0
;; Keywords: init
;; URL: https://github.com/Naheel-Azawy/naheel-dotfiles
;;
;; This file is not part of GNU Emacs.
;;; Code:

;; ---- TINY ----
;; option for tiny installations
(setq tiny (getenv "TINY"))
(setq tiny t)

;; ---- MELPA and USE_PACKAGE ----
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org"   . "https://orgmode.org/elpa/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; ---- KEYS ----
(global-set-key (kbd "C-x <up>")    'windmove-up)
(global-set-key (kbd "C-x <down>")  'windmove-down)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>")  'windmove-left)
;; because no one knows how to use emacs...
(cua-mode 1)
(setq cua-keep-region-after-copy t)
(global-set-key (kbd "C-a") 'mark-whole-buffer)
(with-eval-after-load 'org
  (define-key org-mode-map "\C-a" 'mark-whole-buffer))
(global-set-key (kbd "C-f") 'isearch-forward)
(define-key isearch-mode-map "\C-f" 'isearch-repeat-forward)
(define-key isearch-mode-map "\C-v" 'isearch-yank-pop)
(global-set-key (kbd "C-s") 'save-buffer)
(use-package undo-tree
  :config (global-undo-tree-mode))
(global-set-key (kbd "C-z") 'undo-tree-undo)
(global-set-key (kbd "M-z") 'undo-tree-redo)
(setq org-support-shift-select t)
(global-set-key (kbd "C-q") 'save-buffers-kill-terminal)
;; zoom
(global-set-key (kbd "C-S-<prior>") 'text-scale-increase)
(global-set-key (kbd "C-S-<next>")  'text-scale-decrease)

;; ---- VISUALS ----
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode)
(global-hl-line-mode 1)
(xterm-mouse-mode)
(global-set-key (kbd "<mouse-4>") 'scroll-down-line)
(global-set-key (kbd "<mouse-5>") 'scroll-up-line)
(setq-default tab-width 4)
;;(setq-default show-trailing-whitespace nil)

;; ---- TITLE ----
(defun xterm-title-update ()
  (send-string-to-terminal
   (concat "\033]2; " (buffer-name) " - " invocation-name "\007")))
(defun frame-title-update ()
  (setq frame-title-format
		(concat (buffer-name) " - " invocation-name)))
;; (add-hook 'window-configuration-change-hook 'xterm-title-update)
(add-hook 'window-configuration-change-hook 'frame-title-update)

;; ---- SCROLL ----
(setq scroll-step 1
      scroll-conservatively 10000
      scroll-margin 5)

;; ---- FONT ----
(set-face-attribute 'default nil
                    :family "Iosevka Fixed"
                    :height 130)
(set-fontset-font "fontset-default"
                  'arabic
                  (font-spec :family "Kawkab Mono" :size 14)
                  nil 'prepend)

;; ---- REMOVE BG COLOR ----
(defun on-frame-open (&optional frame)
  "If the FRAME created in terminal don't load background color."
  (unless (display-graphic-p frame)
    (set-face-background 'default "unspecified-bg" frame)))
(add-hook 'after-make-frame-functions 'on-frame-open)

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
          (comp          . "#6c4173") ;; changed
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

;; ---- SPACES ----
(setq-default indent-tabs-mode nil)

;; ---- MODELINE ----
(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; ---- GIT ----
(use-package git-gutter
  :config (global-git-gutter-mode 1))

(unless tiny

  ;; ---- LSP ----
  (use-package lsp-mode)
  (use-package company-lsp)
  (use-package lsp-ui)
  (use-package lsp-java :after lsp)
  (use-package lsp-dart)
  (setq gc-cons-threshold 100000000)
  (setq lsp-completion-provider :capf)
  (setq lsp-idle-delay 0.500)
  (setq lsp-log-io nil)
  ;; (setq lsp-enable-links nil)
  ;; (setq lsp-signature-render-documentation nil)
  ;; (setq lsp-headerline-breadcrumb-enable nil)
  ;; (setq lsp-ui-doc-enable nil)
  ;; (setq lsp-completion-enable-additional-text-edit nil)

  ;; ---- WEB ----
  (use-package web-mode
    :mode "\\.html?\\'"
    :init
    (setq web-mode-engines-alist '(("django" . "\\.html\\'")))
    (setq web-mode-ac-sources-alist
          '(("css" . (ac-source-css-property))
            ("html" . (ac-source-words-in-buffer ac-source-abbrev))))
    (setq web-mode-enable-auto-closing t)
    (setq web-mode-enable-auto-quoting t)
    (setq web-mode-enable-current-element-highlight t)
    (setq web-mode-enable-current-column-highlight t))

  ;; ---- OTHER LANGS ----
  (use-package basic-mode)
  (use-package cc-mode)
  (use-package vala-mode)
  (use-package csharp-mode)
  (use-package dart-mode)
  (use-package go-mode)
  (use-package rust-mode)
  (use-package typescript-mode)
  (use-package julia-mode)
  (use-package kotlin-mode)
  (use-package gnuplot-mode)
  (use-package sparql-mode :mode "\\.rpg\\'")
  (use-package ttl-mode :mode "\\.ttl\\'")
  (use-package protobuf-mode)
  (use-package yaml-mode)
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
  (use-package js2-mode :mode "\\.js\\'"
    :custom-face
    (js2-external-variable ((t (:foreground "brightblack")))))
  (use-package v-mode :mode "\\.v\\'")
  (use-package octave :mode "\\.m\\'")
  (use-package python :mode
    ("\\.py\\'"  . python-mode)
    ("\\.pyx\\'" . python-mode)))

;; ---- RUN ----
(defun run-program ()
  "Execute a source file."
  (interactive)
  (defvar cmd)
  (setq cmd (concat "rn " (buffer-name) ))
  (shell-command cmd))
(global-set-key [C-f5] 'run-program)

;; ---- TOYS ----
(use-package iedit :bind ("C-x e" . iedit-mode))
(use-package anzu :config (global-anzu-mode +1))
(use-package adaptive-wrap)
(use-package so-long)
(global-so-long-mode 1)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(unless tiny
  (use-package flycheck :init (global-flycheck-mode))
  (use-package rainbow-mode)
  (use-package dumb-jump
    :config
    (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
    :bind
    ("C-j" . xref-find-definitions)
    ("M-j" . xref-pop-marker-stack))
  (use-package writeroom-mode
    :custom
    (writeroom-fullscreen-effect 'maximized)
    (writeroom-border-width 50)
    (writeroom-bottom-divider-width 0)
    (writeroom-extra-line-spacing nil)
    (writeroom-fringes-outside-margins nil))
  (use-package academic-phrases))

;; ---- MULTIPLE CURSERS ----
(use-package multiple-cursors
  :init (require 'multiple-cursors)
  :bind ("C-]" . mc/mark-next-like-this))

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
(defun duplicate-line (arg)
  "Duplicate current line ARG times, leaving point in lower line.
from: https://stackoverflow.com/a/998472/3825872"
  (interactive "*p")

  ;; save the point for undo
  (setq buffer-undo-list (cons (point) buffer-undo-list))

  ;; local variables for start and end of line
  (let ((bol (save-excursion (beginning-of-line) (point)))
        eol)
    (save-excursion

      ;; don't use forward-line for this, because you would have
      ;; to check whether you are at the end of the buffer
      (end-of-line)
      (setq eol (point))

      ;; store the line and disable the recording of undo information
      (let ((line (buffer-substring bol eol))
            (buffer-undo-list t)
            (count arg))
        ;; insert the line arg times
        (while (> count 0)
          (newline)         ;; because there is no newline in 'line'
          (insert line)
          (setq count (1- count)))
        )

      ;; create the undo information
      (setq buffer-undo-list (cons (cons eol (point)) buffer-undo-list)))
    ) ; end-of-let

  ;; put the point in the lowest line and return
  (next-line arg))
(global-set-key (kbd "C-c d") 'duplicate-line)

;; ---- XCLIP ----
(use-package xclip
  :config
  (when (eq 0 (shell-command "type xclip"))
    (xclip-mode 1)))

;; ---- BACKUP ----
(setq backup-directory-alist `(("." . "~/.cache/emacs-saves")))

;; ---- COMPANY ----
(use-package company
  :config (global-company-mode))

;; ---- HELM ----
(use-package helm
  :config (helm-mode 1)
  :bind
  ("M-x"     . helm-M-x)
  ("C-x r b" . helm-filtered-bookmarks)
  ("C-x C-f" . helm-find-files))

;; ---- HELM FLYSPELL ----
(unless tiny
  (use-package flyspell-correct-helm
    :bind ("C-\\" . flyspell-correct-wrapper)))

;; ---- CALFW ----
(unless tiny
  (use-package calfw)
  (use-package calfw-org
    :after calfw
    :init
    (require 'calfw-org)
    (setq cfw:fchar-junction ?╋
          cfw:fchar-vertical-line ?┃
          cfw:fchar-horizontal-line ?━
          cfw:fchar-left-junction ?┣
          cfw:fchar-right-junction ?┫
          cfw:fchar-top-junction ?┯
          cfw:fchar-top-left-corner ?┏
          cfw:fchar-top-right-corner ?┓)
    :custom-face
    (cfw:face-title ((t (:foreground "#f0dfaf" :weight bold :height 2.0 :inherit variable-pitch))))
    (cfw:face-header ((t (:foreground "#ffffff" :weight bold))))
    (cfw:face-sunday ((t :foreground "#ffffff" :weight bold)))
    (cfw:face-saturday ((t :foreground "#ffffff" :weight bold)))
    (cfw:face-holiday ((t :background "grey10" :foreground "#ffffff" :weight bold)))
    (cfw:face-grid ((t :foreground "DarkGrey")))
    (cfw:face-default-content ((t :foreground "#ffffff")))
    (cfw:face-periods ((t :foreground "cyan")))
    (cfw:face-day-title ((t :background "grey10")))
    (cfw:face-default-day ((t :weight bold :inherit cfw:face-day-title)))
    (cfw:face-annotation ((t :foreground "#ffffff" :inherit cfw:face-day-title)))
    (cfw:face-disable ((t :foreground "DarkGray" :inherit cfw:face-day-title)))
    (cfw:face-today-title ((t :background "#5f5f87" :weight bold)))
    (cfw:face-today ((t :background: "grey10" :weight bold)))
    (cfw:face-select ((t :background "#2f2f2f")))
    (cfw:face-toolbar ((t :foreground "#000000" :background "#000000")))
    (cfw:face-toolbar-button-off ((t :foreground "#555555" :weight bold)))
    (cfw:face-toolbar-button-on ((t :foreground "#ffffff" :weight bold)))))

;; ---- LATEX ----
(unless tiny
  (use-package tex
    :ensure auctex

    :init
    (setq
     TeX-parse-self t
     reftex-plug-into-AUCTeX t)

    :hook
    (LaTeX-mode . toggle-word-wrap)
    (LaTeX-mode . adaptive-wrap-prefix-mode)
    (LaTeX-mode . flyspell-mode)
    (LaTeX-mode . LaTeX-math-mode)
    (LaTeX-mode . turn-on-reftex)

    :custom
    (TeX-PDF-mode t)
    (TeX-source-correlate-method 'synctex)
    (TeX-source-correlate-mode t)
    (TeX-source-correlate-start-server t)))

;; ---- ORG ----
(unless tiny
  (use-package org
    :init
    (setq
     org-agenda-files (list (getenv "ORG_TODO"))
     org-log-done 'time
     org-image-actual-width 500
     org-export-in-background nil

     org-latex-pdf-process '("pdflatexorgwraper %f")

     org-preview-latex-default-process 'dvipng
     org-format-latex-options (plist-put org-format-latex-options :scale 1.7)

     org-todo-keywords '((sequence "TODO" "PROG" "|" "DONE" "CNCL"))
     org-todo-keyword-faces '(("PROG" . "yellow") ("CNCL" . "blue")))

    :hook
    (org-mode . toggle-word-wrap)
    (org-mode . adaptive-wrap-prefix-mode)
    (org-mode . org-bullets-mode)

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
    (add-to-list 'org-file-apps '("\\.pdf\\'" . "evince %s"))
    (delete '("\\.html\\'" . default) org-file-apps)
    (add-to-list 'org-file-apps '("\\.html\\'" . "browser %s"))

    ;; -- TEMPO --
    (require 'org-tempo))

  (use-package org-ref)
  (use-package org-bullets)
  (use-package ox-reveal)
  (use-package ox-pandoc :init
    (setq
     org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js"
     org-reveal-mathjax t))

  (with-eval-after-load 'ox-latex
    (customize-set-value 'org-latex-hyperref-template "
\\hypersetup{\n pdfauthor={%a},\n pdftitle={%t},
 pdfsubject={%d},\n pdfcreator={%c}, \n pdflang={%L},
 hidelinks=true,\n draft=false\n}\n")

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
                   ("\\chapter{%s}" . "\\chapter*{%s}")
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")))

    (add-to-list 'org-latex-classes
                 '("beamer"
                   "\\documentclass\[presentation\]\{beamer\}"
                   ("\\section\{%s\}" . "\\section*\{%s\}")
                   ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
                   ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))))

;; ---- OUTLINE ----
(unless tiny
  (use-package outline
    :config
    (defun outline-body-p ()
      (save-excursion
        (outline-back-to-heading)
        (outline-end-of-heading)
        (and (not (eobp))
             (progn (forward-char 1)
                    (not (outline-on-heading-p))))))

    (defun outline-body-visible-p ()
      (save-excursion
        (outline-back-to-heading)
        (outline-end-of-heading)
        (not (outline-invisible-p))))

    (defun outline-subheadings-p ()
      (save-excursion
        (outline-back-to-heading)
        (let ((level (funcall outline-level)))
          (outline-next-heading)
          (and (not (eobp))
               (< level (funcall outline-level))))))

    (defun outline-subheadings-visible-p ()
      (interactive)
      (save-excursion
        (outline-next-heading)
        (not (outline-invisible-p))))

    (defun outline-hide-more ()
      (interactive)
      (when (outline-on-heading-p)
        (cond ((and (outline-body-p)
                    (outline-body-visible-p))
               (hide-entry)
               (hide-leaves))
              (t
               (hide-subtree)))))

    (defun outline-show-more ()
      (interactive)
      (when (outline-on-heading-p)
        (cond ((and (outline-subheadings-p)
                    (not (outline-subheadings-visible-p)))
               (show-children))
              ((and (not (outline-subheadings-p))
                    (not (outline-body-visible-p)))
               (show-subtree))
              ((and (outline-body-p)
                    (not (outline-body-visible-p)))
               (show-entry))
              (t
               (show-subtree)))))

    (let ((map outline-mode-map))
      (define-key map (kbd "M-<left>") 'outline-hide-more)
      (define-key map (kbd "M-<right>") 'outline-show-more)
      (define-key map (kbd "M-<up>") 'outline-previous-visible-heading)
      (define-key map (kbd "M-<down>") 'outline-next-visible-heading)
      (define-key map (kbd "C-c J") 'outline-hide-more)
      (define-key map (kbd "C-c L") 'outline-show-more)
      (define-key map (kbd "C-c I") 'outline-previous-visible-heading)
      (define-key map (kbd "C-c K") 'outline-next-visible-heading))

    (let ((map outline-minor-mode-map))
      (define-key map (kbd "M-<left>") 'outline-hide-more)
      (define-key map (kbd "M-<right>") 'outline-show-more)
      (define-key map (kbd "M-<up>") 'outline-previous-visible-heading)
      (define-key map (kbd "M-<down>") 'outline-next-visible-heading)
      (define-key map (kbd "C-c J") 'outline-hide-more)
      (define-key map (kbd "C-c L") 'outline-show-more)
      (define-key map (kbd "C-c I") 'outline-previous-visible-heading)
      (define-key map (kbd "C-c K") 'outline-next-visible-heading))

    (provide 'outline-mode-easy-bindings)

    (add-hook 'outline-mode-hook 'my-outline-easy-bindings)
    (add-hook 'outline-minor-mode-hook 'my-outline-easy-bindings)

    (defun my-outline-easy-bindings ()
      (require 'outline-mode-easy-bindings nil t))

    (add-hook 'LaTeX-mode-hook #'outline-minor-mode)))

;; ---- VTERM ----
(unless tiny
  (use-package vterm
    :custom (vterm-shell "/usr/bin/fish")))

;; ---- EXTRA LISP ----
(setq lisp-directory (concat user-emacs-directory "lisp"))
(unless (file-directory-p lisp-directory) (make-directory lisp-directory))
(add-to-list 'load-path lisp-directory)

;; --- LACARTE ---
(unless (file-exists-p (expand-file-name "lacarte.el" lisp-directory))
  (url-copy-file "https://www.emacswiki.org/emacs/download/lacarte.el"
                 (expand-file-name "lacarte.el" lisp-directory)))
(unless (file-exists-p (expand-file-name "lacarte.elc" lisp-directory))
  (byte-compile-file (expand-file-name "lacarte.el" lisp-directory)))
(require 'lacarte)
(global-set-key [?\e ?\M-x] 'lacarte-execute-menu-command)

;;; emacs-init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-command-list
   '(("Quick" "pdflatexorgwraper -a %s" TeX-run-TeX nil
      (latex-mode doctex-mode)
      :help "Quick LaTeX compile")
     ("TeX" "%(PDF)%(tex) %(file-line-error) %`%(extraopts) %S%(PDFout)%(mode)%' %t" TeX-run-TeX nil
      (plain-tex-mode texinfo-mode ams-tex-mode)
      :help "Run plain TeX")
     ("LaTeX" "%`%l%(mode)%' %T" TeX-run-TeX nil
      (latex-mode doctex-mode)
      :help "Run LaTeX")
     ("Makeinfo" "makeinfo %(extraopts) %t" TeX-run-compile nil
      (texinfo-mode)
      :help "Run Makeinfo with Info output")
     ("Makeinfo HTML" "makeinfo %(extraopts) --html %t" TeX-run-compile nil
      (texinfo-mode)
      :help "Run Makeinfo with HTML output")
     ("AmSTeX" "amstex %(PDFout) %`%(extraopts) %S%(mode)%' %t" TeX-run-TeX nil
      (ams-tex-mode)
      :help "Run AMSTeX")
     ("ConTeXt" "%(cntxcom) --once --texutil %(extraopts) %(execopts)%t" TeX-run-TeX nil
      (context-mode)
      :help "Run ConTeXt once")
     ("ConTeXt Full" "%(cntxcom) %(extraopts) %(execopts)%t" TeX-run-TeX nil
      (context-mode)
      :help "Run ConTeXt until completion")
     ("BibTeX" "bibtex %s" TeX-run-BibTeX nil
      (plain-tex-mode latex-mode doctex-mode context-mode texinfo-mode ams-tex-mode)
      :help "Run BibTeX")
     ("Biber" "biber %s" TeX-run-Biber nil
      (plain-tex-mode latex-mode doctex-mode texinfo-mode ams-tex-mode)
      :help "Run Biber")
     ("View" "%V" TeX-run-discard-or-function t t :help "Run Viewer")
     ("Print" "%p" TeX-run-command t t :help "Print the file")
     ("Queue" "%q" TeX-run-background nil t :help "View the printer queue" :visible TeX-queue-command)
     ("File" "%(o?)dvips %d -o %f " TeX-run-dvips t
      (plain-tex-mode latex-mode doctex-mode texinfo-mode ams-tex-mode)
      :help "Generate PostScript file")
     ("Dvips" "%(o?)dvips %d -o %f " TeX-run-dvips nil
      (plain-tex-mode latex-mode doctex-mode texinfo-mode ams-tex-mode)
      :help "Convert DVI file to PostScript")
     ("Dvipdfmx" "dvipdfmx %d" TeX-run-dvipdfmx nil
      (plain-tex-mode latex-mode doctex-mode texinfo-mode ams-tex-mode)
      :help "Convert DVI file to PDF with dvipdfmx")
     ("Ps2pdf" "ps2pdf %f" TeX-run-ps2pdf nil
      (plain-tex-mode latex-mode doctex-mode texinfo-mode ams-tex-mode)
      :help "Convert PostScript file to PDF")
     ("Glossaries" "makeglossaries %s" TeX-run-command nil
      (plain-tex-mode latex-mode doctex-mode texinfo-mode ams-tex-mode)
      :help "Run makeglossaries to create glossary
     file")
     ("Index" "makeindex %s" TeX-run-index nil
      (plain-tex-mode latex-mode doctex-mode texinfo-mode ams-tex-mode)
      :help "Run makeindex to create index file")
     ("upMendex" "upmendex %s" TeX-run-index t
      (plain-tex-mode latex-mode doctex-mode texinfo-mode ams-tex-mode)
      :help "Run upmendex to create index file")
     ("Xindy" "texindy %s" TeX-run-command nil
      (plain-tex-mode latex-mode doctex-mode texinfo-mode ams-tex-mode)
      :help "Run xindy to create index file")
     ("Check" "lacheck %s" TeX-run-compile nil
      (latex-mode)
      :help "Check LaTeX file for correctness")
     ("ChkTeX" "chktex -v6 %s" TeX-run-compile nil
      (latex-mode)
      :help "Check LaTeX file for common mistakes")
     ("Spell" "(TeX-ispell-document \"\")" TeX-run-function nil t :help "Spell-check the document")
     ("Clean" "TeX-clean" TeX-run-function nil t :help "Delete generated intermediate files")
     ("Clean All" "(TeX-clean t)" TeX-run-function nil t :help "Delete generated intermediate and output files")
     ("Other" "" TeX-run-command t t :help "Run an arbitrary command")))
 '(package-selected-packages
   '(lacarte ac-octave octave-mode v-mode vterm ranger org-ref ox-reveal ox-pandoc org-bullets auctex calfw-org calfw flyspell-correct-helm helm xclip origami multiple-cursors adaptive-wrap academic-phrases anzu writeroom-mode dumb-jump iedit rainbow-mode flycheck js2-mode ein cmake-mode xonsh-mode elvish-mode fish-mode dockerfile-mode solidity-mode arduino-mode haxe-mode glsl-mode yaml-mode protobuf-mode ttl-mode sparql-mode gnuplot-mode kotlin-mode julia-mode typescript-mode rust-mode go-mode csharp-mode vala-mode basic-mode web-mode lsp-dart lsp-java lsp-ui company-lsp lsp-mode git-gutter doom-modeline spacemacs-theme undo-tree use-package))
 '(vterm-shell "/usr/bin/fish")
 '(writeroom-border-width 50)
 '(writeroom-bottom-divider-width 0)
 '(writeroom-extra-line-spacing nil)
 '(writeroom-fringes-outside-margins nil)
 '(writeroom-fullscreen-effect 'maximized))
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
