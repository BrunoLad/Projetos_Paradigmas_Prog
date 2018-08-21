#lang racket

(require css-expr)
(require rackunit "front-end.rkt")

(provide gera-css)

(define codigo-css
  (css-expr->css
   (css-expr
    [body
     #:background-color lightblue]
    [h1
     #:color green
     #:text-align center]
    [table
     #:font-family Arial
     #:border-collapse collapse
     #:width 100%
     #:border 1px solid black]
    [tr:nth-child(even) #:background-color \#f2f2f2]
    [tr:hover
     #:background-color: \#ddd]
    [th
     #:padding-top 12px
     #:padding-bottom 12px
     #:text-align left
     #:background-color \#4CAF50
     #:color white]
    [td th
        #:border 1px solid \#ddd
        #:padding 8px])))

(define gera-css
  (string-byte (string->list codigo-css) #""))
