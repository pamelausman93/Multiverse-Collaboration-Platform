;; Reality Discrepancy Resolution Contract

(define-data-var next-discrepancy-id uint u0)

(define-map discrepancies
  { discrepancy-id: uint }
  {
    universe-1: uint,
    universe-2: uint,
    description: (string-utf8 500),
    status: (string-ascii 20)
  }
)

(define-public (report-discrepancy (universe-1 uint) (universe-2 uint) (description (string-utf8 500)))
  (let
    ((discrepancy-id (+ (var-get next-discrepancy-id) u1)))
    (var-set next-discrepancy-id discrepancy-id)
    (ok (map-set discrepancies
      { discrepancy-id: discrepancy-id }
      {
        universe-1: universe-1,
        universe-2: universe-2,
        description: description,
        status: "reported"
      }
    ))
  )
)

(define-public (resolve-discrepancy (discrepancy-id uint))
  (let
    ((discrepancy (unwrap! (map-get? discrepancies { discrepancy-id: discrepancy-id }) (err u404))))
    (ok (map-set discrepancies
      { discrepancy-id: discrepancy-id }
      (merge discrepancy { status: "resolved" })
    ))
  )
)

(define-read-only (get-discrepancy (discrepancy-id uint))
  (map-get? discrepancies { discrepancy-id: discrepancy-id })
)

