#lang web-server/insta

(require rackunit "SQL.rkt")

(struct table (padrao))

(define TABELA
  (table '("data" "hora" "esporte" "local" "jogadores")))

(define (th-html value)
  `(th "value"))

(define (gera-tabela-html tbl)
  `(div ((class "table"))
        (table,(tr,(th, "aaa")))))
        
        
(define (start request)
  (render-page TABELA request))


(define (render-page tbl request)
  (response/xexpr
   `(html (head (title "Mural da quadra"))
          (body (h1 "Mural da quadra")
                ,(gera-tabela-html (table-padrao tbl))))))


  