#!/bin/bash

# Add this code at the top
echo "! (register-module! ../../../hyperon-miner)" > tmpEmptv.metta


cat ../../utils/MinerUtils.metta ../../match/MinerMatch.metta ../rules/emp-tv.metta >> tmpEmptv.metta


# Add this code at the bottom
cat <<EOF >> tmpEmptv.metta

! (init-miner \$database 5 10)
!(test-emp-tv)
! (emp-tv (Inheritance Nil Nil) (\$database))
EOF

time metta tmpEmptv.metta > emp-tv-result.metta