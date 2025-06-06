;;; emacs-init.el --- Personal config file  -*- lexical-binding: t; -*-

;;; Commentary:

;; Copyright 2020-present Naheel Azawy.  All rights reserved.

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
(setq tiny (equal (getenv "TINY") "t"))

;; --- CUSTOM VARS ----
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; ---- MELPA and USE_PACKAGE ----
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; ---- SCRATCH ----
(setq initial-major-mode 'fundamental-mode)
(setq initial-scratch-message nil)

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
(global-set-key (kbd "C-f") 'isearch-forward-regexp)
(global-set-key (kbd "C-M-f") 'isearch-forward)
(define-key isearch-mode-map "\C-f" 'isearch-repeat-forward)
(define-key isearch-mode-map "\C-v" 'isearch-yank-pop)
(global-set-key (kbd "C-s") 'save-buffer)
(use-package undo-tree :config
  (global-undo-tree-mode)
  (setq undo-dir (concat user-emacs-directory "undo"))
  (setq undo-tree-history-directory-alist '(("." . "~/.config/emacs/undo"))))
(global-set-key (kbd "C-z") 'undo-tree-undo)
(global-set-key (kbd "M-z") 'undo-tree-redo)
(global-set-key (kbd "C-y") 'undo-tree-redo)
(setq org-support-shift-select t)
(global-set-key (kbd "C-q") 'save-buffers-kill-terminal)
;; zoom
(global-set-key (kbd "C-S-<prior>") 'text-scale-increase)
(global-set-key (kbd "C-S-<next>")  'text-scale-decrease)

;; TODO: arabic
(global-set-key (kbd "C-س") 'save-buffer)
(global-set-key (kbd "C-ئ") 'undo-tree-undo)
(global-set-key (kbd "M-ئ") 'undo-tree-redo)

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
(setq-default show-trailing-whitespace 1)

;; ---- THEME ----
(load-theme 'tsdh-dark t)
(set-background-color "#000")
(set-face-background 'hl-line "#111")
(set-face-foreground 'highlight nil)
(set-face-attribute 'region nil :background "#333")
;; Set background and foreground for *all* frames (existing and new)
(add-to-list 'default-frame-alist '(background-color . "black"))
;; Also apply to current frame if Emacs is already running
(set-face-attribute 'default nil :background "black")

;; ---- REMOVE BG COLOR ----
(defun on-frame-open (&optional frame)
  "If the FRAME created in terminal don't load background color."
  (if (display-graphic-p frame)
      (set-face-background 'default "#000" frame)
    (set-face-background 'default "unspecified-bg" frame)))
(add-hook 'after-make-frame-functions 'on-frame-open)

;; ---- TITLE ----
(setq-default frame-title-format '("%b - emacs"))
(defun my-buffer-change-hook ()
  "Set the title in terminals."
  (unless (display-graphic-p)
      (progn
        ;; xterm
        (send-string-to-terminal
         (concat "\033]2; " (buffer-name) " - " invocation-name "\007"))
        ;; tmux
        (let ((cmd (concat "tmux rename-window '" (buffer-name) " - emacs' 2>/dev/null ||:")))
          ;;(shell-command cmd nil)
          (call-process-shell-command cmd nil 0)
          ))))
(add-hook 'window-configuration-change-hook 'my-buffer-change-hook)

;; ---- MODELINE ----
(set-face-background 'mode-line "#222222")
(set-face-attribute 'mode-line nil :box `(:line-width 1 :color "#222222"))
(setq-default mode-line-format
      `(
        " "
        mode-line-mule-info
        mode-line-modified
        ;; mode-line-frame-identification
        "   "
        mode-line-buffer-identification
        "   "
        mode-line-position
        " "
        (vc-mode vc-mode)
        "   "
        ;; mode-line-modes
        (:propertize ("" mode-name)
                     help-echo "Major mode\n\
mouse-1: Display major mode menu\n\
mouse-2: Show help for major mode\n\
mouse-3: Toggle minor modes"
                     mouse-face mode-line-highlight
                     local-map ,mode-line-major-mode-keymap)
        (which-function-mode ("" which-func-format "--"))
        (global-mode-string ("--" global-mode-string))
        " "
        ;; "-%-"
        ))
(column-number-mode)

;; ---- SCROLL ----
(setq scroll-step 1
      scroll-conservatively 10000
      scroll-margin 5)
(pixel-scroll-precision-mode)

;; ---- FONT ----
(defun apply-font-now ()
  "Apply the intended font."
  (let ((font (concat (getenv "FONT") " " (getenv "FONT_SIZE_NUM"))))
    (set-face-attribute 'default   nil :font font)
    (set-face-attribute 'mode-line nil :font font)))
(apply-font-now)
(add-hook 'window-configuration-change-hook 'apply-font-now)

;; ---- WINDOW SPLIT TOGGLE ----
;; https://stackoverflow.com/a/33456622/3825872
(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))
(global-set-key (kbd "C-x |") 'toggle-window-split)

;; ---- SPACES ----
(setq-default indent-tabs-mode nil)
(defun infer-indentation-style ()
  "If our source file uses tabs, we use tabs, if spaces spaces,
and if neither, we use the current 'indent-tabs-mode'
https://www.emacswiki.org/emacs/NoTabs"
  (interactive)
  (let ((space-count (how-many "^  " (point-min) (point-max)))
        (tab-count (how-many "^\t" (point-min) (point-max))))
    (if (> space-count tab-count) (setq indent-tabs-mode nil))
    (if (> tab-count space-count) (setq indent-tabs-mode 'only)))
  (defvaralias 'c-basic-offset 'tab-width))

(defun tabs-indentation-style ()
  "Use tabs only"
  (interactive)
  (setq indent-tabs-mode 'only)
  (defvaralias 'c-basic-offset 'tab-width))

;; ---- ROOT ----
(defun sudo-reopen ()
  "Edit currently visited file as root."
  (interactive)
  (find-file (concat "/sudo::" buffer-file-name)))

;; ---- GIT ----
(use-package git-gutter
  :config (global-git-gutter-mode 1))

(unless tiny
  ;; ---- LSP ----
  (use-package lsp-mode)
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
  (use-package php-mode)
  (use-package lua-mode)
  (use-package basic-mode)
  (use-package vala-mode)
  (use-package dart-mode)
  (use-package go-mode)
  (use-package rust-mode)
  (use-package zig-mode)
  (use-package typescript-mode)
  (use-package julia-mode)
  (use-package kotlin-mode)
  (use-package gnuplot-mode)
  (use-package sparql-mode :mode "\\.rpg\\'")
  ;; (use-package ttl-mode :mode "\\.ttl\\'")
  (use-package protobuf-mode)
  (use-package yaml-mode)
  (use-package glsl-mode)
  (use-package haxe-mode)
  (use-package solidity-mode)
  (use-package dockerfile-mode)
  (use-package fish-mode)
  (use-package elvish-mode)
  (use-package xonsh-mode)
  (use-package cmake-mode)
  (use-package ein)
  (use-package ess)

  (use-package cc-mode
    :init (setq-default c-basic-offset 4))

  (add-hook 'c-mode-common-hook
	        (lambda()
	          (c-set-offset 'inextern-lang 0)))

  (defun insert-c-header-guard ()
    (interactive)
    (let ((loc (point))
          (upper-name
           (upcase (file-name-nondirectory (file-name-sans-extension buffer-file-name)))))
      (goto-char (point-min))
      (insert "#ifndef " upper-name "_H_\n")
      (insert "#define " upper-name "_H_\n\n")
      (goto-char (point-max))
	  (insert "\n#endif // " upper-name "_H_\n")
      (goto-char loc)))

  (defun insert-c-if-cpp ()
    (interactive)
    (let ((loc (point)))
      (goto-char (point-min))
      (insert "#ifdef __cplusplus\nextern \"C\"\n{\n#endif\n\n")
      (goto-char (point-max))
	  (insert "\n#ifdef __cplusplus\n}\n#endif\n")
      (goto-char loc)))

  (use-package clang-format)

  (use-package js2-mode
    :custom-face
    (js2-external-variable ((t (:foreground "brightblack")))))

  (use-package rjsx-mode
    :mode
    ("\\.js\\'"  . rjsx-mode)
    ("\\.mjs\\'"  . rjsx-mode)
    ("\\.jsx\\'" . rjsx-mode))

  (use-package octave
    :mode ("\\.m\\'" . octave-mode))

  (use-package python
    :mode
    ("\\.py\\'"  . python-mode)
    ("\\.pyx\\'" . python-mode)
    :bind
    ("M-<left>"  . python-indent-shift-left)
    ("M-<right>" . python-indent-shift-right))

  ;; https://emacs.stackexchange.com/a/58341
  (add-to-list 'display-buffer-alist '("*Async Shell Command*" display-buffer-no-window (nil)))
  (defun scad-gui ()
    (interactive)
    (async-shell-command (concat "openscad " (buffer-file-name))))
  ;; (use-package scad-mode) ;; :bind ("C-x C-e" . scad-gui))
  ;; (use-package scad-preview
  ;;   :custom
  ;;   (scad-preview-colorscheme "Starnight")
  ;;   (scad-preview-image-size '(900 . 900))
  ;;   (scad-preview-window-size 80)) ;; TODO: fix

  ;; ---- ARDUINO ----
  (add-to-list 'auto-mode-alist
               '("\\.ino\\'" .
                 (lambda ()
                   (c++-mode)
                   (flycheck-mode -1))))

  ;; ---- SVG ----
  (add-to-list 'auto-mode-alist
               '("\\.svg\\'" . (xml-mode)))

  ;; ---- XSD ----
  (add-to-list 'auto-mode-alist
               '("\\.xsd\\'" . (xml-mode)))

  ;; ---- PLATFORMIO ----
  ;; (use-package ccls)
  ;; (use-package platformio-mode)
  ;; (add-hook 'c++-mode-hook (lambda ()
  ;;                            (lsp-deferred)
  ;;                            (platformio-conditionally-enable)))

  ;; ---- CSV ----
  (use-package csv-mode
    :hook
    (csv-mode . csv-align-mode))

  ;; --- MORE SYNTAX HIGHLIGHT ----
  (dolist (mode-iter
           '(c-mode c++-mode java-mode
                    javascript-mode js2-mode rjsx-mode
                    octave-mode python-mode scad-mode glsl-mode
                    rust-mode go-mode vala-mode vlang-mode))
    (font-lock-add-keywords
     mode-iter
     '(
       ;; numbers
       ("\\_<[0-9.]+\\_>"        . font-lock-constant-face)
       ("\\_<0x[0-9a-fA-F]+\\_>" . font-lock-constant-face)
       ("\\_<0o[0-7]+\\_>"       . font-lock-constant-face)
       ("\\_<0b[01]+\\_>"        . font-lock-constant-face)

       ;; functions
       ;; ("\\([_a-zA-Z][_a-zA-Z0-9]*\\)[\t\s]*(" 1 font-lock-function-name-face)
       )))
  )

;; ---- RUN ----
(defun run-program ()
  "Execute a source file."
  (interactive)
  (defvar cmd)
  (setq cmd (concat "rn " (buffer-file-name)))
  (shell-command cmd))
(global-set-key [C-f5] 'run-program)
(defun run-program-term ()
  "Execute a source file in a new terminal."
  (interactive)
  (defvar cmd)
  (setq cmd (concat "$TERMINAL -e \"rn '" (buffer-file-name)
                    "'; echo press return to exit; read foo\" "
                    ">/dev/null 2>/dev/null &"))
  (shell-command cmd))
(global-set-key [C-f6] 'run-program-term)

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
    :bind
    ("C-j" . xref-find-definitions)
    ("M-j" . xref-go-back))
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  (use-package writeroom-mode
    :custom
    (writeroom-fullscreen-effect 'maximized)
    (writeroom-width 0.6)
    (writeroom-bottom-divider-width 0)
    (writeroom-extra-line-spacing nil)
    (writeroom-fringes-outside-margins nil))
  (use-package which-key :config (which-key-mode))
  (use-package visual-regexp)
  (use-package visual-regexp-steroids)
  (use-package academic-phrases))

(defun now ()
  "Insert string for today's date and time."
  (interactive)
  (insert (format-time-string "<%Y-%m-%d %H:%M>")))

(defun today ()
  "Insert string for today's date."
  (interactive)
  (insert (format-time-string "<%Y-%m-%d>")))

;; ---- MULTIPLE CURSERS ----
(use-package multiple-cursors
  :init (require 'multiple-cursors)
  :bind ("C-]" . mc/mark-next-like-this)
  :custom-face
  (mc/cursor-face ((t (:background "black" :foreground "white")))))

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

;; ---- ANSI COLORS ----
;; https://stackoverflow.com/a/76014429/3825872
(require 'ansi-color)
(defun ansi-color-after-scroll (window start)
  "Used by ansi-color-mode minor mode."
  (ansi-color-apply-on-region start (window-end window t) t))
(define-minor-mode ansi-color-mode
  "A very primitive minor mode to view log files containing ANSI color codes."
  :global nil
  :lighter ""
  (if ansi-color-mode
      (progn
        (ansi-color-apply-on-region (window-start) (window-end) t)
        (add-hook 'window-scroll-functions 'ansi-color-after-scroll 80 t))
    (remove-hook 'window-scroll-functions 'ansi-color-after-scroll t)))
(add-to-list 'auto-mode-alist '("\\.log\\'" . ansi-color-mode))

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

;; ---- FIX MINIBUFFER ----
(defun stop-using-minibuffer ()
  "Kill the minibuffer.
https://trey-jackson.blogspot.com/2010/04/emacs-tip-36-abort-minibuffer-when.html"
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))
(add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)

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
    (TeX-source-correlate-start-server t)
    (TeX-command-list
     '(("LaTeX" "latexwrapper -a %s" TeX-run-TeX nil
        (latex-mode doctex-mode)
        :help "Quick LaTeX compile")
       ("View" "%V" TeX-run-discard-or-function t t :help "Run Viewer")))))

;; ---- ORG ----
(unless tiny
  (use-package org
    :init
    (setq
     org-agenda-files (list (getenv "ORG_TODO"))
     org-log-done 'time
     org-image-actual-width 500
     org-export-in-background nil
     org-tags-column 0

     org-latex-pdf-process '("latexwrapper %f")
     org-highlight-latex-and-related '(native)

     org-preview-latex-default-process 'dvipng
     org-format-latex-options (plist-put org-format-latex-options :scale 1.7)

     org-todo-keywords '((sequence "TODO" "PROG" "|" "DONE" "CNCL"))
     org-todo-keyword-faces '(("PROG" . "yellow") ("CNCL" . "blue")))

    :hook
    (org-mode . toggle-truncate-lines)
    (org-mode . toggle-word-wrap)
    (org-mode . adaptive-wrap-prefix-mode)
    (org-mode . flyspell-mode)
    (org-mode . org-toggle-pretty-entities)

    :config
    ;; -- BABEL LANGS --
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((C          . t)
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
       (sql        . t)
       (sqlite     . t)
       (shell      . t)))
    (defun my-org-confirm-babel-evaluate (lang body)
      (not (member lang '("sql" "sqlite"))))
    (setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)

    ;; -- RUNNERS --
    (delete '("\\.pdf\\'" . default) org-file-apps)
    (add-to-list 'org-file-apps '("\\.pdf\\'" . "evince %s"))
    (delete '("\\.html\\'" . default) org-file-apps)
    (add-to-list 'org-file-apps '("\\.html\\'" . "ndg browser %s"))

    ;; -- TEMPO --
    (require 'org-tempo))

  (use-package org-ref)
  (require 'ox-beamer)
  (use-package ox-reveal)
  (use-package ox-pandoc :init
    (setq
     org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js"
     org-reveal-mathjax t))
  (use-package org-download :config (require 'org-download))

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
                 '("article"
                   "\\documentclass{article}
\\usepackage{geometry}
\\geometry{a4paper, margin=1in}"
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
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")))))

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

;; ---- EXTRA LISP ----
(setq lisp-directory (concat user-emacs-directory "lisp"))
(unless (file-directory-p lisp-directory) (make-directory lisp-directory))
(add-to-list 'load-path lisp-directory)

(defun extra-lisp-load (url name hash)
  "Load a random elisp file NAME at URL with HASH."
  (let* ((target (expand-file-name name              lisp-directory))
         (cached (expand-file-name (concat name "c") lisp-directory)))
    (if (and (file-exists-p target) (file-exists-p cached))
        t
      (progn
        (url-copy-file (concat url "/" name) target t)
        (let ((hash-real (with-temp-buffer
                           (insert-file-contents-literally target)
                           (secure-hash 'sha256 (current-buffer)))))
          (if (equal hash hash-real)
              (progn (byte-compile-file target) t)
            (delete-file target) nil))))))

;; --- LACARTE ---
(extra-lisp-load
 "https://www.emacswiki.org/emacs/download"
 "lacarte.el"
 "3694f37c5c5554882cf98b32b9322d8c243c9856aa735b1022ef30d3f0e954c3")
(require 'lacarte)
(global-set-key [?\e ?\M-x] 'lacarte-execute-menu-command)

;; --- VLANG ---
(extra-lisp-load
 "https://raw.githubusercontent.com/naheel-azawy/vlang-mode.el/master"
 "vlang-mode.el"
 "e4554cb6331775afb11dc548485683eb6af96e19640d5ce2a013803e89697d86")
(require 'vlang-mode)

;; --- HOLYC ---
(extra-lisp-load
 "https://raw.githubusercontent.com/naheel-azawy/holyc-mode.el/master"
 "holyc-mode.el"
 "6ce8777e55e01ff852f24f91fbc02b04e50fb0924a0f2df07414ff4e23dc0033")
(require 'holyc-mode)

;; --- SMALI ---
(extra-lisp-load
 "https://raw.githubusercontent.com/strazzere/Emacs-Smali/16c50ca2ab3159fb9f2d9b938ab7cbbf860bd14f"
 "smali-mode.el"
 "a5215884faf3feae341a32455c486077bed2a90d7e19142bc3b371759e89d212")
(require 'smali-mode)

;; --- TOUCH ---
;; (extra-lisp-load
;;  "https://raw.githubusercontent.com/naheel-azawy/touch-handler.el/master"
;;  "touch-handler.el"
;;  "1876efc5d944ce55000eceb57323304e2cd51a67ca13e2793706a802fe66bd69")
;; (load (expand-file-name "touch-handler.elc" lisp-directory))

;;; emacs-init.el ends here
