#lang racket

(require scribble/html)

;Gera  o código html dos titulos de cada coluna da tabela
(define (gera-titulos)
  (xml->string
   (thead
    (tr
     (th "Data")
     (th "Hora")
     (th "Esporte")
     (th "local")
     (th "jogadores")))))

;Função auxiliar que gera uma tag </th> com o primeiro elemento de uma lista 
(define (gera-th lst)
    (xml->string
       (th (car lst)) ))

;Gera o código HTML de uma linha com dados recebidos de uma lista, no caso, esperando: (Esporte Horario)
(define (gera-linha lst)
  (define (gera-linha-aux l acc)
    (if (not (null? l))
        (gera-linha-aux (cdr l) (string-append acc (gera-th l)))
        acc))
  (gera-linha-aux lst ""))

;Função auxiliar que gera uma tag </tr> com uma tupla de dados
(define (gera-tr lst)
  (xml->string
   (tr (gera-linha lst))))

;Gera o código html de uma tabela recebendo uma lista de listas como parâmetro. Cada lista da lista representará uma tupla da tabela
(define (gera-tabela lst)
  (define (gera-tabela-aux l acc)
    (if (not (null? l))
        (gera-tabela-aux (cdr l) (string-append acc (gera-tr (car l))))
        acc))
  (gera-tabela-aux lst (gera-titulos)))




  