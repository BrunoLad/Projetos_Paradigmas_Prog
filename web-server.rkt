#lang web-server/insta

(require rackunit "front-end.rkt")
(require web-server/templates)
(require web-server/servlet-env)

;constroi o codigo html da pagina
(define (render-page request)
(response
 200 #"OK"
 (current-seconds) TEXT/HTML-MIME-TYPE
 empty
 (λ (op) (write-bytes pagina-index op))))

;Só para upar arquivos
(serve/servlet render-page
               #:extra-files-paths
               (list
               (current-directory)))

;start no web-server       
(define (start request)
  (render-page request))

  