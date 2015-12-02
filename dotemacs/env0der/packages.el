(defvar env0der-packages
  '(ace-jump-buffer
    helm-projectile
    evil
    evil-matchit
    color-identifiers-mode
    projectile
    cider
    tabbar
    tabbar-ruler
    company
    ruby-mode
    cperl-mode
    mo-git-blame
    js2-mode
    bm
    helm
    helm-bm
    web-mode
    ctags-update
    browse-at-remote
    osx-clipboard
    avy
    scratch
    inf-ruby
    rspec-mode
    robe
    ruby-refactor
    ruby-hash-syntax
    git-commit
    highlight-symbol
    evil-cleverparens
    evil-textobj-anyblock
    eyebrowse
    popwin
    vi-tilde-fringe
    linum-relative
    magit))

(defvar env0der-excluded-packages '()
  "List of packages to exclude.")

(defun env0der/init-ace-jump-buffer ()
  (use-package ace-jump-buffer
    :config
    (progn
      (define-key key-translation-map [f9] (kbd "s-b"))
      (global-set-key (kbd "s-b") 'ace-jump-buffer))))

(defun env0der/post-init-helm-projectile ()
  (use-package helm-projectile
    :config
    (progn
      (define-key key-translation-map [f11] (kbd "s-o"))
      (global-set-key (kbd "s-o") 'helm-projectile-find-file)
      (evil-leader/set-key "/" 'spacemacs/helm-project-smart-do-search-region-or-symbol))))

(defun env0der/post-init-evil ()
  (use-package evil
    :config
    (progn
      ;;;; Clipboard bypass in evil mode
      (defmacro without-evil-mode (&rest do-this)
        ;; Check if evil-mode is on, and disable it temporarily
        `(let ((evil-mode-is-on (evil-mode?)))
           (if evil-mode-is-on
               (disable-evil-mode))
           (ignore-errors
             ,@do-this)
           (if evil-mode-is-on
               (enable-evil-mode))))

      (defmacro evil-mode? ()
        "Checks if evil-mode is active. Uses Evil's state to check."
        `evil-state)

      (defmacro disable-evil-mode ()
        "Disable evil-mode with visual cues."
        `(progn
           (evil-mode 0)
           (message "Evil mode disabled")))

      (defmacro enable-evil-mode ()
        "Enable evil-mode with visual cues."
        `(progn
           (evil-mode 1)
           (message "Evil mode enabled")))


      ;; delete: text object
      (evil-define-operator evil-destroy (beg end type register yank-handler)
        "Vim's 's' without clipboard."
        (evil-delete beg end type ?_ yank-handler))

      (evil-define-operator evil-destroy-replace (beg end type register yank-handler)
        (evil-destroy beg end type register yank-handler)
        (evil-paste-before 1 register))

      (defadvice evil-paste-after (around env0der/evil-paste-after-and-indent activate)
        "Paste and indent"
        (evil-with-single-undo
          ad-do-it
          (call-interactively 'indent-region)))

      (defadvice evil-paste-before (around env0der/evil-paste-before-and-indent activate)
        "Paste and indent"
        (evil-with-single-undo
          ad-do-it
          (call-interactively 'indent-region)))

      (defun newline-and-indent-interactive ()
        (interactive)
        (newline-and-indent))

      (define-key evil-normal-state-map "r" 'evil-destroy-replace)

      (define-key evil-insert-state-map (kbd "C-j") 'newline-and-indent-interactive)
      (define-key evil-normal-state-map (kbd "C-j") 'newline-and-indent-interactive)
      (define-key evil-normal-state-map (kbd "<RET>") (lambda ()
                                                      (interactive)
                                                      (evil-insert-newline-below)))

      (define-key key-translation-map [f12] (kbd "<S-return>"))
      (define-key evil-normal-state-map [(S-return)] (lambda ()
                                                       (interactive)
                                                       (evil-insert-newline-above))))))

(defun env0der/init-color-identifiers-mode ()
  (use-package color-identifiers-mode
    :init
    (progn
      (global-color-identifiers-mode))))

(defun env0der/post-init-projectile ()
  (use-package projectile
    :config
    (progn
      (setq projectile-project-root-files (cons ".projectile" projectile-project-root-files))

      ;; always use system find command to get project files
      ;; otherwise deleted files will be still shown until they are staged in git
      ;; (defun projectile-get-ext-command ()
      ;;   projectile-generic-command)
      )))

(defun env0der/post-init-cider ()
  (use-package cider
    :config
    (progn
      (defun cider-reset-system ()
        (interactive)
        (spacemacs//cider-eval-in-repl-no-focus "(reset)"))
      (define-key clojure-mode-map (kbd "s-r") 'cider-reset-system))))

(defun env0der/init-tabbar-ruler ()
  (use-package tabbar-ruler
    :init
    (setq tabbar-ruler-global-tabbar t)
    (setq tabbar-ruler-global-ruler nil)
    (setq tabbar-ruler-popup-menu nil)
    (setq tabbar-ruler-popup-toolbar nil)
    (setq tabbar-ruler-popup-scrollbar nil)
    (setq tabbar-ruler-movement-timer-delay 1000000)
    (require 'tabbar-ruler)

    (global-set-key (kbd "M-h") 'tabbar-ruler-backward)
    (global-set-key (kbd "s-{") 'tabbar-ruler-backward)
    (global-set-key (kbd "M-l") 'tabbar-ruler-forward)
    (global-set-key (kbd "s-}") 'tabbar-ruler-forward)
    (global-set-key (kbd "M-w") 'kill-this-buffer)
    (global-set-key (kbd "s-w") 'kill-this-buffer)
    (evil-leader/set-key "bk" 'kill-this-buffer)

    ;; for now just override and hack this function to remove tab with TAGS file from projectile project tabs list
    (defun tabbar-ruler-projectile-tabbar-buffer-groups ()
      (if tabbar-ruler-projectile-tabbar-buffer-group-calc
          (symbol-value 'tabbar-ruler-projectile-tabbar-buffer-group-calc)
        (set (make-local-variable 'tabbar-ruler-projectile-tabbar-buffer-group-calc)

             (cond
              ((or (get-buffer-process (current-buffer)) (memq major-mode '(comint-mode compilation-mode))) '("Term"))
              ((string-equal "*" (substring (buffer-name) 0 1)) '("Misc"))
              ((string-prefix-p "TAGS" (buffer-name)) '("Misc"))
              ((condition-case err
                   (projectile-project-root)
                 (error nil)) (list (projectile-project-name)))
              ((memq major-mode '(emacs-lisp-mode python-mode emacs-lisp-mode c-mode c++-mode makefile-mode lua-mode vala-mode)) '("Coding"))
              ((memq major-mode '(javascript-mode js-mode nxhtml-mode html-mode css-mode)) '("HTML"))
              ((memq major-mode '(org-mode calendar-mode diary-mode)) '("Org"))
              ((memq major-mode '(dired-mode)) '("Dir"))
              (t '("Main"))))
        (symbol-value 'tabbar-ruler-projectile-tabbar-buffer-group-calc)))


    (tabbar-ruler-group-by-projectile-project)

    ;; for some reason this is the only (but ugly) way to force tabbar to use any colors different from the default ones
    (run-with-idle-timer 5 nil (lambda ()
                                 (setq tabbar-background-color "#666666")
                                 (set-face-attribute 'tabbar-selected nil :background "#181818")
                                 (set-face-attribute 'tabbar-selected nil :foreground "white")
                                 (tabbar-install-faces)
                                 (set-face-attribute 'tabbar-default nil :background "#666666")))))

(defun env0der/post-init-web-mode ()
  (use-package web-mode
    :config
    (progn
      ;; don't treat _ as a part of a word
      (modify-syntax-entry ?_ "." web-mode-syntax-table)
      ;; (add-to-list 'web-mode-comment-formats '("ruby" . "#"))
      (setq web-mode-markup-indent-offset 2)
      (setq web-mode-code-indent-offset 2)
      (setq web-mode-css-indent-offset 2)
      (setq web-mode-indent-style 2)
      (sp-local-pair 'web-mode "<%= "  " %>"))))

(defun env0der/post-init-company ()
  (use-package company
    :config
    (progn
      (define-key company-active-map (kbd "TAB") 'company-complete)
      (define-key company-active-map (kbd "<tab>") 'company-complete)
      (define-key company-active-map (kbd "C-w") 'backward-kill-word)
      (define-key company-active-map (kbd "C-m") 'newline-and-indent-interactive)
      )))

(defun env0der/init-ruby-mode ()
  ;; better ruby intendation
  (setq ruby-deep-indent-paren nil)
  (setq enh-ruby-deep-indent-paren nil)
  (setq ruby-align-to-stmt-keywords '(def if unless))

  (defadvice env0der/ruby-indent-line (after unindent-closing-paren activate)
    (let ((column (current-column))
          indent offset)
      (save-excursion
        (back-to-indentation)
        (let ((state (syntax-ppss)))
          (setq offset (- column (current-column)))
          (when (and (eq (char-after) ?\))
                     (not (zerop (car state))))
            (goto-char (cadr state))
            (setq indent (current-indentation)))))
      (when indent
        (indent-line-to indent)
        (when (> offset 0) (forward-char offset)))))

  (when (configuration-layer/layer-usedp 'auto-completion)
    (spacemacs|defvar-company-backends ruby-mode)
    (spacemacs|add-company-hook ruby-mode)

    (defun ruby/post-init-company ()
      (spacemacs|add-company-hook ruby-mode)))

  (evil-define-text-object evil-textobj-outer-ruby-block
    (count &optional beg end type)
    (evil-ruby-block-range beg end type count t))

  (evil-define-text-object evil-textobj-inner-ruby-block
    (count &optional beg end type)
    (evil-ruby-block-range beg end type count nil))

  (defun evil-ruby-block-range (count beg end type &optional inclusive)
    (let ((current-point (point))
          (block-begin (progn (evil-end-of-line) (re-search-backward "def \\|class \\|if \\|do \\|module " nil t)))
          (block-end (progn (evilmi-jump-items) (point))))
      (if inclusive
          (let ((begin (progn (goto-char block-begin) (evil-beginning-of-line) (point)))
                (end (progn (goto-char block-end) (evil-next-line) (evil-beginning-of-line) (if (looking-at "^$") (+ (point) 1) (point)))))
            (progn
              (goto-char current-point)
              (evil-range begin end)))
        (let ((begin (progn (goto-char block-begin) (evil-next-line) (evil-first-non-blank) (point)))
              (end (progn (goto-char block-end) (evil-previous-line) (evil-end-of-line) (+ (point) 1))))
          (progn
            (goto-char current-point)
            (evil-range begin end))))))

  ;; (defun evil-textobj-anyblock--sort-blocks--with-ruby-blocks (orig-fn &rest args)
  ;;   (if (derived-mode-p 'ruby-mode)
  ;;       (let* ((block (apply 'evil-ruby-block-range args))
  ;;              (blocks (cons block (apply orig-fn args)))
  ;;              (sorted-blocks (sort blocks
  ;;                                   (lambda (x y) (< (- (cl-second x) (cl-first x))
  ;;                                                    (- (cl-second y) (cl-first y)))))))
  ;;         sorted-blocks)
  ;;     (apply orig-fn args)))

  ;; (advice-add 'evil-textobj-anyblock--sort-blocks :around #'evil-textobj-anyblock--sort-blocks--with-ruby-blocks)

  (define-key evil-inner-text-objects-map "B" 'evil-textobj-inner-ruby-block)
  (define-key evil-outer-text-objects-map "B" 'evil-textobj-outer-ruby-block))

(defun env0der/init-cperl-mode ()
  (defalias 'perl-mode 'cperl-mode)
  (setq cperl-indent-level 4
        cperl-close-paren-offset -4
        cperl-continued-statement-offset 4
        cperl-indent-parens-as-block t
        cperl-tab-always-indent t)

  (when (configuration-layer/layer-usedp 'auto-completion)
    (spacemacs|defvar-company-backends cperl-mode)
    (spacemacs|add-company-hook cperl-mode)

    (defun cperl/post-init-company ()
      (spacemacs|add-company-hook cperl-mode))))

(defun env0der/init-mo-git-blame ()
  (use-package mo-git-blame
    :init
    (progn
      (evil-leader/set-key "gb" 'mo-git-blame-current))
    :config
    (progn
      (dolist (state '(normal visual insert))
        (evil-define-key state mo-git-blame-mode-map (kbd "q") 'mo-git-blame-quit)))))

(defun env0der/init-js2-mode ()
  (use-package js2-mode
    :init
    (progn
      (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
      (add-to-list 'auto-mode-alist '("\\.json\\'" . js2-mode)))
    :config
    (progn
      (add-hook 'js2-init-hook (lambda ()
                                 (setq js2-basic-offset 2)))
      (js2-mode-hide-warnings-and-errors))))

(defun env0der/init-bm ()
  (use-package bm
    :init
    (progn
      (setq bm-restore-repository-on-load t))
    :config
    (progn
      (setq bm-cycle-all-buffers t)
      (setq bm-marker 'bm-marker-left)
      (setq bm-highlight-style 'bm-highlight-only-line)
      (setq-default bm-buffer-persistence t)
      (define-key evil-normal-state-map (kbd "gbb") 'bm-toggle)
      (define-key evil-normal-state-map (kbd "gbn") 'bm-next)
      (define-key evil-normal-state-map (kbd "gbp") 'bm-previous)

      (add-hook' after-init-hook 'bm-repository-load)
      (add-hook 'find-file-hooks 'bm-buffer-restore)
      (add-hook 'kill-buffer-hook 'bm-buffer-save)
      (add-hook 'kill-emacs-hook '(lambda nil
                                    (bm-buffer-save-all)
                                    (bm-repository-save)))
      (add-hook 'after-save-hook 'bm-buffer-save)
      (add-hook 'after-revert-hook 'bm-buffer-restore))))

(defun env0der/init-helm-bm ()
  (use-package helm-bm
    :config
    (progn
      (evil-leader/set-key "hb" 'helm-bm))))

(defun env0der/post-init-evil-matchit ()
  (use-package evil-matchit
    :config
    (progn
      (global-evil-matchit-mode))))

(defun env0der/init-ctags-update ()
  (use-package ctags-update
    :config
    (progn
      (setq ctags-update-delay-seconds 0)
      (setq tags-revert-without-query t)
      (global-auto-revert-mode t)
      (setq auto-revert-verbose nil)
      (add-hook 'after-save-hook 'ctags-update)
      (evil-leader/set-key "pR" 'ctags-update))))

(defun env0der/init-browse-at-remote ()
  (use-package browse-at-remote))

(defun env0der/init-osx-clipboard ()
  (use-package osx-clipboard
    :config
    (progn
      (osx-clipboard-mode +1)
      (diminish 'osx-clipboard-mode))))

(defun env0der/post-init-avy ()
  (use-package avy
    :config
    (progn
      (setq avy-background t)
      (setq avy-keys (number-sequence ?a ?z))
      (define-key evil-normal-state-map (kbd "SPC") 'avy-goto-word-or-subword-1))))

(defun env0der/init-scratch ()
  (use-package scratch))

(defun env0der/init-inf-ruby ()
  (use-package inf-ruby))

(defun env0der/init-rspec-mode ()
  (use-package rspec-mode
    :config
    (progn
      (add-hook 'after-init-hook 'inf-ruby-switch-setup)

      (defadvice rspec-compile (around rspec-compile-around)
        "Use BASH shell for running the specs because of ZSH issues."
        (let ((shell-file-name "/bin/bash"))
          ad-do-it))

      (ad-activate 'rspec-compile))))

(defun env0der/init-robe ()
  (use-package robe
    :config
    (progn
      (add-hook 'ruby-mode-hook 'robe-mode)

      (defun reload-ruby-file-if-robe-running ()
        (when robe-running
          (ruby-load-file (buffer-file-name))))

      (add-hook 'robe-mode-hook (lambda ()
                                  (add-hook 'after-save-hook 'reload-ruby-file-if-robe-running nil 'make-it-local))))))

(defun env0der/init-ruby-refactor ()
  (use-package ruby-refactor
    :init
    (progn
      (add-hook 'ruby-mode-hook 'ruby-refactor-mode-launch)
      (evil-define-key 'visual ruby-mode-map (kbd (concat dotspacemacs-leader-key "re")) 'ruby-refactor-extract-to-method)
      (evil-define-key 'visual ruby-mode-map (kbd (concat dotspacemacs-leader-key "rp")) 'ruby-refactor-add-parameter)
      (evil-define-key 'visual ruby-mode-map (kbd (concat dotspacemacs-leader-key "rl")) 'ruby-refactor-extract-to-let)
      (evil-define-key 'visual ruby-mode-map (kbd (concat dotspacemacs-leader-key "rv")) 'ruby-refactor-extract-local-variable)
      (evil-define-key 'visual ruby-mode-map (kbd (concat dotspacemacs-leader-key "rc")) 'ruby-refactor-extract-constant)
      (evil-define-key 'visual ruby-mode-map (kbd (concat dotspacemacs-leader-key "ro")) 'ruby-refactor-convert-post-conditional)
      (evil-define-key 'normal ruby-mode-map (kbd (concat dotspacemacs-leader-key "rb")) 'ruby-toggle-block)
      (evil-define-key 'visual ruby-mode-map (kbd (concat dotspacemacs-leader-key "rh")) 'ruby-toggle-hash-syntax)
      )))

(defun env0der/init-ruby-hash-syntax ()
  (use-package ruby-hash-syntax))

(defun env0der/post-init-git-commit ()
  (use-package git-commit
    :config
    (progn
      (setq git-commit-finish-query-functions '()))))

(defun env0der/init-highlight-symbol ()
  (use-package highlight-symbol
    :config
    (progn
      (add-hook 'evil-normal-state-entry-hook (lambda ()
                                                (if (derived-mode-p 'prog-mode)
                                                    (progn
                                                      (highlight-symbol-mode 1)
                                                      (define-key evil-normal-state-map (kbd "M-n") 'highlight-symbol-next)
                                                      (define-key evil-normal-state-map (kbd "M-p") 'highlight-symbol-prev)
                                                      (define-key evil-normal-state-map (kbd "M-r") 'highlight-symbol-query-replace))
                                                  (highlight-symbol-mode -1))))
      (add-hook 'evil-normal-state-exit-hook (lambda ()
                                               (if (derived-mode-p 'prog-mode)
                                                   (highlight-symbol-mode -1))))
      (setq highlight-symbol-idle-delay 0.2))))

(defun env0der/post-init-eyebrowse ()
  (use-package eyebrowse
    :config
    (progn
      (global-set-key [C-tab] 'eyebrowse-last-window-config))))

(defun env0der/init-evil-cleverparens ()
  (use-package evil-cleverparens
    :config
    (progn
      (evil-cp-toggle-balanced-yank t)
      (add-hook 'emacs-lisp-mode-hook #'evil-cleverparens-mode)
      (add-hook 'clojure-mode-hook #'evil-cleverparens-mode))))

(defun env0der/init-evil-textobj-anyblock ()
  (use-package evil-textobj-anyblock
    :config
    (progn
      (define-key evil-inner-text-objects-map "b" 'evil-textobj-anyblock-inner-block)
      (define-key evil-outer-text-objects-map "b" 'evil-textobj-anyblock-a-block)

      (add-hook 'ruby-mode-hook (lambda ()
                                  (setq-local evil-textobj-anyblock-blocks '(("(" . ")")
                                                                             ("{" . "}")
                                                                             ("\\[" . "\\]")
                                                                             ("'" . "'")
                                                                             ("\"" . "\"")))))
      (dolist (hook '(emacs-lisp-mode-hook clojure-mode-hook))
        (add-hook hook (lambda ()
                         (setq-local evil-textobj-anyblock-blocks '(("(" . ")")
                                                                    ("{" . "}")
                                                                    ("\\[" . "\\]")
                                                                    ("\"" . "\"")))))))))

(defun env0der/post-init-helm ()
  (use-package helm
    :config
    (progn
      (helm-autoresize-mode 1)
      ;; make helm window always occupy 30% of frame height
      (setq helm-autoresize-min-height 30)
      (setq helm-autoresize-max-height 30))))

(defun env0der/post-init-popwin ()
  (use-package popwin
    :config
    (progn
      ;; helm ag search results always on the bottom, 30% of frame height
      (push '("^\*helm ag.+\*$" :regexp t :height 0.3 :position bottom :stick t) popwin:special-display-config))))

(defun env0der/post-init-vi-tilde-fringe ()
  (use-package vi-tilde-fringe
    :config
    (progn
      (vi-tilde-fringe-mode -1))))

(defun env0der/post-init-linum-relative ()
  (use-package linum-relative
    :config
    (progn
      (spacemacs/toggle-line-numbers)
      (linum-relative-toggle)
      (setq linum-relative-plusp-offset 1)
      (setq linum-relative-format "%3s "))))

(defun env0der/post-init-magit ()
  (use-package magit
    :config
    (progn
      (setq magit-push-always-verify nil))))
