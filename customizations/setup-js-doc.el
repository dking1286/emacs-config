(require 'js-doc)

(setq js-doc-mail-address "your email address"
       js-doc-author (format "your name <%s>" js-doc-mail-address)
       js-doc-url "url of your website"
       js-doc-license "license name")

(add-hook 'js2-mode-hook
           #'(lambda ()
               (define-key js2-mode-map "\C-ci" 'js-doc-insert-function-doc)
               (define-key js2-mode-map "@" 'js-doc-insert-tag)))
