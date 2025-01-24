;; Creates a list '(1 2 ... n)
(define (create_row n)
  (cond ((= n 0) '())
        (else (cons n (create_row (- n 1))))))

;; Creates a list of lists so that each car = '(1 2 ... n)
(define (all_pos n)
  (map (lambda (x) (create_row n)) (create_row n)))

;; Does the remove for each row with an increasing dist by 1
(define (remove lst n dist)
  (cond ((null? lst) '())
        (else (cons (remove_one (car lst) n dist)
                    (remove (cdr lst) n (+ dist 1))))))

;; Removes the colums n and all numbers that have the distance of dist to n (diagonals)
(define (remove_one lst n dist)
  (cond ((null? lst) '())
        ((or (= (abs (- (car lst) n)) dist)
             (= (car lst) n))
         (remove_one (cdr lst) n dist))
        (else (cons (car lst)
                    (remove_one (cdr lst) n dist)))))

;; Backtracking with abuse of (map (lambda) '()) -> nothing
;; Test each possible Queen location and reduse the next possible queen locations per row, until the next row has no possible location.
(define (solve lst sol)
  (cond ((null? lst) (list sol))
        (else (apply append
                     (map (lambda (x)(solve (remove (cdr lst) x 1) (cons x sol)))
                          (car lst))))))

"Unit Tests"
(create_row 0)
(create_row 4)

(all_pos 0)
(all_pos 4)

(remove_one '(1 2 3 4) 1 0)
(remove_one '(1 2 3 4) 1 1)
(remove_one '(1 2 3 4) 1 2)
(remove_one '(1 2 3 4) 3 0)
(remove_one '(1 2 3 4) 3 1)
(remove_one '(1 2 3 4) 3 2)

(remove (all_pos 4) 1 0)

(newLine)
"Lösungen für 4 bis 6"
(solve (all_pos 4) '())
(solve (all_pos 5) '())
(solve (all_pos 6) '())
(length (solve (all_pos 12) '()))