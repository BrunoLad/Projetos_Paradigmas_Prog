#lang racket
;precisa instalar pkg sql no racket, facilitador de comando
;sudo raco pkg install sql
(require sql)
(require db)

;exportando metodos para a manipulacao da tabela em outro programa rkt
;usar com (require rackunit "SQL.rkt"), os programas devem estar na mesma pasta
(provide insere-novo-jogo)
;(provide lista-tudo)
(provide update-tabela-soma-jogador)
(provide vectorList->list)

;conecta no db, deve se existir uma db com o nome horarios na pasta raiz do servidor, ou seja, onde esse programa esta rodando
(define TABELA
  (sqlite3-connect #:database "horarios.db"))

;metodo que cria a tabela
(define (cria-tbl bool)
 (query-exec TABELA
             (create-table tabelaGeral
                           #:columns [data date] [hora time] [esporte text] [quadra text] [num integer]
                           #:constraints (primary-key data hora quadra))))

;se a tabela ainda nao existe na db, entao ela e criada
(define (checa-cria)
  (if(table-exists? TABELA "tabelaGeral")
     (display #t)
     (cria-tbl #t)))

;metodo que insere um novo jogo na tabela geral de horarios e jogos
(define (insere-novo-jogo e d h q)
    (query-exec TABELA
             (gera-string-sql e d h q)))

;gera a string para inserir sql
(define (gera-string-sql e d h q)
 (string-append "INSERT INTO tabelaGeral (data, hora, esporte,quadra, num) VALUES (" (string-append "'" d "', ")
                (string-append "'" h "', ")
                (string-append "'" e "', ")(string-append "'" q "', ") (string-append "1)")))

;update em um jogo, ou seja, soma um jogador 
(define (update-tabela-soma-jogador d h q)
  (query-exec TABELA (string-append "UPDATE tabelaGeral SET num = " (number->string(add1 (query-num-jogadores d h q)))
                                                   " WHERE  data = '" (string-append d "' and hora = '" h
                                                                                     "' and quadra = '" q "'"))))

;retorna o numero de jogadores presentes no jogo que foi requisitado vaga
(define (query-num-jogadores d h q)
  (car(query-list TABELA (string-append "select num from tabelaGeral where data = '"
                                   (string-append d "' and hora = '" h "' and quadra = '" q "'")))))

;metodo que retorna a tabela inteira
(define (lista-tudo)
  (query-rows TABELA
              "select * from tabelaGeral"))

;retorna lista com os elementos de uma coluna, na ordem do sort
  (define (vectorList->list)
    (define (vectorList->list2 vec lst)
      (if (null? vec)
          lst
          (vectorList->list2 (cdr vec) (cons (vector->list (car vec)) lst))))
    (vectorList->list2 (lista-tudo) null))
    