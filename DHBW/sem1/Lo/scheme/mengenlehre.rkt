;; Eleganterer Weg für die Fibonacci Zahlen
(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 2))
                 (fib (- n 1))))
        )
  )

(fib 5)
(fib 10)
(fib 20)

;; Einfügen
(define (is-element? k set)
  (cond ((null? set) #f)
        ((= k (car set)) #t)
        (else (is-element? k (cdr set)))))

(define (insert k set)
  (if (is-element? k set)
      set
      (cons k set)))

(insert 4 '(1 2 3))

;; Vereinigung
(define (union set1 set2)
  (if (null? set1)
      set2
      (insert (car set1)
              (union (cdr set1) set2))))

(union '(1 2 3) '(3 2 1))
(union '(1 2 3) '(3 4 5))

;; Schnittmenge


;; Kartesisches Produkt
;; Als zwei Funktionen
(define (pair k set)
  (if (null? set)
      set
      (cons (list k (car set)) (pair k (cdr set)))))

(pair 1 '(1 2 3))

(define (kat set1 set2)
  (if (null? set1)
      set1
      (cons (pair (car set1) set2) (kat (cdr set1) set2))))

(kat '(1 2 3) '(4 5 6))

;; Potenzmenge
;; Als zwei Funktionen
(define (subsets k set)
  (if (null? set)
      set
      (cons (cons k (car set))
            (subsets k (cdr set)))))

;; Konstruktionslogik für die Rekursive Art um die Subsets zu finden
;; '(1 2 3) -> '(1) '(1 3) '(1 2) '(1 2 3)
;; 1 '(2 3) -> '(2) '(2 3)
;; 1 2 '(3) -> '(3)
;; 1 2 3 '()-> '()
(define (powerset set)
  (if (null? set)
      (list set)
      (let ((subpwrset (powerset (cdr set))))
        (append subpwrset
                (subsets (car set) subpwrset)))))

(powerset '(1 2 3))