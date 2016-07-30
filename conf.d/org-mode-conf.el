(require 'org)
(require 'org-habit)
(require 'evil-org)

;;; todo-states
(setq org-todo-keywords
     '((sequence "TODO" "NEXT" "WAITING" "DONE")))
(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("DONE" :foreground "forest green" :weight bold))))

;;; some keybindings
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cb" 'org-iswitchb)
; TODO: doesn't work
;(evil-define-key 'normal org-mode-map "<space>" 'org-toggle-checkbox)
(define-key global-map "\C-ct" 'org-toggle-checkbox)

(setq org-log-done t)

;; hide leading stars
(setq org-hide-leading-stars t)

;; follow links upon Enter
(setq org-return-follows-link t)

;; enforce todo and checkbox dependencies
(setq org-enforce-todo-dependencies t)
(setq org-enforce-todo-checkbox-dependencies t)

;; agenda settings
(setq org-agenda-files (list "~/org/life.org"
                             "~/org/calendar.org"))
(setq org-deadline-warning-days 30)
;(setq org-agenda-include-diary t)
(add-hook 'org-agenda-mode-hook
  (lambda ()
    (define-key org-agenda-mode-map "j" 'evil-next-line)
    (define-key org-agenda-mode-map "k" 'evil-previous-line)
    (define-key org-agenda-mode-map "\C-f" 'evil-scroll-page-down)
    (define-key org-agenda-mode-map "\C-b" 'evil-scroll-page-up)
    (define-key org-agenda-mode-map "\C-wk" 'windmove-up)
    (define-key org-agenda-mode-map "\C-wj" 'windmove-down)
    (define-key org-agenda-mode-map "\C-wh" 'windmove-left)
    (define-key org-agenda-mode-map "\C-wl" 'windmove-right)
    ))

;; dim the blocked tasks
(setq org-agenda-dim-blocked-tasks 1)

;; if something is done, don't show it in the agenda
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)  ;; TODO: test this

;; Tags
;; modify tags with C-c C-c
;;  another candidate might be 'commute'
(setq org-tag-alist 
      '((:startgroup)
         ("PhD" . ?p)
         ("oB" . ?o)
         ("personal" . ?m)
        (:endgroup)
        (:startgroup)
         ("@offline" . ?O)
         ("@home" . ?H)
         ("@office" . ?E)
        (:endgroup)
        ("URGENT" . ?u)
        ("REFILE" . ?r)))

;; More than 10 entries in a TODO list doesn't make sense
(setq org-agenda-max-entries 10)

;; My week starts on mondays
(setq org-agenda-start-on-weekday 1)

;; Use 12 hour clock
(setq org-agenda-timegrid-use-ampm 1)

;; Added some custom block-agendas filtering for some tags
(setq org-agenda-custom-commands
   '(("T" "Overview of today"
      ((agenda "" ((org-agenda-ndays 1)
                   (org-agenda-overriding-header "Overview of today")))
       (tags "URGENT"
        ((org-agenda-overriding-header "Things marked urgent")))
       (tags "__doesntexist__"
        ((org-agenda-overriding-header "Next tasks")))
       (tags-todo "NEXT&Stack" 
        ((org-agenda-overriding-header " Stack")
         (org-tags-match-list-sublevels nil)))
       (tags-todo "NEXT&PhD" 
        ((org-agenda-overriding-header " PhD")
         (org-tags-match-list-sublevels nil)))
       (tags-todo "NEXT&oB" 
        ((org-agenda-overriding-header " openBox")
         (org-tags-match-list-sublevels nil)))
       (tags-todo "NEXT&personal" 
        ((org-agenda-overriding-header " personal")
         (org-tags-match-list-sublevels nil)))
       (todo "WAITING"
        ((org-agenda-overriding-header "Things I'm waiting for")))
       ; TODO: put the stuck project block here
       (tags "REFILE"
        ((org-agenda-overriding-header "To refile")))))

     ("W" "Overview of the next week"
      ((agenda "" ((org-agenda-ndays 7)
                   (org-agenda-start-on-weekday nil)
                   (org-agenda-overriding-header "Overview of next week")))
       (tags "URGENT"
        ((org-agenda-overriding-header "Things marked urgent")))
       ; TODO: put the stuck project block here and remove the following block
       (stuck "" 
        ((org-agenda-overriding-header "Stuck projects")))
       (tags "__doesntexist__"
        ((org-agenda-overriding-header "Tasks")))
       (tags-todo "Stack"
        ((org-agenda-overriding-header " Stack")))
       (tags-todo "PhD"
        ((org-agenda-overriding-header " PhD")))
       (tags-todo "oB"
        ((org-agenda-overriding-header " oB")))
       (tags-todo "personal"
        ((org-agenda-overriding-header " personal")))
     ))
     
     ("n" "Next tasks (all projects)" tags "NEXT"
       ((org-agenda-overriding-header "Next things to do")))

     ("N" "Notes" tags "NOTE"
      ((org-agenda-overriding-header "Notes")
       (org-tags-match-list-sublevels t)))

     ("H" "Tasks to be done at home"
      ((agenda "")
       (tags-todo "@home")
       (tags "@home")))

     ("O" "Tasks that can be done offline"
      ((agenda "")
       (tags-todo "@offline")
       (tags "@offline")))

     ("E" "Tasks to be done in the office"
      ((agenda "")
       (tags-todo "@office")
       (tags "@office")))
))

;; Use C-c r n to create a note in ~/org/notes.org with a link to the current
;; file
(global-set-key (kbd "C-c r") 'remember)
(add-hook 'remember-mode-hook 'org-remember-apply-template)
(setq org-remember-templates
      '((?n "* %U %?\n\n %i\n  %a" "~/org/notes.org")))
(setq remember-annotation-functions '(org-remember-annotation))
(setq remember-handler-functions '(org-remember-handler))

;; Use C-c h to go to the 'home' org file (~/org/life.org)
(global-set-key (kbd "C-c h")
                (lambda () (interactive) (find-file "~/org/life.org")))

;; Use C-c s to go to the archive (store)'
(setq org-archive-location "~/org/archive.org::")
(global-set-key (kbd "C-c s")
                (lambda () (interactive) (find-file "~/org/archive.org")))

;; org-capture
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-default-notes-file "~/org/notes.org")
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/org/notes.org")
              "* TODO %?\n%U\n%a\n")
             ("n" "note" entry (file "~/org/notes.org")
              "* %? :NOTE:\n%U\n%a\n")
             ("a" "Appointment/Event" entry (file "~/org/notes.org")
              "* Appointment: %? :APPOINTMENT:\n%U")
             ("h" "Habit" entry (file "~/org/calendar.org")
              "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

;; Automated tags
(setq org-todo-state-tags-triggers
      (quote (("WAITING" ("WAITING" . t))
              ("NEXT" ("NEXT" . t))
              (done ("WAITING"))
              ("TODO" ("WAITING") ("NEXT"))
              ("NEXT" ("WAITING"))
              ("DONE" ("WAITING") ("NEXT")))))

;; Color for urgent tag
(setq org-tag-faces '(("URGENT" . (:foreground "red" :weight bold))))

;; Some cosmetics
(setq org-cycle-separator-lines 0)

;; Auto-commit to SVN
(defun commit-to-svn ()
  "Commit all org-files to SVN."
  (when (eq major-mode 'org-mode)
    ;(shell-command-to-string (format "svn commit %s" buffer-file-name))))
    (shell-command-to-string "svn commit -m Autosave .")))
(add-hook 'after-save-hook #'commit-to-svn)

;; Open URLs in Chromium
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "chromium-browser")
