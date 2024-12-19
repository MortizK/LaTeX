;; definition von der funktion
(define (revert lst)
  ;; Wenn die Liste leer ist, gebe eine leere Liste aus
  (if (null? lst)
      '()
      (append (revert (cdr lst))
              (list (car lst)))
      ;; Wenn nicht: (revert(rest) first)
      ;; Alle Funktionen sind nicht destruktiv
  )
)

(display (revert (list 1 2 3 4 5)))
(newline)

;; Bonusaufgaben
;; split: Ein Liste abwechselnd in zwei Listen verteilen
;; mix: Zwei Listen abwechselnd in eine Liste zusammenfügen

;; Zwei Funktionen für split
(define (other lst)
  (if (null? lst)
      lst
      (append (list (car lst))
              (if (null? (cdr lst))
                  '()
                  (other(cdr (cdr lst))))
              )
      )
  )

(define (split lst)
  (if (null? lst)
      lst
      (list (other lst) (other (cdr lst)))
  )
)

(display (split '(1 2 3 4 5)))
(newline)

;; Mix
(define (mix lst1 lst2)
  (if (null? lst1)
      (if (null? lst2)
          '()
          lst2
      )
      (if (null? lst2)
          lst1
          (cons (car lst1)(cons (car lst2) (mix (cdr lst1) (cdr lst2))))
      )
   )
)
  
(display (mix '(1 3 5 7) '(2 4 6)))