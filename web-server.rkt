#lang web-server/insta

(require rackunit "SQL.rkt")
;struct padrao de uma linha da tabela
(struct table (data hora esporte local jogadores))

;define as linhas da tabela em html
(define TABELA
  (table "data" "hora" "esporte" "local" "jogadores"))

;retorna uma lista de vetores, ta dificil mexer com isso, nao acho mta coisa na net
(define (gera-lista-linhas)
  (length(lista-tudo)))

;gera as colunas cabecalho da tabela
(define (th-html tbl)
 `(th,(table-data tbl)
  (th,(table-hora tbl))
  (th,(table-esporte tbl))
  (th,(table-local tbl))
  (th,(table-jogadores tbl))))

;gera o html da tabela
(define (gera-tabela-html tbl)
  `(div ((class "table"))
        (table(tr(,@(th-html tbl))))))
        
;start no web-server       
(define (start request)
  (render-page TABELA request))

;constroi o codigo html da pagina
(define (render-page tbl request)
  (response/xexpr
   `(html (head (title "Mural da quadra"))
          (body (h1 "Mural da quadra")
                ,(gera-tabela-html tbl)))))


  