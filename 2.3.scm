(define (accumulate op initial sequence)
    (if (null? sequence)
        initial
        (op (car sequence)
            (accumulate op initial (cdr sequence))
        )
    )
)

(define (map-m p sequence)
    (accumulate 
        (lambda (x y) 
            (cons (p x) y)
        )
        '() 
        sequence
    )
)
(define (append-m seq1 seq2)
    (accumulate cons seq2 seq1)
)
(define (length-m sequence)
    (accumulate (lambda (x y) (+ 1 y)) 0 sequence)
)
(define (horner-eval x coefficient-sequence)
    (accumulate (lambda (this-coeff higher-term) (+ (* x higher-term) this-coeff))
     0 coefficient-sequence)
)

(define (count-leaves-m t1)
    (accumulate + 0 (if (not (pair? t1)) (list 1) (map count-leaves-m t1)))
)
(define (accumulate-n op init seqs)
    (if (null? (car seqs))
    '()
    (cons (accumulate op init (accumulate (lambda (x y) (cons (car x) y)) '() seqs))
        (accumulate-n op init (accumulate (lambda (x y) (cons (cdr x) y)) '() seqs)))
    )
)

(define (dot-product v w)
   (accumulate + 0 (map * v w))
)

(define (matrix-*-vector m v)
    (map (lambda (r) (dot-product r v)) m)
)

(define (transpose mat)
    (accumulate-n (lambda (l r) (cons l r)) `() mat)
)
(define (matrix-*-matrix m n)
    (let ((cols (transpose n)))
    (map (lambda (row) 
        (map (lambda (col) (dot-product row col)) cols)
        )
     m) 
    )
)

(define (fold-left op initial sequence)
    (define (iter result rest)
        (if (null? rest)
            result
            (iter (op result (car rest))
                (cdr rest)
            )
        )
    )
    (iter initial sequence)
)



(define (flatmap proc seq)
    (accumulate append `() (map proc seq))
)

(define (enumerate-interval s e)
    (if (> s e) `() (cons s (enumerate-interval (+ s 1) e)))
)
(define (unique-pair n)
    (flatmap (lambda (i) 
        (map 
            (lambda (j)
                (list i j)) 
        (enumerate-interval 1 (- i 1)))
    ) (enumerate-interval 1 n))
)
;;; exercise 2.41
(define (triple-pair n)
    (flatmap (lambda (i)
        (flatmap (lambda (j)
            (map 
                (lambda (k)
                    (list k j i))

                (enumerate-interval 1 (- j 1)))
                )
        (enumerate-interval 1 (- i 1))
        )
    ) 
    (enumerate-interval 1 n))
)
(define (filter-triple seq s)
    (filter (lambda (l)
        (= (accumulate + 0 l) s)
    ) seq)
)


(define (adjoin-position new-row k rest-of-queens)
    (append rest-of-queens (list k))
)