#lang racket/base

;;==========================================================================
;;===                Code generated with MrEd Designer 3.12              ===
;;===              https://github.com/Metaxal/MrEd-Designer              ===
;;==========================================================================

;;; Call (ltt-gui-init) with optional arguments to this module

(require
 framework
 racket/list
 racket/class
 racket/gui/base
 )

(provide ltt-gui-init
         frame-main
         ed-cv-txt-read
         msg-info
         ed-cv-txt-write
         msg-timer)

(define (label-bitmap-proc l)
  (let ((label (first l)) (image? (second l)) (file (third l)))
    (or (and image?
             (or (and file
                      (let ((bmp (make-object bitmap% file 'unknown/mask)))
                        (and (send bmp ok?) bmp)))
                 "<Bad Image>"))
        label)))

(define (list->font l)
  (with-handlers
   ((exn:fail?
     (λ (e)
       (send/apply
        the-font-list
        find-or-create-font
        (cons (first l) (rest (rest l)))))))
   (send/apply the-font-list find-or-create-font l)))

(define ltt-gui #f)
(define frame-main #f)
(define ed-cv-txt-read #f)
(define horizontal-panel-3616 #f)
(define bt-paste #f)
(define msg-info #f)
(define ed-cv-txt-write #f)
(define horizontal-panel-3937 #f)
(define bt-restart #f)
(define msg-timer #f)
(define (ltt-gui-init
         #:frame-main-code-gen-class
         (frame-main-code-gen-class frame%)
         #:ed-cv-txt-read-editor
         (ed-cv-txt-read-editor #f)
         #:bt-paste-callback
         (bt-paste-callback (lambda (button control-event) (void)))
         #:msg-info-label
         (msg-info-label (label-bitmap-proc (list "" #t "blank.png")))
         #:ed-cv-txt-write-editor
         (ed-cv-txt-write-editor #f)
         #:bt-restart-callback
         (bt-restart-callback (lambda (button control-event) (void))))
  (set! frame-main
    (new
     frame-main-code-gen-class
     (parent ltt-gui)
     (label "Learn To Type")
     (width #f)
     (height #f)
     (x #f)
     (y #f)
     (style '())
     (enabled #t)
     (border 0)
     (spacing 0)
     (alignment (list 'center 'top))
     (min-width 700)
     (min-height 200)
     (stretchable-width #t)
     (stretchable-height #t)))
  (set! ed-cv-txt-read
    (new
     editor-canvas%
     (parent frame-main)
     (editor ed-cv-txt-read-editor)
     (style '(no-focus))
     (scrolls-per-page 100)
     (label "Editor-Canvas")
     (wheel-step 3)
     (line-count #f)
     (horizontal-inset 5)
     (vertical-inset 5)
     (enabled #t)
     (vert-margin 0)
     (horiz-margin 0)
     (min-width 0)
     (min-height 200)
     (stretchable-width #t)
     (stretchable-height #t)))
  (set! horizontal-panel-3616
    (new
     horizontal-panel%
     (parent frame-main)
     (style '())
     (enabled #t)
     (vert-margin 0)
     (horiz-margin 0)
     (border 0)
     (spacing 0)
     (alignment (list 'left 'center))
     (min-width 0)
     (min-height 0)
     (stretchable-width #t)
     (stretchable-height #f)))
  (set! bt-paste
    (new
     button%
     (parent horizontal-panel-3616)
     (label (label-bitmap-proc (list "Paste" #f #f)))
     (callback bt-paste-callback)
     (style '())
     (font (list->font (list 8 #f 'default 'normal 'normal #f 'default #f)))
     (enabled #t)
     (vert-margin 2)
     (horiz-margin 2)
     (min-width 0)
     (min-height 0)
     (stretchable-width #f)
     (stretchable-height #f)))
  (set! msg-info
    (new
     message%
     (parent horizontal-panel-3616)
     (label msg-info-label)
     (style '())
     (font
      (list->font (list 16 "Monospace" 'default 'normal 'bold #f 'default #f)))
     (enabled #t)
     (vert-margin 2)
     (horiz-margin 2)
     (min-width 0)
     (min-height 20)
     (stretchable-width #t)
     (stretchable-height #f)
     (auto-resize #t)))
  (set! ed-cv-txt-write
    (new
     editor-canvas%
     (parent frame-main)
     (editor ed-cv-txt-write-editor)
     (style '())
     (scrolls-per-page 100)
     (label "Editor-Canvas")
     (wheel-step 3)
     (line-count #f)
     (horizontal-inset 5)
     (vertical-inset 5)
     (enabled #t)
     (vert-margin 0)
     (horiz-margin 0)
     (min-width 400)
     (min-height 200)
     (stretchable-width #t)
     (stretchable-height #t)))
  (set! horizontal-panel-3937
    (new
     horizontal-panel%
     (parent frame-main)
     (style '())
     (enabled #t)
     (vert-margin 0)
     (horiz-margin 0)
     (border 0)
     (spacing 0)
     (alignment (list 'center 'center))
     (min-width 0)
     (min-height 0)
     (stretchable-width #t)
     (stretchable-height #f)))
  (set! bt-restart
    (new
     button%
     (parent horizontal-panel-3937)
     (label (label-bitmap-proc (list "Restart" #f #f)))
     (callback bt-restart-callback)
     (style '())
     (font (list->font (list 8 #f 'default 'normal 'normal #f 'default #f)))
     (enabled #t)
     (vert-margin 2)
     (horiz-margin 2)
     (min-width 0)
     (min-height 0)
     (stretchable-width #f)
     (stretchable-height #f)))
  (set! msg-timer
    (new
     message%
     (parent horizontal-panel-3937)
     (label (label-bitmap-proc (list "0" #f #f)))
     (style '())
     (font (list->font (list 8 #f 'default 'normal 'normal #f 'default #f)))
     (enabled #t)
     (vert-margin 2)
     (horiz-margin 2)
     (min-width 20)
     (min-height 0)
     (stretchable-width #t)
     (stretchable-height #f)
     (auto-resize #f)))
  (send frame-main show #t))
