#lang racket
;precisa instalar pkg sql no racket, facilitador de comando
;sudo raco pkg install sql
(require sql)
(require db)

;exportando metodos para a manipulacao da tabela em outro programa rkt
;usar com (require rackunit "SQL.rkt"), os programas devem estar na mesma pasta
(provide insere-novo-jogo)
(provide lista-tudo)

;conecta no db, deve se existir uma db com o nome horarios na pasta raiz do servidor, ou seja, onde esse programa esta rodando
(define TABELA
  (sqlite3-connect #:database "horarios.db"))

;metodo que cria a tabela
(define (cria-tbl bool)
 (query-exec TABELA
             (create-table tabelaGeral
                           #:columns [data date] [hora time] [esporte text] [num integer]
                           #:constraints (primary-key data hora))))

;se a tabela ainda nao existe na db, entao ela e criada
(define checa-cria
  (if(table-exists? TABELA "tabelaGeral")
     (printf "tabela ja criada")
     (cria-tbl #t)))

;metodo que insere um novo jogo na tabela geral de horarios e jogos
(define (insere-novo-jogo e d h)
    (query-exec TABELA
             (gera-string-sql e d h)))

;gera a string para inserir sql
(define (gera-string-sql e d h)
 (string-append "INSERT INTO tabelaGeral (data, hora, esporte, num) VALUES (" (string-append "'" d "', ")
                (string-append "'" h "', ")
                (string-append "'" e "', ") (string-append "1);")))

;metodo que retorna a tabela inteira
(define (lista-tudo n)
  (query-rows TABELA
              "select * from tabelaGeral"))


