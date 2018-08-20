#lang web-server/insta

(require rackunit "front-end.rkt")
(require web-server/templates)
(require web-server/servlet-env)
(require net/uri-codec)
(require "SQL.rkt")
(require "new-game.rkt")


;constroi o codigo html da pagina
(define (render-page request)
  
(define uri (request-uri request))
(define path (map path/param-path (url-path uri)))    
(define page (car path))
  
  (cond
    [(equal? page "muraldaquadra")(response
                                   200 #"OK"
                                   (current-seconds) TEXT/HTML-MIME-TYPE
                                   empty
                                   (λ (op) (write-bytes pagina-index op)))]
    [(equal? page "new-game")(response
                                   200 #"OK"
                                   (current-seconds) TEXT/HTML-MIME-TYPE
                                   empty
                                   (λ (op) (write-bytes pagina-add op)))]
     
    [(equal? page "addesporte")
     ; extrai form data:
     (define post-data (bytes->string/utf-8 (request-post-data/raw request)))
     ; converte para alist
     (define form-data (form-urlencoded->alist post-data))
     ; define os elementos com os valores dos inputs
     (define data (cdr (assq 'data form-data)))
     (define esporte (cdr (assq 'esporte form-data)))
     (define hora (cdr (assq 'hora form-data)))
     (define local (cdr (assq 'local form-data)))
     ;adiociona o jgoo na tabela sql
     (insere-novo-jogo esporte data hora local)
      ; da resposta positiva para usuario
     (response/xexpr
      `(html
        (body
         (p "Jogo adicionado com sucesso"))))]
    [else 
     (response/xexpr
      `(html
        (body
         (p "PAGINA NÃO ENCONTRADA!"))))]))


;Só para upar arquivos
(serve/servlet render-page
               #:servlet-regexp #rx""
               #:port 8080
               #:servlet-path "/muraldaquadra"
               #:extra-files-paths
               (list
               (current-directory)))
             


;start no web-server       
(define (start request)
  (render-page request))


  