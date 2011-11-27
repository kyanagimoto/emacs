;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; elispとconfディレクトリをサブディレクトリごとload-pathに追加
(add-to-load-path "elisp" "conf")

;;donot show start-up message
(setq inhibit-startup-screen t)

;; (install-elisp "http://www.emacswiki.org/emacs/download/auto-install.el")
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))

;;; auto-install
;; redo+: Emacsにredoコマンドを与える
;; (install-elisp "http://www.emacswiki.org/emacs/download/redo+.el")
(when (require 'redo+ nil t)
  (define-key global-map (kbd "C-'") 'redo)) ; C-' に redo を割り当てる

;;;anything
;;(auto-install-batch "anything")
(when (require 'anything nil t)
  (setq
   ;; 候補を表示するまでの時間。デフォルトは0.5
   anything-idle-delay 0.3
   ;; タイプして再描写するまでの時間。デフォルトは0.1
   anything-input-idle-delay 0.2
   ;; 候補の最大表示数。デフォルトは50
   anything-candidate-number-limit 100
   ;; 候補が多いときに体感速度を早くする
   anything-quick-update t
   ;; 候補選択ショートカットをアルファベットに
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
    ;; root権限でアクションを実行するときのコマンド
    ;; デフォルトは"su"
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)
  (and (equal current-language-environment "Japanese")
       (executable-find "cmigemo")
       (require 'anything-migemo nil t))
  (when (require 'anything-complete nil t)
    ;; M-xによる補完をAnythingで行なう
    ;; (anything-read-string-mode 1)
    ;; lispシンボルの補完候補の再検索時間
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
    ;; describe-bindingsをAnythingに置き換える
    (descbinds-anything-install))

  (require 'anything-grep nil t))

;;;js-mode用のhookを用意
(defun js-mode-hooks ()
  ;;キーマップをセット
  (setq flymake-jsl-mode-map 'js-mode-map)
  ;;flymake-jslを起動するための設定
  (when (require 'flymake-jsl nil t)
  (setq flymake-check-was-interrupted t)
  (flymake-mode t)))
;;js-mode起動時にhookを追加
(add-hook 'js-mode-hook 'js-mode-hooks)

;;;grep-edit:grep
;;(install-elisp "http://www.emacswiki.org/emacs/download/grep-edit.el"
(require 'grep-edit)

;;;undohist
;;(install-elisp "http://cx4a.org/pub/undolist.el")
(when (require 'undohist nil t)
  (undohist-initialize))

;;;undotree
;;(install-elisp "http://www.dr-qudit.orgundo-tree/undo-tree.el")
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

;;;point-undo
;;(install-elisp "http://www.emacswiki.org/cgi-bin/wiki/download/point-undo.el")
(when (require 'point-undo nil t)
  (define-key global-map [f5] 'point-undo)
  (define-key global-map [f6] 'point-redo))

;;;wdired
(require 'wdired)
(define-key dired-mode-map "r"
  'wdired-change-to-wdired-mode)

;;;行番号を表示
(global-linum-mode)

;;;インデント設定
(setq js-indent-level 2)
(setq-default indent-tabs-mode nil)

;;;colortheme
(when(require 'color-theme nil t)
  (color-theme-initialize)
  (color-theme-arjen))

;;;js2-mode setting
(autoload 'js2-mode "js2-20090723b" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
