#|
  This file is a part of mu-kanren project.
  Copyright (c) 2018 David Duthie
|#

#|
  Author: David Duthie
|#

(asdf:defsystem "mu-kanren"
  :version "0.1.0"
  :author "David Duthie"
  :license ""
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "mu-kanren"))))
  :description "muKanren"
  :long-description
  #.(uiop:read-file-string
     (uiop:subpathname *load-pathname* "README.md"))
  :in-order-to ((test-op (test-op "mu-kanren-test"))))

;; (ql:quickload :git-notify)

