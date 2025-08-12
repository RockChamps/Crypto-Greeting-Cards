(define-non-fungible-token greeting-card uint)

;; Storage: maps token ID to greeting message
(define-map card-messages uint (string-ascii 200))

;; Function 1: Mint a greeting card NFT with message
(define-public (mint-card (token-id uint) (recipient principal) (message (string-ascii 200)))
  (begin
    (asserts! (> token-id u0) (err u100)) ;; invalid ID
    (asserts! (is-none (nft-get-owner? greeting-card token-id)) (err u101)) ;; already exists
    (try! (nft-mint? greeting-card token-id recipient))
    (map-set card-messages token-id message)
    (ok {id: token-id, to: recipient, msg: message})
  )
)

;; Function 2: View greeting card details
(define-read-only (get-card (token-id uint))
  (let (
        (owner (nft-get-owner? greeting-card token-id))
        (message (map-get? card-messages token-id))
       )
    (ok {owner: owner, message: message})
  )
)
