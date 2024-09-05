#!/bin/bash

# Initialize tmpEsttv.metta with the register-module command
cat ! (register-module! ../../../hyperon-miner) >> tmpEsttv.metta
cat ! (import! &self hyperon-miner:experiments:utils:common-utils) >> tmpEsttv.metta


# Append import commands
cat ! (import! &db hyperon-miner:data:sample) >> tmpEsttv.metta
cat ! (import! &self hyperon-miner:experiments:rules:est-tv) >> tmpEsttv.metta

# Append additional content from est-tv.metta


# Debug: Show the content of &db and est_tv
echo "! (show &db)" >> tmpEsttv.metta
echo "! (show (est_tv))" >> tmpEsttv.metta

# Add initialization and execution commands at the bottom
cat <<EOF >> tmpEsttv.metta
!  (est_tv &db (,(Inheritance x y) (Inheritance w y) (Inheritance x z) (Inheritance x o)))
! (match &db (Inheritance $x $y) ($x $y))
EOF 

# Execute the metta command and time the execution, saving the result
time metta tmpEsttv.metta > est-tv-result.metta
