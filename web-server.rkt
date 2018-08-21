#lang web-server/insta

(require css-expr)
(require rackunit "front-end.rkt")
(require web-server/templates)
(require web-server/servlet-env)
(require net/uri-codec)
(require "SQL.rkt")
(require "new-game.rkt")
(require "entrar-game.rkt")

;Funções auxiliares para geração do css
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
                                   (λ (op) (write-bytes (pagina-index) op)))]
    [(equal? page "new-game")(response
                                   200 #"OK"
                                   (current-seconds) TEXT/HTML-MIME-TYPE
                                   empty
                                   (λ (op) (write-bytes (pagina-add) op)))]
    [(equal? page "entra-game")(response
                                   200 #"OK"
                                   (current-seconds) TEXT/HTML-MIME-TYPE
                                   empty
                                   (λ (op) (write-bytes (pagina-entrar) op)))]
     
     
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
         (p "Jogo adicionado com sucesso")
         (a ((href "/muraldaquadra")) "Voltar"))))]
    
     [(equal? page "entrargame")
     ; extrai form data:
     (define post-data (bytes->string/utf-8 (request-post-data/raw request)))
     ; converte para alist
     (define form-data (form-urlencoded->alist post-data))
     ; define os elementos com os valores dos inputs
     (define data (cdr (assq 'data form-data)))
     (define hora (cdr (assq 'hora form-data)))
     (define local (cdr (assq 'local form-data)))
     ;adiociona o jgoo na tabela sql
     (update-tabela-soma-jogador data hora local)
      ; da resposta positiva para usuario
     (response/xexpr
      `(html
        (body
         (p "Jogador adicionado com sucesso")
         (a ((href "/muraldaquadra")) "Voltar"))))]
    [(equal? page "style.css")
     (response
      200 #"OK"
      (current-seconds) TEXT/HTML-MIME-TYPE
      empty
      (λ (op) (write-bytes gera-css op)))]
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


  