;; split is called two times in mergeSort with an offset in the lst
;; it makes from a lst '(a b a b) one lst: '(a a)
;; the second call gets a lst '(b a b) and returns: '(b b)
(define (split lst)
  (cond ((null? lst) lst)
        ((null? (cdr lst)) lst)
        (else (cons (car lst) (split (cdr (cdr lst)))))))

;; merge is more like a sort
;; it uses two sorted lst and sorts their values one at a time
(define (merge lst1 lst2)
  (cond ((null? lst1) lst2)
        ((null? lst2) lst1)
        ((< (car lst2) (car lst1))
              (cons (car lst2) (merge lst1 (cdr lst2))))
        (else (cons (car lst1) (merge (cdr lst1) lst2)))))


;; is the call function
;; first it splits the list into their smallest chunks
;; on each pair of small chunks it calls merge, which sorts those chunks
;; so => merge is also called multiple times per sort
(define (mergeSort lst)
  (cond ((null? lst) lst)
        ((null? (cdr lst)) lst)
        (else (merge (mergeSort (split lst))
                     (mergeSort (split (cdr lst)))))))

"Test: Split Odd"
(split '())
(split '(1))
(split '(1 2))
(split '(1 2 3 4 5))
(split '(1 2 3 4 5 6))

"Test: Merge"
(merge '() '())
(merge '(1) '())
(merge '() '(1))
(merge '(1) '(1))
(merge '(1) '(2))
(merge '(2) '(1))
(merge '(1 3) '(2))
(merge '(2) '(1 3))
(merge '(2 3) '(1))
(merge '(1) '(2 3))

"Test: MergeSort"
(mergeSort '())
(mergeSort '(1))
(mergeSort '(33 1 17 8 3))
(mergeSort '(16 1 2 8 11 3 15 7 4 12 6 5 9 10 13 14))

"File Read in"
;; open a file with a list to sort
(define in
  ;; sortlist.txt had multiple list (1 2 3) (4 5 6) (...) ...
  ;; I removed those in a text editor
  (open-input-file "sortlist.txt"))


;; (display (read in))
;; (display (mergeSort (read in)))

(close-input-port in)
