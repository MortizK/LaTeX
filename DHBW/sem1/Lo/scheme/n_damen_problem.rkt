;; Eine Lösung für 4x4 sieht so aus '(3 1 4 2)

;; 1 2 3 4
;; - D - -
;; - - - D
;; D - - -
;; - - D -

(define (remove n lst)
  (cond ((null? lst) lst)
        ((= n (car lst)) (cdr lst))
        (else (cons (car lst) (remove n (cdr lst))))))

(remove 0 '(1 2 3))
(remove 1 '(1 2 3))
(remove 2 '(1 2 3))

;; For checking the diagonals (currently only king)
(define (check n lst)
  (cond ((null? lst) n)
        (else (apply append (map (lambda (x) (if (or (= x (+ (car lst) 1)) (= x (- (car lst) 1))) '() (list x))) n)))))

"Check the calls from dame"
(check '(1 2 3) '())
(check '(2 3) '(1))
(check '(3) '(2 1))
(check '() '(3 2 1))

(check '(3) '(1 4 2))

(define (diago_fak lst)
  (cond ((null? lst) lst)
        (else (append (map (lambda (x) (+ x 1)) (diago_fak (cdr lst))) '(1)))))

"Diagonal"
(diago_fak '(3))
(diago_fak '(3 1))
(diago_fak '(3 1 4))

;; n ist auch eine liste die von 1 bis n geht
;; can only place Queens like Rocks with addition to what check does
(define (dame n lst)
  (cond ((null? n) (list lst))
        (else (apply append (map (lambda (x) (dame (remove x n) (cons x lst))) (check n lst))))))

"Solutions"
(dame '(1 2 3 4) '())
(dame '(1 2 3 4 5) '())

;; _ _ _ D _ 
;; _ D _ _ _ 
;; _ _ _ _ D 
;; _ _ D _ _ 
;; D _ _ _ _ 