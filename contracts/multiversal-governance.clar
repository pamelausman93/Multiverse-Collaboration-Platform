;; Multiversal Governance Contract

(define-data-var next-proposal-id uint u0)

(define-map proposals
  { proposal-id: uint }
  {
    title: (string-ascii 100),
    description: (string-utf8 500),
    votes-for: uint,
    votes-against: uint,
    status: (string-ascii 20)
  }
)

(define-public (create-proposal (title (string-ascii 100)) (description (string-utf8 500)))
  (let
    ((proposal-id (+ (var-get next-proposal-id) u1)))
    (var-set next-proposal-id proposal-id)
    (ok (map-set proposals
      { proposal-id: proposal-id }
      {
        title: title,
        description: description,
        votes-for: u0,
        votes-against: u0,
        status: "active"
      }
    ))
  )
)

(define-public (vote-on-proposal (proposal-id uint) (vote bool))
  (let
    ((proposal (unwrap! (map-get? proposals { proposal-id: proposal-id }) (err u404))))
    (if vote
      (ok (map-set proposals
        { proposal-id: proposal-id }
        (merge proposal { votes-for: (+ (get votes-for proposal) u1) })
      ))
      (ok (map-set proposals
        { proposal-id: proposal-id }
        (merge proposal { votes-against: (+ (get votes-against proposal) u1) })
      ))
    )
  )
)

(define-read-only (get-proposal (proposal-id uint))
  (map-get? proposals { proposal-id: proposal-id })
)

