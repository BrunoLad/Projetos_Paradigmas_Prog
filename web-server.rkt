#lang web-server/insta

(require rackunit "SQL.rkt")
(require html-template)
;struct padrao de uma linha da tabela
(struct table (data hora esporte local jogadores))

;retorna uma lista de lista com todos os elementos do BD
(define (gera-lista-linhas)
  (vectorList->list))

;converte uma lista na estrutura de tabela
(define (list->table lst)
      (table (car lst) (car (cdr lst)) (car (cddr lst)) (car (cdddr lst)) (car (cddddr lst))))

;converte a lista vinda do BD, numa lista de tabelas
(define (listOfTables)
  (define (listOfTables2 lst tb)
    (if (null? lst)
        tb
        (listOfTables2 (cdr lst) (cons (list->table (car lst)) tb))))
  (listOfTables2 (gera-lista-linhas) null))

;define as linhas da tabela em html
(define TABELA
  (cons (table "data" "hora" "esporte" "local" "jogadores") (listOfTables)))

;gera as colunas cabecalhos da tabela
(define (th-html tbl)
 `(th,(table-data tbl)
  (th,(table-hora tbl))
  (th,(table-esporte tbl))
  (th,(table-local tbl))
  (th,(table-jogadores tbl))))

;gera o html da tabela
(define (gera-tabela-html tbl)
  `(div ((class "table"))
        (table(,(vai-linha tbl null)))))

;um teste malsucedido
(define (gera-tabela-html2 tbl)
  (html-template
   (table (@ (border "1"))
         (tr (th "data") (th "hora") (th "esporte") (th "local") (th "jogadores"))
         (%write
          (for-each (lambda (tbody)
                      (html-template
                       (tr (td (% (table-data tbody)))
                           (td (% (table-hora tbody)))
                           (td (% (table-esporte tbody)))
                           (td (% (table-local tbody)))
                           (td (% (table-jogadores tbody))))))
                    (cdr tbl))))))

;brincando com fogo
(define (vai-linha tbl linhas)
  (if (null? tbl)
      linhas
  (vai-linha (cdr tbl) (cons `(tr(,(th-html (car tbl)))) linhas))))
        
;start no web-server       
(define (start request)
  (render-page TABELA request))

;constroi o codigo html da pagina
(define (render-page tbl request)
  (response/xexpr
   `(html (head (title "Mural da quadra"))
          (body (h1 "Mural da quadra")
                ,(gera-tabela-html tbl)))))


  