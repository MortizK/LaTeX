;; split is called two times in mergeSort with an offset in the lst
;; it makes from a lst '(a b a b) two lst: '(a a) and '(b b)
(define (split lst)
  (if (null? lst)
      '()
      (cons (car lst)
            (if (null? (cdr lst))
                       '()
                       (split (cdr (cdr lst))))
            )
      )
  )

;; merge is more like a sort
;; it uses two lst and sorts their values one at a time (recursion)
(define (merge lst1 lst2)
  (if (null? lst1)
      lst2
      (if (null? lst2)
          lst1
          (if (< (car lst1) (car lst2))
              (cons (car lst1) (merge (cdr lst1) lst2))
              (cons (car lst2) (merge lst1 (cdr lst2)))
              )
          )
      )
  )

;; is the call function
;; first it splits the list into their smallest chunks (recursion)
;; on each pair of small chunks it calls merge, which sorts those chunks
;; so => merge is also called multiple times per sort
(define (mergeSort lst)
  (if (null? (cdr lst))
      lst
      (merge (mergeSort (split lst))
             (mergeSort (split (cdr lst))))
  )
)

;; open a file with a list to sort
(define in
 (open-input-file "sortlist.txt"))

;;(display (mergeSort '(16 1 2 8 11 3 15 7 4 12 6 5 9 10 13 14)))
;;(display (read in))
(display (mergeSort (read in)))

(close-input-port in)
