#!/bin/bash

# hbv2
run_sweep.sh hbv2_drivaer_s "220 20 32" "30 60 90 120" "1 2 4 8 16" 120 15 hb120rs_v2
run_sweep.sh hbv2_drivaer_m "440 40 64" "30 60 90 120" "1 2 4 8 16" 120 15 hb120rs_v2
run_sweep.sh hbv2_drivaer_l "660 60 96" "30 60 90 120" "1 2 4 8 16" 120 15 hb120rs_v2

# hc
run_sweep.sh hc_drivaer_s "220 20 32" "16 22 32 44" "1 2 4 8 16" 44 2 hc44rs
run_sweep.sh hc_drivaer_m "440 40 64" "16 22 32 44" "1 2 4 8 16" 44 2 hc44rs
run_sweep.sh hc_drivaer_l "660 60 96" "16 22 32 44" "1 2 4 8 16" 44 2 hc44rs
