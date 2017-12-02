# sauron-notmuch

Notmuch (https://notmuchmail.org/notmuch-emacs/) adapter for Sauron (https://github.com/djcb/sauron)

## How to install
### use-package (not available on melpa or anything like that yet !)
```elisp
(use-package sauron-notmuch
  :ensure t
  :after sauron
  :after notmuch
  :config

  ;; Define an important filter
  ;; (setq sauron-notmuch-important-filter "....")

  ;; Start
  (sauron-notmuch-start))
```
