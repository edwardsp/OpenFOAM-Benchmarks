#!/bin/bash

# hbv2
run_sweep.sh hbv2_drivaer_s "220 20 32" "30 60 90 120" "1 2 4 8 16" 120 15
run_sweep.sh hbv2_drivaer_s "440 40 64" "30 60 90 120" "1 2 4 8 16" 120 15
run_sweep.sh hbv2_drivaer_s "660 60 96" "30 60 90 120" "1 2 4 8 16" 120 15

# hc
run_sweep.sh hbv2_drivaer_s "220 20 32" "30 60 90 120" "1 2 4 8 16" 44 2
run_sweep.sh hbv2_drivaer_s "440 40 64" "30 60 90 120" "1 2 4 8 16" 44 2
run_sweep.sh hbv2_drivaer_s "660 60 96" "30 60 90 120" "1 2 4 8 16" 44 2

