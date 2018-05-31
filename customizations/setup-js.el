;; javascript / html
(add-to-list 'auto-mode-alist '("\\.js$" . js-mode))
(add-hook 'js-mode-hook 'subword-mode)
(add-hook 'js-mode-hook 'enable-electric-pair-mode)
(add-hook 'html-mode-hook 'subword-mode)
(setq js-indent-level 2)

(defun enable-electric-pair-mode ()
  (electric-pair-mode 1)
  (electric-indent-mode 1))

;; Fix indentation in js-mode
(require 'cl)

(eval-after-load "js" '(defun js--proper-indentation (parse-status)
 "Return the proper indentation for the current line."
 (save-excursion
   (back-to-indentation)
   (cond ((nth 4 parse-status)
          (js--get-c-offset 'c (nth 8 parse-status)))
         ((nth 8 parse-status) 0) ; inside string
         ((js--ctrl-statement-indentation))
         ((eq (char-after) ?#) 0)
         ((save-excursion (js--beginning-of-macro)) 4)
         ((nth 1 parse-status)
       ;; A single closing paren/bracket should be indented at the
       ;; same level as the opening statement. Same goes for
       ;; "case" and "default".
          (let ((same-indent-p (looking-at
                                "[]})]\\|\\_<case\\_>\\|\\_<default\\_>"))
                (continued-expr-p (js--continued-expression-p)))
            (goto-char (nth 1 parse-status)) ; go to the opening char
            (if (looking-at "[({[]\\s-*\\(/[/*]\\|$\\)")
                (progn ; nothing following the opening paren/bracket
                  (skip-syntax-backward " ")
                  (when (eq (char-before) ?\)) (backward-list))
                  (back-to-indentation)
                  (cond (same-indent-p
                         (current-column))
                        (continued-expr-p
                         (+ (current-column) (* 2 js-indent-level)
                            js-expr-indent-offset))
                        (t
                         (+ (current-column) js-indent-level
                            (case (char-after (nth 1 parse-status))
                              (?\( js-paren-indent-offset)
                              (?\[ js-square-indent-offset)
                              (?\{ js-curly-indent-offset))))))
              ;; If there is something following the opening
              ;; paren/bracket, everything else should be indented at
              ;; the same level.

      ;; Modified code here:
              (unless same-indent-p
                (move-beginning-of-line 1)
                (forward-char 2))
      ;; End modified code
              (current-column))))

         ((js--continued-expression-p)
          (+ js-indent-level js-expr-indent-offset))
         (t 0))))  )

;; js2-mod
(setq js2-basic-offset 2)
(eval-after-load "sgml-mode"
  '(progn
     (require 'tagedit)
     (tagedit-add-paredit-like-keybindings)
     (add-hook 'html-mode-hook (lambda () (tagedit-mode 1)))))


;; JSX
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(defun my-web-mode-hook ()
  "Hooks for Web mode. Adjust indents"
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2))
(add-hook 'web-mode-hook 'my-web-mode-hook)

;; for better jsx syntax-highlighting in web-mode
;; - courtesy of Patrick @halbtuerke
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
    (let ((web-mode-enable-part-face nil))
      ad-do-it)
    ad-do-it))

;; coffeescript
(add-to-list 'auto-mode-alist '("\\.coffee.erb$" . coffee-mode))
(add-hook 'coffee-mode-hook 'subword-mode)
(add-hook 'coffee-mode-hook 'highlight-indentation-current-column-mode)
(add-hook 'coffee-mode-hook
          (defun coffee-mode-newline-and-indent ()
            (define-key coffee-mode-map "\C-j" 'coffee-newline-and-indent)
            (setq coffee-cleanup-whitespace nil)))
(custom-set-variables
 '(coffee-tab-width 2))

;; JSON

