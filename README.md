# sauron-notmuch

Notmuch (https://notmuchmail.org/notmuch-emacs/) adapter for Sauron (https://github.com/djcb/sauron)

## How to install
### Pre-requisites
For now, it is assuming that you have a function calling the hook. A minimal example would be:

```elisp
  ;; Hook for notmuch
  (defcustom notmuch-index-updated-hook nil
    "Normal hook run when notmuch index has been updated."
    :type 'hook
    :group 'notmuch)

  (defun notmuch-update-index ()
    "Poll and update the index."
    (interactive)
    (notmuch-poll)
    (run-hooks 'notmuch-index-updated-hook))
```

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
