;; Skalarprodukt zweier n-elemtigen Vektoren
(apply + (map (lambda (x y) (* x y)) '(1 2 3) '(2 4 6)))

;; Flachen von geschachtelten Listen
(define (flatten2 lst)
  (cond ((null? lst) lst)
        ((list? (car lst))
         (append (flatten2 (car lst))
                 (flatten2 (cdr lst))))
        (else (cons (car lst)
                    (flatten2 (cdr lst))))))

(flatten2 '(1 2 (3 4) 5 ((6 7) 8)))

;; Musterlösung mit dem neuen Stoff
(define (flatten lst)
  (cond
    ((pair? lst)
     (apply append (map flatten lst)))
    (else
     (list lst))))

(flatten '(1 2 (3 4) 5 ((6 7) 8)))