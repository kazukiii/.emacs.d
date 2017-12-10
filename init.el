
(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(package-selected-packages (quote (monokai-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))
(put 'upcase-region 'disabled nil)
;; 対応する括弧を強調表示
(setq show-paren-delay 0) ;表示までの秒数が初期値0.125
(show-paren-mode t)
;; 時間も表示
(setq display-time-day-and-date t)
(display-time-mode t)

;; バッテリー残量を表示(なぜかできなかった）
;;(display-battery-mode t)

;; Emacsの初期画面を表示しない
(setq inhibit-startup-screen t)
;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

;; スクロールは1行ごとに
(setq mouse-wheel-scroll-amount '(1 ((shift) . 5)))

;; スクロールの加速をやめる
(setq mouse-wheel-progressive-speed nil)

;; bufferの最後でカーソルを動かそうとしても音をならなくする
(defun next-line (arg)
  (interactive "p")
  (condition-case nil
      (line-move arg)
    (end-of-buffer)))

;; エラー音をならなくする
(setq ring-bell-function 'ignore)

;; auto-complage
;;(el-get-bundle auto-complete)
;;(setq ac-use-menu-map t)       ; 補完メニュー表示時にC-n/C-pで補完候補選択
;;(setq ac-use-fuzzy t)          ; 曖昧マッチ

;; 別のキーバインドにヘルプを割り当てる
(define-key global-map (kbd "C-x ?") 'help-command)
;; monokai
(el-get-bundle elpa:monokai-theme)
(load-theme 'monokai t)
;; tabサイズ
(setq-default tab-width 4)
;; scratchの初期メッセージ消去
(setq initial-scratch-message "")

;; 行末の空白を強調表示->とりあえず見た目的に消しておく
;;(setq-default show-trailing-whitespace t)
;;(set-face-background 'trailing-whitespace "#b14770")

;; タブをスペースで扱う
(setq-default indent-tabs-mode nil)
;; yes or noをy or n
(fset 'yes-or-no-p 'y-or-n-p)
;; モードラインに行番号表示
(line-number-mode t)

;; モードラインに列番号表示
(column-number-mode t)

;; ------------------------------------------------------------------------
;; @ modeline

;; モードラインの割合表示を総行数表示
(defvar my-lines-page-mode t)
(defvar my-mode-line-format)

(when my-lines-page-mode
  (setq my-mode-line-format "%d")
  (if size-indication-mode
      (setq my-mode-line-format (concat my-mode-line-format " of %%I")))
  (cond ((and (eq line-number-mode t) (eq column-number-mode t))
         (setq my-mode-line-format (concat my-mode-line-format " (%%l,%%c)")))
        ((eq line-number-mode t)
         (setq my-mode-line-format (concat my-mode-line-format " L%%l")))
        ((eq column-number-mode t)
         (setq my-mode-line-format (concat my-mode-line-format " C%%c"))))

  (setq mode-line-position
        '(:eval (format my-mode-line-format
                        (count-lines (point-max) (point-min))))))

;; -------------------------------------------------------------------------
;; @ whitespace　全角スペースを強調（赤くなる）

(global-whitespace-mode 1)
(setq whitespace-space-regexp "\\(\u3000\\)")
(setq whitespace-style '(face tabs tab-mark spaces space-mark))
(setq whitespace-display-mappings ())
(set-face-foreground 'whitespace-tab "#F1C40F")
(set-face-background 'whitespace-space "#E74C3C")

;; helm
(el-get-bundle helm)

;; ターミナル以外はツールバー、スクロールバーを非表示
(when window-system
  ;; tool-barを非表示
  (tool-bar-mode 0)
  ;; scroll-barを非表示
  (scroll-bar-mode 0))

;; C-mにnewline-and-indentを割り当てる。
;; 先ほどとは異なりglobal-set-keyを利用
(global-set-key (kbd "C-m") 'newline-and-indent)

;; 折り返しトグルコマンド
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

;; "C-t"でウィンドウを切り替える。初期値はtranspose-chars
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))

(global-set-key (kbd "C-t") 'other-window-or-split)

;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format "%f")

;; 閉じ括弧の自動挿入
(electric-pair-mode t)

;;現在行を上下に連続移動
(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines 1))
    (forward-line)
    (move-to-column col)))

(defun move-line-up () ;最上行での制御も加えられると良い
  (interactive)
  (let ((col (current-column)))
    (forward-line)
    (save-excursion
      (transpose-lines -1))
    (forward-line -2)
    (move-to-column col)))

(global-set-key (kbd "M-N") 'move-line-down)
(global-set-key (kbd "M-P") 'move-line-up)

;; C、C++、JAVA、PHPなどのインデント
(add-hook 'c-mode-common-hook
          '(lambda ()
             (c-set-style "java")))

;; バックアップとオートセーブファイルを~/.emacs.d/backups/へ集める
(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs.d/backups/"))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))

;; ファイルが #! から始まる場合、+xを付けて保存する
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; flycheck
;;(el-get-bundle flycheck)
;;(global-flycheck-mode)

;;(define-key global-map (kbd "\C-cn") 'flycheck-next-error)
;;(define-key global-map (kbd "\C-cp") 'flycheck-previous-error)
;;(define-key global-map (kbd "\C-cd") 'flycheck-list-errors)

;; 自動改行、インデント
;;(setq c-auto-newline t)

;; 空白を一度に削除
(setq c-hungry-delete-key t)

;; ヘッダファイルをC++として認識
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; company-mode
(el-get-bundle company-mode/company-mode)
(global-company-mode) ; 全バッファで有効にする 
(setq company-idle-delay 0) ; デフォルトは0.5
(setq company-minimum-prefix-length 1) ; デフォルトは4
(setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る

;; キー設定
(define-key company-active-map (kbd "M-n") nil)
(define-key company-active-map (kbd "M-p") nil)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "C-h") nil)

(defun company--insert-candidate2 (candidate)
  (when (> (length candidate) 0)
    (setq candidate (substring-no-properties candidate))
    (if (eq (company-call-backend 'ignore-case) 'keep-prefix)
        (insert (company-strip-prefix candidate))
      (if (equal company-prefix candidate)
          (company-select-next)
          (delete-region (- (point) (length company-prefix)) (point))
        (insert candidate))
      )))

(defun company-complete-common2 ()
  (interactive)
  (when (company-manual-begin)
    (if (and (not (cdr company-candidates))
             (equal company-common (car company-candidates)))
        (company-complete-selection)
      (company--insert-candidate2 company-common))))

(define-key company-active-map [tab] 'company-complete-common2)
(define-key company-active-map [backtab] 'company-select-previous) ; おまけ


;; compamy-irony
(el-get-bundle irony-mode)
(el-get-bundle company-irony)

(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
(add-to-list 'company-backends 'company-irony) ; backend追加

;; yasnippet
(el-get-bundle yasnippet)
(yas-global-mode)

;; メニューバーを消す
(menu-bar-mode -1)

;; company-jedi
(el-get-bundle company-jedi)
(el-get-bundle jedi-core)

;;(require 'jedi-core)
(setq jedi:complete-on-dot t)
(setq jedi:use-shortcuts t)
(add-hook 'python-mode-hook 'jedi:setup)
(add-to-list 'company-backends 'company-jedi) ; backendに追加

;; exec-path-from-shell
;;(el-get-bundle exec-path-from-shell)
;;(exec-path-from-shell-initialize)
