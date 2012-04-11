#!/usr/bin/env gosh

(use gauche.parseopt)
(use rfc.json)
(use rfc.http)

(define lunchstate-host "lunchstate.herokuapp.com")

(define (json->value hash)
  (cdr (assoc "value" hash)))

(define (create-state user key value)
  (print "Not yet implemented.")
  (exit 1))

(define (read-state user key)
  (unless (and user key)
          (usage))
  (let ((container (receive (status header body)
                            (http-get lunchstate-host
                                      (string-append "/" user "/" key))
                            (parse-json-string body))))
    (print (json->value (vector-ref (cdar container) 0)))
    (exit 0)))

(define (update-state user key value)
  (print "Not yet implemented.")
  (exit 1))

(define (delete-state user key)
  (print "Not yet implemented.")
  (exit 1))

(define (usage)
  (print "lunchstate {create|read|update|delete} -u user -k key [-v value]")
  (print " -h,--help            Print this help")
  (print " -k,--key <key>       Target key")
  (print " -u,--user <user>     Target user to access state")
  (print " -v,--value <value>   Target value")
  (exit 1))

(define (main args)
  (guard (exc
          ((condition-has-type? exc <parseopt-error>) (usage)))
         (let ((mode (cadr args)))
           (let-args (cddr args)
                     ((user  "u|user=s")
                      (key   "k|key=s")
                      (value "v|value=s")
                      (#f    "h|help" => usage)
                      . rest)
                     (cond
                      ((equal? mode "create") (create-state user key value))
                      ((equal? mode "read")   (read-state   user key))
                      ((equal? mode "update") (update-state user key value))
                      ((equal? mode "delete") (delete-state user key))
                      (else (usage)))))))

