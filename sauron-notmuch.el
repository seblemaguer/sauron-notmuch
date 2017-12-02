;;; sauron-notmuch.el --- Sauron integration of notmuch

;; Copyright (C) 2017  Sébastien Le Maguer

;; Author: Sébastien Le Maguer
;; Keywords: notification, convenience, comm
;; Package-Requires: ((sauron "20160501"))
;; X-URL: https://github.com/seblemaguer/sauron-notmuch
;; URL: https://github.com/seblemaguer/sauron-notmuch
;; Version: 0.1

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

;;; Commentary:

;; Provides notmuch  activity tracking for sauron

;;; Installation:

;; Add this to your .emacs:

;; (add-to-list 'load-path "/folder/containing/file")
;; (require 'sauron-notmuch)
;; (sauron-notmuch-start)


;;; Code:
(require 'sauron)
(require 'notmuch) ;;  nil 'noerror)

(defvar sauron-notmuch-important-filter nil
  "Important messages filter (should be replaced).")

(defvar sauron-notmuch-unread-filter "tag:unread AND NOT tag:deleted"
  "Unread messages filter.")

(defvar sauron-notmuch-running nil
  "*internal* whether sauron notmuch is running.")

(defun sauron-notmuch-start ()
  "Start watching notmuch."
  (unless sauron-notmuch-running
    (add-hook 'notmuch-index-updated-hook
	      'sauron-notmuch-new-mail-notification)
    (setq sauron-notmuch-running t))
    t)

(defun sauron-notmuch-stop ()
  "Stop watching notmuch."
  (when sauron-notmuch-running
    (remove-hook 'notmuch-index-updated-hook
                 'sauron-notmuch-new-mail-notification)
    (setq sauron-notmuch-running nil)))


(defun sauron-notmuch-check-unread-messages ()
  "Check our mail dir for 'new' messages and return the count."
  (let ((cmd (format "notmuch search %s | wc -l" sauron-notmuch-unread-filter)))
	(string-to-number (replace-regexp-in-string "![0-9]" "" (shell-command-to-string cmd)))
	))

(defun sauron-notmuch-check-important-messages()
  "Check our mail dir for 'new' messages and return the count."
  (if sauron-notmuch-important-filter
      (let ((cmd (format "notmuch search (%s) and (%s)| wc -l"
			 sauron-notmuch-unread-filter
			 sauron-notmuch-important-filter)))
        (string-to-number (replace-regexp-in-string "![0-9]" "" (shell-command-to-string cmd)))
        )
    0))

(defun sauron-notmuch-new-mail-notification ()
  "New mail notification routine for Sauron."
  (let ((unread (sauron-notmuch-check-unread-messages))
        (nb_important (sauron-notmuch-check-important-messages)))
    (if (> nb_important 0)
        (sauron-add-event
         'notmuch 6
         (format "You have %i unread messages including %i importants" unread nb_important))

      ;; If nothing important, still validate the number of of total messages
      (if (> unread 0)
          (sauron-add-event
           'notmuch 3
           (format "You have %i unread messages" unread)))

        )))

(provide 'sauron-notmuch)

;;; sauron-notmuch.el ends here
