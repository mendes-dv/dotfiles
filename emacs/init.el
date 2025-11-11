;;; Commentary:
;; Comprehensive Emacs configuration with:
;; - LSP support for Python, Go, TypeScript, C#, Bash, and Svelte
;; - DAP (Debug Adapter Protocol) with per-project configurations
;; - Org-mode with Org-roam
;; - Dashboard with recent files, projects, and org calendar integration
;; - Catppuccin Mocha theme

;;; Code:

;; ============================================================================
;; Package Management
;; ============================================================================

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; ============================================================================
;; Theme - Catppuccin Mocha
;; ============================================================================

(use-package catppuccin-theme
  :config
  (setq catppuccin-flavor 'mocha)
  (load-theme 'catppuccin :no-confirm))

;; ============================================================================
;; Basic Settings
;; ============================================================================

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)
(column-number-mode)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                eat-mode-hook
                dashboard-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Better defaults
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)

;; Font Configuration
(set-face-attribute 'default nil
                    :font "JetBrainsMono Nerd Font"
                    :height 120)  ; Font size (120 = 12pt)

(set-face-attribute 'fixed-pitch nil
                    :font "JetBrainsMono Nerd Font"
                    :height 120)

(set-face-attribute 'variable-pitch nil
                    :font "JetBrainsMono Nerd Font"
                    :height 120)

;; ============================================================================
;; Evil Mode (Vim Keybindings)
;; ============================================================================

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-d-scroll t)
  (setq evil-undo-system 'undo-redo)
  :config
  (evil-mode 1)
  
  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; ============================================================================
;; Completion and UI Enhancements
;; ============================================================================

(use-package which-key
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy
  :diminish
  :config
  (ivy-mode 1))

(use-package counsel
  :after ivy)

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; ============================================================================
;; General - Leader Key Configuration (SPC)
;; ============================================================================

(use-package general
  :config
  (general-evil-setup t)
  
  ;; Set up leader key on SPC
  (general-create-definer my/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  
  ;; File operations
  (my/leader-keys
    "f" '(:ignore t :which-key "files")
    "ff" '(counsel-find-file :which-key "find file")
    "fr" '(counsel-recentf :which-key "recent files")
    "fs" '(save-buffer :which-key "save file")
    "fS" '(write-file :which-key "save file as")
    "fz" '(fzf :which-key "fzf file search"))
  
  ;; Buffer operations
  (my/leader-keys
    "b" '(:ignore t :which-key "buffers")
    "bb" '(counsel-switch-buffer :which-key "switch buffer")
    "bk" '(kill-current-buffer :which-key "kill buffer")
    "bn" '(next-buffer :which-key "next buffer")
    "bp" '(previous-buffer :which-key "previous buffer")
    "br" '(revert-buffer :which-key "revert buffer"))
  
  ;; Window operations
  (my/leader-keys
    "w" '(:ignore t :which-key "windows")
    "ww" '(hydra-window-resize/body :which-key "window hydra")
    "wa" '(ace-window :which-key "ace window")
    "wv" '(split-window-right :which-key "split vertical")
    "ws" '(split-window-below :which-key "split horizontal")
    "wd" '(delete-window :which-key "delete window")
    "wo" '(delete-other-windows :which-key "delete other windows")
    "w=" '(balance-windows :which-key "balance windows")
    "wm" '(maximize-window :which-key "maximize window")
    "wu" '(winner-undo :which-key "undo layout")
    "wr" '(winner-redo :which-key "redo layout"))
  
  ;; Project operations
  (my/leader-keys
    "p" '(:ignore t :which-key "projects")
    "pp" '(projectile-persp-switch-project :which-key "switch project")
    "pf" '(projectile-find-file :which-key "find file in project")
    "ps" '(projectile-save-project-buffers :which-key "save project")
    "pk" '(projectile-kill-buffers :which-key "kill project buffers")
    "pr" '(projectile-recentf :which-key "recent project files")
    "pa" '(projectile-add-known-project :which-key "add project"))
  
  ;; Workspace operations (Perspective)
  (my/leader-keys
    "x" '(:ignore t :which-key "workspaces")
    "xx" '(hydra-perspective/body :which-key "workspace hydra")
    "xs" '(persp-switch :which-key "switch workspace")
    "xn" '(persp-next :which-key "next workspace")
    "xp" '(persp-prev :which-key "previous workspace")
    "xc" '(persp-switch :which-key "create workspace")
    "xk" '(persp-kill :which-key "kill workspace")
    "xr" '(persp-rename :which-key "rename workspace")
    "xb" '(persp-switch-to-buffer :which-key "switch to buffer")
    "xa" '(persp-add-buffer :which-key "add buffer"))
  
  ;; Code operations (LSP and refactoring)
  (my/leader-keys
    "." '(lsp-execute-code-action :which-key "code action")
    "c" '(:ignore t :which-key "code")
    "cf" '(lsp-format-buffer :which-key "format")
    "cd" '(lsp-find-definition :which-key "definition")
    "cD" '(lsp-find-references :which-key "references")
    "ci" '(lsp-find-implementation :which-key "implementation")
    "ct" '(lsp-find-type-definition :which-key "type definition")
    "cs" '(lsp-ivy-workspace-symbol :which-key "workspace symbol")
    "cr" '(:ignore t :which-key "refactor")
    "crn" '(lsp-rename :which-key "rename"))
  
  ;; Debug operations
  (my/leader-keys
    "d" '(:ignore t :which-key "debug")
    "dd" '(dap-debug :which-key "start debug")
    "dl" '(dap-debug-last :which-key "debug last")
    "dr" '(dap-debug-recent :which-key "debug recent")
    "db" '(dap-breakpoint-toggle :which-key "toggle breakpoint")
    "dB" '(dap-breakpoint-delete-all :which-key "delete all breakpoints")
    "dn" '(dap-next :which-key "next")
    "di" '(dap-step-in :which-key "step in")
    "do" '(dap-step-out :which-key "step out")
    "dc" '(dap-continue :which-key "continue")
    "dq" '(dap-disconnect :which-key "quit debug")
    "de" '(dap-eval :which-key "eval expression")
    "du" '(dap-ui-repl :which-key "repl"))
  
  ;; Org mode operations
  (my/leader-keys
    "o" '(:ignore t :which-key "org")
    "oa" '(org-agenda :which-key "agenda")
    "oc" '(org-capture :which-key "capture")
    "ol" '(org-store-link :which-key "store link")
    "oi" '(org-insert-link :which-key "insert link")
    "ot" '(org-todo :which-key "todo")
    "op" '(org-pomodoro :which-key "pomodoro"))
  
  ;; Org Roam operations (moved under org prefix)
  (my/leader-keys
    "or" '(:ignore t :which-key "roam")
    "orf" '(org-roam-node-find :which-key "find node")
    "ori" '(org-roam-node-insert :which-key "insert node")
    "orc" '(org-roam-capture :which-key "capture")
    "org" '(org-roam-graph :which-key "graph")
    "orb" '(org-roam-buffer-toggle :which-key "toggle buffer")
    "orj" '(org-roam-dailies-capture-today :which-key "daily note"))
  
  ;; Git operations
  (my/leader-keys
    "g" '(:ignore t :which-key "git")
    "gg" '(magit-status :which-key "magit status")
    "gs" '(magit-status :which-key "status")
    "gc" '(magit-commit :which-key "commit")
    "gp" '(magit-push :which-key "push")
    "gP" '(magit-pull :which-key "pull")
    "gb" '(magit-branch :which-key "branch")
    "gf" '(magit-fetch :which-key "fetch"))
  
  ;; Search operations - updated
  (my/leader-keys
    "s" '(:ignore t :which-key "search")
    "sw" '(lsp-find-references :which-key "search references (word)")
    "sg" '(counsel-projectile-rg :which-key "project grep")
    "ss" '(counsel-grep-or-swiper :which-key "search buffer")
    "sp" '(counsel-projectile-rg :which-key "search project")
    "sf" '(counsel-fzf :which-key "fzf"))
  
  ;; Avy (jump) operations - new
  (my/leader-keys
    "j" '(:ignore t :which-key "jump")
    "jc" '(avy-goto-char :which-key "goto char")
    "jw" '(avy-goto-word-1 :which-key "goto word")
    "jl" '(avy-goto-line :which-key "goto line"))
  
  ;; Navigate errors - new
  (my/leader-keys
    "n" '(:ignore t :which-key "navigate")
    "ne" '(flycheck-next-error :which-key "next error")
    "np" '(flycheck-previous-error :which-key "previous error")
    "nl" '(flycheck-list-errors :which-key "list errors"))
  
  ;; Toggle operations - updated with terminal
  (my/leader-keys
    "t" '(:ignore t :which-key "toggle")
    "tt" '(my/eat-toggle :which-key "terminal popup")
    "tT" '(my/eat-project :which-key "terminal buffer")
    "te" '(treemacs :which-key "treemacs")
    "tl" '(display-line-numbers-mode :which-key "line numbers")
    "tr" '(read-only-mode :which-key "read only")
    "tb" '(beacon-mode :which-key "beacon"))
  
  ;; Help/Dashboard
  (my/leader-keys
    "h" '(:ignore t :which-key "help")
    "hh" '(my/open-dashboard :which-key "dashboard")
    "hv" '(counsel-describe-variable :which-key "describe variable")
    "hf" '(counsel-describe-function :which-key "describe function")
    "hk" '(describe-key :which-key "describe key"))
  
  ;; Quit operations
  (my/leader-keys
    "q" '(:ignore t :which-key "quit")
    "qq" '(save-buffers-kill-terminal :which-key "quit emacs")
    "qr" '(restart-emacs :which-key "restart emacs")))

;; C-w hjkl for window navigation
(define-key evil-normal-state-map (kbd "C-w h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-w j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "C-w k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-w l") 'evil-window-right)

;; Vim-style LSP navigation keybindings (require LSP mode to be loaded)
(with-eval-after-load 'lsp-mode
  (define-key evil-normal-state-map (kbd "g d") 'lsp-find-definition)
  (define-key evil-normal-state-map (kbd "g i") 'lsp-find-implementation)
  (define-key evil-normal-state-map (kbd "g r") 'lsp-find-references))

;; Robust Treemacs toggle wrapper and bindings
(defun my/toggle-treemacs ()
  "Load treemacs if needed and toggle it.
If treemacs is not installed, present a helpful error."
  (interactive)
  ;; Try to load treemacs quietly
  (unless (or (featurep 'treemacs) (require 'treemacs nil t))
    (user-error "treemacs is not installed. Install with: M-x package-install RET treemacs RET"))
  ;; Prefer toggle if available, otherwise call treemacs
  (cond
   ((fboundp 'treemacs-toggle) (call-interactively 'treemacs-toggle))
   ((fboundp 'treemacs) (call-interactively 'treemacs))
   (t (user-error "treemacs loaded but no toggle command found"))))

;; Global binding (works in GUI and terminal)
(global-set-key (kbd "C-e") #'my/toggle-treemacs)

;; Also ensure Evil normal state uses it (if you use Evil)
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd "C-e") #'my/toggle-treemacs))

;; ============================================================================
;; Project Management
;; ============================================================================

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :init
  (when (file-directory-p "~/projects")
    (setq projectile-project-search-path '("~/projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-enable-snippet t)
  (setq lsp-enable-file-watchers t)
  (setq lsp-file-watch-threshold 5000))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-show-with-cursor t)
  (lsp-ui-doc-show-with-mouse t)
  (lsp-ui-sideline-show-diagnostics t))

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package flycheck
  :hook (lsp-mode . flycheck-mode)
  :config
  ;; Show error list at bottom of screen
  (setq flycheck-display-errors-delay 0.3)
  (setq flycheck-indication-mode 'left-fringe))

;; ============================================================================
;; Language-Specific LSP Configuration
;; ============================================================================

;; Python
(use-package python-mode
  :mode "\\.py\\'"
  :hook (python-mode . lsp-deferred)
  :custom
  (python-shell-interpreter "python3"))

;; Go
(use-package go-mode
  :mode "\\.go\\'"
  :hook (go-mode . lsp-deferred)
  :config
  (add-hook 'before-save-hook 'gofmt-before-save))

;; TypeScript
(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

;; C#
(use-package csharp-mode
  :mode "\\.cs\\'"
  :hook (csharp-mode . lsp-deferred))

;; Bash/Shell
(use-package sh-mode
  :ensure nil
  :mode ("\\.sh\\'" "\\.bash\\'")
  :hook (sh-mode . lsp-deferred))

;; Svelte
(use-package svelte-mode
  :mode "\\.svelte\\'"
  :hook (svelte-mode . lsp-deferred)
  :config
  (setq svelte-basic-offset 2))

;; ============================================================================
;; DAP (Debug Adapter Protocol)
;; ============================================================================


(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)
(use-package dap-mode
  :after lsp-mode
  :commands dap-debug
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (tooltip-mode 1)
  (dap-ui-controls-mode 1)
  
  ;; Enable debuggers
  (require 'dap-python)
  (require 'dap-go)
  (require 'dap-node)
  (require 'dap-chrome)
  
  ;; Python debugger configurations
  (dap-register-debug-template "Python :: Run with uv"
                               (list :type "python"
                                     :args ""
                                     :cwd nil
                                     :program nil
                                     :request "launch"
                                     :name "Python :: Run with uv"
                                     :debugOptions '("WaitOnAbnormalExit" "WaitOnNormalExit")
                                     :pythonPath "uv run python"))
  
  (dap-register-debug-template "Python :: Run with script"
                               (list :type "python"
                                     :args ""
                                     :cwd nil
                                     :program nil
                                     :request "launch"
                                     :name "Python :: Run with script"
                                     :debugOptions '("WaitOnAbnormalExit" "WaitOnNormalExit")
                                     :pythonPath "./scripts/debug.sh"))
  
  ;; Go debugger configuration
  (dap-register-debug-template "Go :: Run Configuration"
                               (list :type "go"
                                     :request "launch"
                                     :name "Go :: Run Configuration"
                                     :mode "auto"
                                     :program nil))
  
  ;; TypeScript/Node debugger configuration
  (dap-register-debug-template "Node :: Run Configuration"
                               (list :type "node"
                                     :request "launch"
                                     :name "Node :: Run Configuration"
                                     :program nil))
  
  ;; C# debugger configuration
  (dap-register-debug-template "C# :: Run Configuration"
                               (list :type "coreclr"
                                     :request "launch"
                                     :name "C# :: Run Configuration"
                                     :program nil))
  
  :bind
  (:map dap-mode-map
        ("C-c d d" . dap-debug)
        ("C-c d l" . dap-debug-last)
        ("C-c d r" . dap-debug-recent)
        ("C-c d b" . dap-breakpoint-toggle)
        ("C-c d n" . dap-next)
        ("C-c d i" . dap-step-in)
        ("C-c d o" . dap-step-out)
        ("C-c d c" . dap-continue)
        ("C-c d q" . dap-disconnect)))

;; Project-specific debug configurations
;; Create a .dir-locals.el file in your project root

;; ============================================================================
;; Org Mode & Org Roam
;; ============================================================================

(use-package org
  :config
  (setq org-directory "~/org")
  (setq org-agenda-files '("~/org"))
  (setq org-default-notes-file (concat org-directory "/notes.org"))
  (setq org-log-done 'time)
  (setq org-startup-indented t)
  (setq org-hide-emphasis-markers t))

(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/org/roam"))
  (org-roam-completion-everywhere t)
  :config
  (org-roam-db-autosync-mode)
  ;; Create directories if they don't exist
  (unless (file-directory-p org-roam-directory)
    (make-directory org-roam-directory t)))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

;; ============================================================================
;; Dashboard
;; ============================================================================

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  
  (setq dashboard-banner-logo-title "Welcome to Emacs")
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t)
  (setq dashboard-show-shortcuts nil)
  (setq dashboard-items '((recents  . 10)
                          (projects . 10)
                          (agenda . 5)))
  
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  
  ;; Custom footer with org calendar shortcut
  (setq dashboard-footer-messages 
        '("Press 'o' for Org Agenda Calendar | 'r' for Recent Files | 'p' for Projects"))
  (setq dashboard-footer-icon "")
  
  ;; Ensure dashboard buffer is shown on startup instead of scratch
  (setq initial-buffer-choice (lambda ()
                                 (get-buffer-create "*dashboard*")
                                 (dashboard-insert-startupify-lists)
                                 (get-buffer "*dashboard*")))
  
  :bind
  (:map dashboard-mode-map
        ("o" . (lambda () (interactive) (org-agenda nil "a")))
        ("r" . counsel-recentf)
        ("p" . projectile-switch-project)))

;; Icons for dashboard
(use-package all-the-icons
  :if (display-graphic-p))

;; ============================================================================
;; Hydra - Window Management
;; ============================================================================

(use-package hydra)

(defhydra hydra-window-resize (:color red :hint nil)
  "
^Resize^           ^Move^           ^Split^         ^Other^
^^^^^^^^---------------------------------------------------------
_h_: ← shrink      _H_: ← move      _v_: vertical   _d_: delete
_j_: ↓ enlarge     _J_: ↓ move      _s_: horizontal _o_: delete others
_k_: ↑ shrink      _K_: ↑ move      _=_: balance    _u_: undo layout
_l_: → enlarge     _L_: → move      _m_: maximize   _r_: redo layout
"
  ;; Resize
  ("h" shrink-window-horizontally)
  ("j" enlarge-window)
  ("k" shrink-window)
  ("l" enlarge-window-horizontally)
  
  ;; Move between windows
  ("H" evil-window-left)
  ("J" evil-window-down)
  ("K" evil-window-up)
  ("L" evil-window-right)
  
  ;; Split
  ("v" split-window-right)
  ("s" split-window-below)
  ("=" balance-windows)
  ("m" maximize-window)
  
  ;; Other
  ("d" delete-window)
  ("o" delete-other-windows)
  ("u" winner-undo)
  ("r" winner-redo)
  
  ("q" nil "quit" :color blue))

(global-set-key (kbd "C-c w") 'hydra-window-resize/body)

;; Winner mode for window layout undo/redo (built-in)
(winner-mode 1)

;; ============================================================================
;; Workspaces - Perspective
;; ============================================================================

(use-package perspective
  :custom
  (persp-mode-prefix-key (kbd "C-c x"))
  :init
  (persp-mode)
  :config
  ;; Running `persp-mode` multiple times resets the perspective list
  (unless (equal persp-mode t)
    (persp-mode)))

(defhydra hydra-perspective (:color blue :hint nil)
  "
^Navigate^         ^Manage^           ^Buffer^
^^^^^^^^---------------------------------------------------------
_n_: next          _c_: create        _b_: switch buffer
_p_: prev          _k_: kill          _a_: add buffer
_s_: switch        _r_: rename        _A_: set buffer
_i_: import        _S_: save          _i_: isolate buffers
"
  ("n" persp-next)
  ("p" persp-prev)
  ("s" persp-switch)
  ("c" persp-switch)
  ("k" persp-kill)
  ("r" persp-rename)
  ("i" persp-import)
  ("S" persp-state-save)
  ("b" persp-switch-to-buffer)
  ("a" persp-add-buffer)
  ("A" persp-set-buffer)
  ("i" persp-isolate-buffers)
  ("q" nil "quit"))

;; Integration with projectile
(use-package persp-projectile
  :after (perspective projectile))

;; ============================================================================
;; Terminal - Eat (Emulate A Terminal)
;; ============================================================================

(use-package eat
  :custom
  (eat-term-name "xterm-256color")
  (eat-kill-buffer-on-exit t)
  :config
  ;; Set eat to start in insert mode and add window navigation keybindings
  ;; Available keybindings in eat terminal:
  ;;   - Esc: Switch to normal mode (standard evil behavior)
  ;;   - C-w h/j/k/l: Navigate to left/down/up/right window
  ;;   - C-w followed by any window command (v, s, d, etc.)
  (with-eval-after-load 'evil
    ;; Start in insert state so we can use Esc to go to normal mode
    (evil-set-initial-state 'eat-mode 'insert)
    
    ;; Allow C-w window navigation in eat insert state
    (evil-define-key 'insert eat-mode-map
      (kbd "C-w") 'evil-window-map)))

;; Custom functions for eat terminal
(defun my/eat-toggle ()
  "Toggle a popup terminal at the bottom using eat."
  (interactive)
  (let* ((buffer-name "*eat-popup*")
         (buffer (get-buffer buffer-name)))
    (if (and buffer (get-buffer-window buffer))
        ;; If terminal is visible, hide it
        (delete-window (get-buffer-window buffer))
      ;; Otherwise, show or create it
      (let ((window (split-window-below -15)))
        (select-window window)
        (if buffer
            (switch-to-buffer buffer)
          (eat)
          (rename-buffer buffer-name)
          ;; Add cleanup hook when buffer is killed
          (add-hook 'kill-buffer-hook 'my/eat-popup-cleanup nil t))
        ;; Mark this as a popup window so it doesn't interfere with other windows
        (set-window-parameter window 'no-other-window t)
        (set-window-parameter window 'no-delete-other-windows t)))))

(defun my/eat-popup-cleanup ()
  "Clean up the eat popup window when the buffer is killed."
  (when (string= (buffer-name) "*eat-popup*")
    (let ((window (get-buffer-window (current-buffer))))
      (when window
        (ignore-errors (delete-window window))))))

(defun my/eat-project ()
  "Open eat terminal in a buffer for the current project."
  (interactive)
  (let* ((project-name (if (projectile-project-p)
                           (projectile-project-name)
                         "default"))
         (buffer-name (format "*eat-%s*" project-name))
         (default-directory (if (projectile-project-p)
                                (projectile-project-root)
                              default-directory)))
    (if (get-buffer buffer-name)
        (switch-to-buffer buffer-name)
      (eat)
      (rename-buffer buffer-name))))

;; ============================================================================
;; Cool Additions
;; ============================================================================

;; Modern modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 20)
  (doom-modeline-bar-width 3))

;; Instantly highlight symbol at point everywhere
(use-package highlight-symbol
  :hook (prog-mode . highlight-symbol-mode)
  :custom
  (highlight-symbol-idle-delay 0.3)
  (highlight-symbol-highlight-single-occurrence nil))

;; Pulses the cursor location after big movements
(use-package beacon
  :init (beacon-mode 1)
  :custom
  (beacon-color "#f5c2e7"))  ;; Catppuccin Mocha pink

;; Quickly switch windows
(use-package ace-window
  :bind ("M-o" . ace-window)
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; Fuzzy finder using fzf (requires fzf installed)
(use-package fzf
  :commands fzf
  :bind ("C-c z" . fzf))

;; Jump to visible text by char using avy
(use-package avy
  :bind (("C-:" . avy-goto-char)
         ("C-'" . avy-goto-char-2)
         ("M-g f" . avy-goto-line)
         ("M-g w" . avy-goto-word-1)))

;; Org visual tweaks
(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :custom
  (org-modern-star '("◉" "○" "✸" "✿" "✤" "✜" "◆" "▶"))
  (org-modern-table-vertical 1)
  (org-modern-table-horizontal 0.2))

(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autolinks t)
  (org-appear-autosubmarkers t)
  (org-appear-autoentities t))

(use-package org-pomodoro
  :after org
  :custom
  (org-pomodoro-length 25)
  (org-pomodoro-short-break-length 5)
  (org-pomodoro-long-break-length 15))

;; Tree-sitter (built-in in Emacs 29+)
;; Enable tree-sitter modes for supported languages
(setq treesit-language-source-alist
      '((python "https://github.com/tree-sitter/tree-sitter-python")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (go "https://github.com/tree-sitter/tree-sitter-go")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (bash "https://github.com/tree-sitter/tree-sitter-bash")))

;; Auto-remap to tree-sitter modes when available
(when (treesit-available-p)
  (setq major-mode-remap-alist
        '((python-mode . python-ts-mode)
          (typescript-mode . typescript-ts-mode)
          (javascript-mode . js-ts-mode)
          (bash-mode . bash-ts-mode)
          (c-mode . c-ts-mode)
          (c++-mode . c++-ts-mode)
          (go-mode . go-ts-mode))))

;; Smart parenthesis handling in code
(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :config
  (require 'smartparens-config)
  (sp-local-pair 'emacs-lisp-mode "`" nil :when '(sp-in-string-p)))

;; LSP Treemacs integration (code structure, errors, symbols)
(use-package treemacs
  :after evil
  :config
  (evil-set-initial-state 'treemacs-mode 'emacs)
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t))

(use-package lsp-treemacs
  :after (lsp treemacs)
  :commands lsp-treemacs-errors-list
  :config
  (lsp-treemacs-sync-mode 1))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)


(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

;; ============================================================================
;; Additional Useful Packages
;; ============================================================================

(use-package magit
  :commands magit-status
  :bind ("C-x g" . magit-status))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


;; ============================================================================
;; Custom Functions
;; ============================================================================

(defun my/open-dashboard ()
  "Open or refresh the Emacs dashboard.
Requires the `dashboard' package; if it's not installed or fails to load,
a friendly error message is shown."
  (interactive)
  ;; Try to load dashboard, but don't throw an error if it's missing
  (if (require 'dashboard nil t)
      ;; dashboard loaded successfully
      (if (fboundp 'dashboard-refresh-buffer)
          (dashboard-refresh-buffer)
        ;; fallback if API changed
        (if (get-buffer "*dashboard*")
            (switch-to-buffer "*dashboard*")
          (user-error "Dashboard package loaded but no dashboard-refresh-buffer function found")))
    ;; require failed
    (user-error "Package 'dashboard' is not installed. Install it with M-x package-install RET dashboard RET")))

;; ============================================================================
;; Final Setup
;; ============================================================================

;; Set default directory
(setq default-directory "~/")

;; Make sure org directories exist
(unless (file-directory-p "~/org")
  (make-directory "~/org" t))

(provide 'init)
;;; init.el ends here
