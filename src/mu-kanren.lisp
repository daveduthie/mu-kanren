(defpackage mu-kanren
  (:use :cl))

(in-package :mu-kanren)

(defun var (c) (vector c))

(defun var? (x) (vectorp x))

(defun var=? (x y) (= (aref x 0) (aref y 0)))

(defun walk (u s)
  (let ((pr (and (var? u)
                 (assoc-if (lambda (v) (var=? u v)) s))))
    (if pr (walk (cdr pr) s) u)))

(defun ext-s (x v s) `((,x . ,v) . ,s))

(defun id (u v)
    (lambda (sc)
      (let ((s (unify u v (car sc))))
        (if s (unit `(,s . ,(cdr sc))) mzero))))

(defun unit (sc) (cons sc mzero))

(defvar mzero '())

(defun unify (u v s)
  (let ((u (walk u s)) (v (walk v s)))
    (cond
      ((and (var? u) (var? v) (var=? u v)) s)
      ((var? u) (ext-s u v s))
      ((var? v) (ext-s v u s))
      ((and (consp u)  (consp v))
       (let ((s (unify (car u) (car v) s)))
         (and s (unify (cdr u) (cdr v) s))))
      (:otherwise (and (equal u v) s)))))

(defun call/fresh (f)
  (lambda (sc)
    (let ((c (cdr sc)))
      ;; TODO: check translation
      (funcall (funcall f (var c)) `(,(car sc) . ,(+ c 1))))))

(defun disj (g1 g2)
  (lambda (sc)
    (mplus (funcall g1 sc) (funcall g2 sc))))

(defun conj (g1 g2)
  (lambda (sc) (bind (funcall g1 sc) g2)))

(defun mplus ($1 $2)
  (cond
    ((null $1) $2)
    ((functionp $1) (lambda () (mplus $2 (funcall $1))))
    (:otherwise (cons (car $1) (mplus (cdr $1) $2)))))

(defun bind ($ g)
  (cond
    ((null $) mzero)
    ((functionp $) (lambda () (bind (funcall $) g)))
    (:otherwise (mplus (funcall g (car $)) (bind (cdr $) g)))))


;; (aref (vector 1 2 3) 1)

;; (defun foo () (lambda () :foo))

;; (funcall (foo))


(defparameter empty-state '(() . 0))

(funcall (call/fresh (lambda (q) (id q 5))) empty-state)

