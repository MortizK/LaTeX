;; (1 . 2) cons-Paar
(cons 1 2)

;; (()) Liste
(cons '() '())

;; (() 1) Liste
(cons '() (cons 1 '()))

;; (1) Liste
(cons 1 '())

;; (1 2 3) Liste
(cons 1 (cons 2 (cons 3 '())))

;; (1 . 2) cons-Paar
'(1 . 2)

;; (1 2 3) Liste
'(1 . (2 . (3 . ())))

;; (1 2 3 . 4) Unechte Liste
'(1 . (2 . (3 . 4)))