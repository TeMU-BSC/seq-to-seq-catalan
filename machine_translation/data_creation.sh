#!/bin/bash

cd raw

mkdir train
mkdir valid

cat ccaligned_en-ca/v1/s1/*.ca global_voices_en-ca/v1/s1/*.ca memories_lliures_en-ca/v2/s1/*.ca wikimatrix_en-ca/v1/s1/*.ca tedtalks_en-ca/v1/s1/*.ca tatoeba_en-ca/v1/s1/*.ca covost_en-ca/v1/s1/covost2.ca-en.ca covost_en-ca/v1/s1/covost2.en-ca.ca europarl_en-ca/v1/s1/*.ca jw300_en-ca/v1/s1/*.ca crawling_gene_en-ca/v1/s5/*.ca opus_books_en-ca/v1/s1/*.ca covid_wikipedia_en-ca/v1/s1/*.ca eubookshop_en-ca/v1/s1/*.ca gnome_en-ca/v1/s1/*.ca kde4_en-ca/v1/s1/*.ca open_subtitles_en-ca/v1/s1/*.ca qed_en-ca/v1/s1/*.ca ubuntu_en-ca/v1/s1/*.ca wikimedia_en-ca/v1/s1/*.ca > all_parallel_en-ca.ca
cat ccaligned_en-ca/v1/s1/*.en global_voices_en-ca/v1/s1/*.en memories_lliures_en-ca/v2/s1/*.en wikimatrix_en-ca/v1/s1/*.en tedtalks_en-ca/v1/s1/*.en tatoeba_en-ca/v1/s1/*.en covost_en-ca/v1/s1/covost2.ca-en.en covost_en-ca/v1/s1/covost2.en-ca.en europarl_en-ca/v1/s1/*.en jw300_en-ca/v1/s1/*.en crawling_gene_en-ca/v1/s5/*.en opus_books_en-ca/v1/s1/*.en covid_wikipedia_en-ca/v1/s1/*.en eubookshop_en-ca/v1/s1/*.en gnome_en-ca/v1/s1/*.en kde4_en-ca/v1/s1/*.en open_subtitles_en-ca/v1/s1/*.en qed_en-ca/v1/s1/*.en ubuntu_en-ca/v1/s1/*.en wikimedia_en-ca/v1/s1/*.en > all_parallel_en-ca.en

wc -l all_parallel_en-ca.ca
wc -l all_parallel_en-ca.en

mkdir deduplicated

python deduplicate.py

mkdir clean

python clean_train_test_overlap.py --train deduplicated/train.en deduplicated/train.ca --test all_parallel_test.en

cd clean

seq 5477923 | shuf -n 10000 | awk 'NR==FNR{ z[$0]++;next}
{if (FNR in z){ print >FILENAME"_random"}}' - train.*

cd ..

mkdir final

python check_length.py --folder raw --out_folder raw --which_data train
python check_length.py --folder clean --out_folder final --which_data valid 

python clean_train_test_overlap.py --train clean/train.en clean/train.ca --test final/valid/valid.en final/valid/valid.ca --folder final/

python check_minimum_length_tokens.py

rm all_parallel_test.en

wc -l final/valid.ca
wc -l final/valid.en

echo "done"

