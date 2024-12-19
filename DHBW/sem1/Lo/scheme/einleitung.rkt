;; Definition von einer Funktion
(define (hello)
  ;; display ist quasie ein print
  ;; es gibt auch ein displayln
  (display "Hello-World")
  (newline)
)

;; Ist ein Wert den das Programm direkt erzeugt
(hello)
"Hello World"


(define (fak n)
  (if (= n 0)
      ;; Rekursion
      1
      (* n (fak (- n 1)))))

(fak 10)
(fak 30)

;; Gibt sehr große Zahlen aus und hat keinen Overflow
;;(fak 200)

(define (fib n)
  (if (= n 0)
      0
      (if (= n 1)
          1
          (+ (fib (- n 2)) (fib (- n 1)))
          )
      )
  )

(fib 5)
(fib 10)
(fib 20)