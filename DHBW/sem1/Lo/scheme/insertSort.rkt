;; Insertion Sort
;; Funktioniert, indem die letzen beiden elemente Sortiert werden
;; Und danach, das nächste Element an die Richtige Stelle eingefügt wird (per insert)
(define (insert k lst)
  (cond ((null? lst) (list k))
        ((< k (car lst)) (cons k lst))
        (else (cons (car lst) (insert k (cdr lst))))))

(insert 1 '(2 3))
(insert 2 '(1 3))
(insert 3 '(1 2))

(define (isort lst)
  (if (null? lst)
      lst
      (insert (car lst) (isort (cdr lst)))))

(isort '(2 4 1 4 6 0 12 3 17))