#!/usr/bin/racket
#lang racket
(require racket/gui/base
         images/icons/symbol
         "ltt-gui.rkt")


;;; A word is 5 characters (space included).

(define text-font (make-font #:weight 'bold))
(define (make-text-image text color)
  (text-icon text
             text-font
             #:color color #:height 24))
(define blank-bmp (make-bitmap 20 20 #t))
(define error-bmp     (make-text-image "*** Error ! ***"  "Red"))
(define finished-bmp  (make-text-image "Finished !"       "Green"))
(define start-bmp     (make-text-image "Type to start"    "Blue"))

(define-syntax-rule (++ v)
  (set! v (add1 v)))

(define-syntax-rule (+= var val)
  (set! var (+ var val)))

(define start-time 0)
(define finished #f)
;(define write-time 0)
(define (elapsed-time)
  (- (current-seconds) start-time))
(define time-timer (new timer% 
                        [notify-callback 
                         (lambda _ (update-msg-timer))]))

(define errors 0)
(define in-error #f) ; Is there an error currently?

; time lost in correcting errors
(define total-correction-time 0) ; milliseconds
(define last-correction-time #f)


(define (update-msg-timer)
  (define write-len (string-length (send txt-write get-text)))
  (define lost-seconds (/ total-correction-time 1000))
  (define total-time (elapsed-time))
  (send msg-timer set-label
        (format "Time:~as (~awpm) #Chars: ~a/~a Errors:~a (~a%words) Lost-time:~as (~a%; would be:~awpm)"
                (if (= 0 start-time) 0 total-time)
                (real->decimal-string
                 (chars-secs->words/min write-len total-time))
                write-len
                (string-length (send txt-read get-text)) ; should be cached
                errors
                (if (= 0 write-len) 0 
                    ; * 100 (percentage) * 5 (chars/word)
                    (round (/ (* 500 errors) write-len)))
                (real->decimal-string lost-seconds)
                (if (= 0 total-time) 0 (round (/ (* 100. lost-seconds) total-time)))
                (real->decimal-string
                 (chars-secs->words/min write-len (- total-time lost-seconds)))
                )))

(define (restart)
  (set! start-time 0)
  (set! finished #f)
  (set! errors 0)
  (set! in-error #f)
  (set! total-correction-time 0)
  (set! last-correction-time #f)
  (send txt-write erase)
  (send msg-timer set-label "0")
  (send msg-info set-label start-bmp)
  (update-msg-timer)
  (send ed-cv-txt-write focus)
  )

(define (chars-secs->words/min nchars secs)
  (if (= secs 0) 0
      (/ (/ nchars 5.)
         (/ secs 60.))))

;; Looks for the first error in the user string, 
;; when compared to the teacher string.
;; Returns #f if no error is found, otherwise returns 
;; the position, the teacher char, and the user char.
(define (first-error teacher-txt user-txt)
  (not (string=? (substring teacher-txt 0 (min (string-length teacher-txt)
                                               (string-length user-txt)))
                 user-txt)))

(define my-text%
  (class text%
    (super-new)
    (define/override (on-char ev)
      (when (eq? (send ev get-key-code) 'release)
        (when (and (= start-time 0) (not finished))
          (set! start-time (current-seconds))
          (send time-timer start 1000)
          )
        
        (unless finished
          (define user-txt     (send this get-text))
          (define teacher-txt  (send txt-read get-text))
          (define tch-txt-len  (string-length teacher-txt))
          (define err          (first-error teacher-txt user-txt))
          (define last-char?   (and (not err) (= (string-length user-txt)
                                                 tch-txt-len)))
          (cond [err
                 (unless in-error
                   (set! in-error #t)
                   (++ errors)
                   (set! last-correction-time (current-milliseconds)))]
                [in-error
                 (set! in-error #f)
                 (+= total-correction-time 
                     (- (current-milliseconds) last-correction-time))]
                [last-char?
                 (send time-timer stop)
                 (set! finished #t)])
          
          (send msg-info set-label
                (cond [err         error-bmp]
                      [last-char?  finished-bmp]
                      [else        blank-bmp]))
          (update-msg-timer)))
      (super on-char ev)
      ) ; on-char
    ))

(define (paste)
  (define x-txt "");(send the-x-selection-clipboard get-clipboard-string 0))
  (define txt 
    (if (string=? x-txt "")
        (send the-clipboard get-clipboard-string 0)
        x-txt))
  (set! txt (string-trim txt))
  ; Normalize string:
  (for ([c (in-string txt)]
        [i (in-naturals)])
    (cond [(member c '(#\œ)) (void)] ; do not change
          [(assoc c '((#\’ #\')))
           => (λ(v)(string-set! txt i (second v)))]
          [(> (char->integer c) 256) ; replace by a space
           (string-set! txt i #\space)]))
  (send txt-read erase)
  (send txt-read insert (string-normalize-spaces txt))
  )
         
         
(define txt-read (new text% [auto-wrap #t]))

(define txt-write
  (new my-text% [auto-wrap #t]))

(define txt-keymap (send txt-write get-keymap))
;(add-editor-keymap-functions txt-keymap)

; see help for keymap% and add-text-keymap-functions
(add-text-keymap-functions txt-keymap)
(send txt-keymap map-function "c:backspace" "delete-previous-word")

(ltt-gui-init
 #:ed-cv-txt-write-editor txt-write
 #:ed-cv-txt-read-editor txt-read
 #:bt-restart-callback (λ _ (restart))
 #:bt-paste-callback (λ _ (paste) (restart))
 #:msg-info-label blank-bmp
 #:frame-main-code-gen-class
 (class frame% (super-new)
   (define/augment (on-close)
     (exit))))
(restart)
