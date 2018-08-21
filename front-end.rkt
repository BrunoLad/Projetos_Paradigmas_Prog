#lang racket

(require scribble/html)
(require "SQL.rkt")
(provide pagina-index)
(provide string-byte)


;*******************Funções auxiliares*******************

;(String) Gera  o código html dos titulos de cada coluna da tabela
(define (gera-titulos)
  (xml->string
   (thead
    (tr
     (th "Data")
     (th "Hora")
     (th "Esporte")
     (th "local")
     (th "jogadores")))))

;(String) Função auxiliar que gera uma tag </th> com o primeiro elemento de uma lista 
(define (gera-th lst)
    (xml->string
       (th (car lst)) ))

;(String) Gera o código HTML de apenas uma linha com dados recebidos de uma lista, abrindo e fechando com a tag <tr>
(define (gera-linha lst)
  (define (gera-linha-aux l acc)
    (if (not (null? l))
        (gera-linha-aux (cdr l) (string-append acc (gera-th l)))
        (xml->string
         (tr (literal acc)))))
  (gera-linha-aux lst ""))

;(String) Gera o código html de uma tabela recebendo uma lista de listas como parâmetro. Cada lista da lista representará uma tupla da tabela
(define (gera-tabela lst)
  (define (gera-tabela-aux l acc)
    (if (not (null? l))
        (gera-tabela-aux (cdr l) (string-append acc (gera-linha (car l))))
        acc))
  (gera-tabela-aux lst ""))


                 
;div para englobar os links que redirecionam para outras páginas
(define (links-Pages)
  (make-element 'div '[(class . "links")] (cons (cadastrar-novo-jogo-page) (entrar-em-jogo-existente-page))))
                                                
;link para cadastro de novos jogos
(define (cadastrar-novo-jogo-page)
  (make-element 'a '[(href . "/new-game")] "Criar novo jogo"))

;link para entrar nos jogos existentes
(define (entrar-em-jogo-existente-page)
  (make-element 'a '[(href . "/entra-game")] "Entrar no jogo!"))

;(String) Gera a página html com dados da tabela
(define (gera-pagina lst)
  (xml->string
   (html
    (head
     (make-element 'meta '[(charset . "utf-8")
                           (name . "viewport")
                           (content . "initial-scale=1.0; maximum-scale=1.0; width=device-width")] "")
     (title "Mural da Quadra")
     (make-element 'link '[(rel "stylesheet")
                           (type "text/css")
                           (href "/style.css")] "")
     )
    (body
     (make-element 'div '[(class . "table-title")]
      (h1 "Mural da Quadra"))
     (table
      (make-element 'di '[(class . "table-title")] (literal gera-titulos))
      (make-element 'tbody '[(class . "table-hover")] (literal (gera-tabela lst))))
      (links-Pages)))))


;retorna uma lista de lista com todos os elementos do BD
(define (gera-lista-linhas)
  (vectorList->list))

;funcao string para byte
(define (string-byte str bt)
  (if(null? str)
     bt
     (string-byte (cdr str) (bytes-append bt (make-bytes 1 (char->integer(car str)))))))

; retona a pagina index com a tabela populada com o sql
(define (pagina-index)
  (string-byte(string->list(gera-pagina (gera-lista-linhas))) #""))
