! (register-module! ../../../../hyperon-miner)
! (import! &db  hyperon-miner:experiments:data:small-ugly)

; ! (register-module! ../../../experiments)
! (import! &self hyperon-miner:experiments:frequent-pattern-miner:frequent-pattern-miner)
! (import! &self hyperon-miner:experiments:surprisingness:isurp-old)
! (import! &self hyperon-miner:experiments:utils:common-utils)

! (import! &self hyperon-miner:experiments:utils:binomialMetta)
! (import! &self hyperon-miner:experiments:utils:beta-dist)
! (import! &self hyperon-miner:experiments:utils:constants)
! (import! &self hyperon-miner:experiments:utils:TruthValue)
! (import! &self hyperon-miner:experiments:utils:surp-utils)
! (import! &self hyperon-miner:experiments:utils:miner-utils)
! (import! &self hyperon-miner:experiments:utils:gen_partition)
! (import! &self hyperon-miner:experiments:truth-values:est-tv)

; ! (import! &db  experiments:data:ugly_man_sodaDrinker)
! (import! &self hyperon-miner:experiments:pattern-miner:pattern-miner)

! (bind! &kb (new-space))

!(pattern-miner &kb &db 3 0 nisurp-old)
! (match &kb $pattern $pattern )