#lang web-server/insta
(require html-template)
(require web-server/templates)

;start no web-server       
(define (start request)
  (render-page request))


;constroi o codigo html da pagina
(define (render-page request)
  (response
 301 #"OK"
 (current-seconds) TEXT/HTML-MIME-TYPE
 empty
 (λ (op) (write-bytes (string-byte (string->list(include-template "test.html")) #"0") op))))


;funcao string para byte
(define (string-byte str bt)
  (if(null? str)
     bt
     (string-byte (cdr str) (bytes-append bt (make-bytes 1 (char->integer(car str)))))))