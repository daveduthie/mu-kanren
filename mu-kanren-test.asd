#|
  This file is a part of mu-kanren project.
  Copyright (c) 2018 David Duthie
|#

(defsystem "mu-kanren-test"
  :defsystem-depends-on ("prove-asdf")
  :author "David Duthie"
  :license ""
  :depends-on ("mu-kanren"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "mu-kanren"))))
  :description "Test system for mu-kanren"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
