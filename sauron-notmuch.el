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


(provide 'sauron-notmuch)

;;; sauron-notmuch.el ends here
