#!/bin/bash


for DATASET in 1_ca_en_un.en  2_ca_en_cyber.en  3_ca_en_bio.n   4_ca_en_floresdev.en  5_ca_en_florestest.en  6_ca_en_wmtnews2013.en 1_en_ca_un.ca  2_en_ca_cyber.ca  3_en_ca_bio.ca  4_en_ca_floresdev.ca  5_en_ca_florestest.ca  6_en_ca_wmtnews2013.ca; do

  python spm_encode.py --model tokenized_16/m.model --inputs raw/all_test_sets/$DATASET --outputs tokenized_16/all_test_sets/$DATASET --max-len 512

done;

