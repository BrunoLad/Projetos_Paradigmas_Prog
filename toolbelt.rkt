#lang racket

(provide gera-lista-linhas)
(require "SQL.rkt")

;retorna uma lista de lista com todos os elementos do BD
(define (gera-lista-linhas)
  (vectorList->list))

;funcao string para byte
(define (string-byte str bt)
  (if(null? str)
     bt
     (string-byte (cdr str) (bytes-append bt (make-bytes 1 (char->integer(car str)))))))

;(require html-template)
;(require web-server/templates)


;constroi o codigo html da pagina
;(define (render-page request)
;  (response
 ;301 #"OK"
 ;(current-seconds) TEXT/HTML-MIME-TYPE
 ;empty
 ;(λ (op) (write-bytes (string-byte (string->list(include-template "test.html")) #"0") op))))