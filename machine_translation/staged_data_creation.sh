#!/bin/bash

#SBATCH --job-name=data_creation
#SBATCH --output=slurm_logs/data_creation_ca_en_%j.out
#SBATCH --error=slurm_logs/data_creation_ca_en_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=128
#SBATCH --time=2-00:00:00


module load gcc/10.2.0 rocm/4.0.1 intel/2018.4 python/3.7.4
export LD_LIBRARY_PATH=/gpfs/projects/bsc88/projects/bne/eval_amd/slurms/external-lib:$LD_LIBRARY_PATH

source /gpfs/projects/bsc88/projects/bne/eval_amd/env/bin/activate && source /gpfs/projects/bsc88/projects/bne/eval_amd/env-fairseq09/bin/activate

echo $SLURM_JOB_NODELIST

cd staged_raw

mkdir final/

cat /gpfs/projects/bsc88/corpora/global_voices_en-ca/v1/s1/*.ca /gpfs/projects/bsc88/corpora/memories_lliures_en-ca/v2/s1/*.ca /gpfs/projects/bsc88/corpora/wikimatrix_en-ca/v1/s1/*.ca /gpfs/projects/bsc88/corpora/tedtalks_en-ca/v1/s1/*.ca /gpfs/projects/bsc88/corpora/tatoeba_en-ca/v1/s1/*.ca /gpfs/projects/bsc88/corpora/covost_en-ca/v1/s1/covost2.ca-en.ca /gpfs/projects/bsc88/corpora/covost_en-ca/v1/s1/covost2.en-ca.ca /gpfs/projects/bsc88/corpora/europarl_en-ca/v1/s1/*.ca /gpfs/projects/bsc88/corpora/jw300_en-ca/v1/s1/*.ca /gpfs/projects/bsc88/corpora/crawling_gene_en-ca/v1/s5/*.ca /gpfs/projects/bsc88/corpora/opus_books_en-ca/v1/s1/*.ca /gpfs/projects/bsc88/corpora/covid_wikipedia_en-ca/v1/s1/*.ca /gpfs/projects/bsc88/corpora/eubookshop_en-ca/v1/s1/*.ca /gpfs/projects/bsc88/corpora/gnome_en-ca/v1/s1/*.ca /gpfs/projects/bsc88/corpora/kde4_en-ca/v1/s1/*.ca /gpfs/projects/bsc88/corpora/open_subtitles_en-ca/v1/s1/*.ca /gpfs/projects/bsc88/corpora/qed_en-ca/v1/s1/*.ca /gpfs/projects/bsc88/corpora/ubuntu_en-ca/v1/s1/*.ca /gpfs/projects/bsc88/corpora/wikimedia_en-ca/v1/s1/*.ca > all_parallel_en-ca.ca
cat /gpfs/projects/bsc88/corpora/global_voices_en-ca/v1/s1/*.en /gpfs/projects/bsc88/corpora/memories_lliures_en-ca/v2/s1/*.en /gpfs/projects/bsc88/corpora/wikimatrix_en-ca/v1/s1/*.en /gpfs/projects/bsc88/corpora/tedtalks_en-ca/v1/s1/*.en /gpfs/projects/bsc88/corpora/tatoeba_en-ca/v1/s1/*.en /gpfs/projects/bsc88/corpora/covost_en-ca/v1/s1/covost2.ca-en.en /gpfs/projects/bsc88/corpora/covost_en-ca/v1/s1/covost2.en-ca.en /gpfs/projects/bsc88/corpora/europarl_en-ca/v1/s1/*.en /gpfs/projects/bsc88/corpora/jw300_en-ca/v1/s1/*.en /gpfs/projects/bsc88/corpora/crawling_gene_en-ca/v1/s5/*.en /gpfs/projects/bsc88/corpora/opus_books_en-ca/v1/s1/*.en /gpfs/projects/bsc88/corpora/covid_wikipedia_en-ca/v1/s1/*.en /gpfs/projects/bsc88/corpora/eubookshop_en-ca/v1/s1/*.en /gpfs/projects/bsc88/corpora/gnome_en-ca/v1/s1/*.en /gpfs/projects/bsc88/corpora/kde4_en-ca/v1/s1/*.en /gpfs/projects/bsc88/corpora/open_subtitles_en-ca/v1/s1/*.en /gpfs/projects/bsc88/corpora/qed_en-ca/v1/s1/*.en /gpfs/projects/bsc88/corpora/ubuntu_en-ca/v1/s1/*.en /gpfs/projects/bsc88/corpora/wikimedia_en-ca/v1/s1/*.en > all_parallel_en-ca.en
cat /gpfs/projects/bsc88/corpora/united_nations_ca-en/v1/s1/UN_test_en.txt /gpfs/projects/bsc88/corpora/cybersecurity_en_es_ca/v1/s2/test.en /gpfs/projects/bsc88/corpora/wmt19_biomed_en_es_ca/v1/s1/test.en /gpfs/projects/bsc88/corpora/flores_101_multilingual/v1/s1/flores101_dataset/devtest/eng.devtest /gpfs/projects/bsc88/corpora/flores_101_multilingual/v1/s1/flores101_dataset/dev/eng.dev /gpfs/projects/bsc88/corpora/wmt13_news_ca-en-es/v1/s1/newstest2013.en > all_parallel_test.en


mkdir deduplicated

python deduplicate.py

mkdir clean

python clean_train_test_overlap.py --train deduplicated/train.en deduplicated/train.ca --test all_parallel_test.en

cd clean

seq 5477923 | shuf -n 10000 | awk 'NR==FNR{ z[$0]++;next}
{if (FNR in z){ print >FILENAME"_random"}}' - train.*
mv clean/train.ca_random clean/valid.ca
mv clean/train.en_random clean/valid.en

cd ..

python check_length.py --folder clean --out_folder clean --which_data train
python check_length.py --folder clean --out_folder final --which_data valid

python clean_train_test_overlap.py --train clean/train.en clean/train.ca --test final/valid.en final/valid.ca --folder final/

#rm all_parallel_test.en

wc -l final/valid.ca
wc -l final/valid.en
wc -l final/train.en
wc -l final/train.ca


