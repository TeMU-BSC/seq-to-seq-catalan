# CA-EN Machine Translation Model



### Create clean corpus

Dades monolingues: catext_ca/v3/s4 + oscar_en/v1/s5
```
mkdir staged_raw
sbatch staged_data_creation.sh
```

### Tokenize

#### Corpus to train tokenizer

```
mkdir tokenized 
cd tokenized
shuf -n 2000000 /gpfs/projects/bsc88/MT4All/CA-EN/raw/train/train.en > aa
shuf -n 2000000 /gpfs/projects/bsc88/MT4All/CA-EN/raw/train/train.ca > ab
shuf -n 2000000 /gpfs/projects/bsc88/MT4All/CA-EN/raw/train/train.en-ca.en > ac
shuf -n 2000000 /gpfs/projects/bsc88/MT4All/CA-EN/raw/train/train.en-ca.ca > ad
cat aa ab ac ad > tokenizer_corpus.en-ca
rm aa ab ac ad
```

#### Train 
```
sbatch train_tokenizer.sh
```

#### Tokenize

```
sbatch encode-amd.sh
sbatch test-encode-amd.sh
```

### Preprocess: Binarize and Index de data

```
sbatch preprocess-data-0.10.2.sh
sbatch preprocess-test-data-0.10.2.sh
```

### Training




