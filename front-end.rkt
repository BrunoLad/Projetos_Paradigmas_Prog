#lang racket

(require scribble/html)
(require rackunit "toolbelt.rkt")


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

;(String) Gera a página htlm com dados da tabela
(define (gera-pagina lst)
  (xml->string
   (html
    (head
     (make-element 'meta '[(charset . "utf-8")
                           (name . "viewport")
                           (content . "initial-scale=1.0; maximum-scale=1.0; width=device-width;")] "")
     (title "Mural da Quadra"))
    (body
     (make-element 'div '[(class . "table-title")]
      (h1 "Mural da Quadra"))
     (table
      (make-element 'di '[(class . "table-title")] (literal gera-titulos))
      (make-element 'tbody '[(class . "table-hover")] (literal (gera-tabela lst))))))))

(gera-tabela (gera-lista-linhas))
