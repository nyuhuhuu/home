(eval-when-compile (require 'cl))

(defvar emacs-root "/home/gabor/")
(defvar emacs-mode-directory (concat emacs-root "dev/elisp/"))

(add-to-list 'load-path emacs-mode-directory)
(add-to-list 'load-path (concat emacs-mode-directory "yasnippet/"))
(add-to-list 'load-path "/usr/share/emacs/site-lisp/") ;; git is here

;;;============================================================
;;; Emacs Starter Kit
;;;============================================================

(load (concat emacs-mode-directory "emacs-starter-kit/init.el"))

;;;============================================================
;;; Twitter
;;;============================================================

(require 'twit)
(add-hook 'twit-new-tweet-hook
          (lambda ()
            (let* ((user (cadr twit-last-tweet))
                   (msg (caddr twit-last-tweet))
                   (cmd "/usr/bin/notify-send")
                   (args (format "-i twitter \"%s:\" \"%s\"" user msg)))
              (if (or (string= twit-user user) (not user))
                  ()
                (call-process-shell-command cmd nil t nil args)))))

;;;============================================================
;;; Snippets
;;;============================================================

(require 'yasnippet)
(yas/initialize)
(yas/load-directory (concat emacs-mode-directory "yasnippet/snippets/"))
                                        ; factory defaults
(yas/load-directory (concat emacs-mode-directory "snippets/"))
                                        ; custom templates

;;;============================================================
;;; LISP
;;;============================================================

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (slink/highlight-long-lines)
            (eldoc-mode t)
            (local-set-key (kbd "<backtab>") 'lisp-complete-symbol)))

;;;============================================================
;;; PHP
;;;============================================================

(require 'php-mode)
(add-to-list 'auto-mode-alist
             '("\\.\\(module\\|install\\|engine\\|theme\\)\\'" . php-mode))

;;;============================================================
;;; VC, Git
;;;============================================================

(require 'git)
(require 'vc-git "/home/gabor/src/emacs/lisp/vc-git.el")
(require 'psvn)

;;;============================================================
;;; JavaScript
;;;============================================================

(require 'js2-mode)

;;;============================================================
;;; slink
;;;============================================================

(require 'slink)

;;;============================================================
;;; Work
;;;============================================================

(load (concat emacs-root ".emacs-webma"))

;;;============================================================
;;; Frames, colors, misc.
;;;============================================================

(color-theme-zenburn)

(setq default-frame-alist
      (append
       '((font . "Monaco-10")
         (width . 82) (height . 36)
         (cursor-color . "#ffa200")
         (cursor-type . bar)
         (tool-bar-lines . 0))
       default-frame-alist))

(setq backup-directory-alist (list
                              (cons ".*" (expand-file-name "~/bkp/emacs/")))
      truncate-partial-width-windows nil ;; don't lose word wrapping if split
      ;; windows
      frame-title-format "Emacs - %b %*"
      delete-auto-save-files t
      inhibit-splash-screen t
      custom-file "~/.emacs-custom.el")
(load custom-file 'noerror)

(mouse-avoidance-mode 'cat-and-mouse)

(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;;============================================================
;;; Global key bindings
;;;============================================================

;; Follow recent tweets
(global-set-key [f2] (lambda ()
                       (interactive)
                       (if (bufferp (get-buffer "*Twit-recent*"))
                           (pop-to-buffer "*Twit-recent*")
                         (twit-follow-recent-tweets))))

;; Toggle fullscreen mode
(global-set-key [f11] (lambda ()
                        (interactive)
                        (set-frame-parameter nil 'fullscreen
                                             (if (frame-parameter nil 'fullscreen)
                                                 nil
                                               'fullboth))))

;; Original Emacs binding -- Starter Kit rebinds it
(global-set-key (kbd "C-x h") 'mark-whole-buffer)

;; TAB          yas/expand
;; Shift-TAB    dynamic expandation
;; Super-TAB    indentation
(global-set-key [(super tab)] 'indent-region)
(global-set-key [backtab] 'dabbrev-expand)

;; Others
(global-set-key "\r" 'reindent-then-newline-and-indent)

(provide '.emacs)

;;; .emacs ends here
