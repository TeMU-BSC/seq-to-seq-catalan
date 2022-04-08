# CA-EN Machine Translation Model

Due to internal reasons we used different versions of `fairseq` during our research, from 0.9.0 to 0.10.2. The later version you use the better, and our final scripts are created having the version 0.10.2 in mind.

### Preprocess

#### Corpus creation

```
sh data_creation.sh
```


#### Train tokenizer
```
python train_tokenizer.py
```

#### Tokenize

```
sh encode-amd.sh
sh test-encode-amd.sh
```

#### Binarize and Index data

The `multilingual_denoising` task requires monolingual data which is preprocessed with the `--only-src` parameters therefore without any indication of the language in the data itself. The language is indicated by the subdirectory name in the principal `data-bin` directory, in our case `ca` and `en`. The binarized parallel data can be put into the main `data-bin` directory. If fine-tuning is done with the `translation_multi_simple_epoch` task we can preprocess the parallel data only in one direction and for the reverse direction use the flag `--enable-reservsed-directions-shared-datasets`.

```
sh training/preprocess-data.sh
```

### Training

#### Pre-train the mBART

Train mBART with the monolingual data of both Catalan and English and `multilingual denoising` task. The languages are sampled equally. We tried both `mbart_base` and `mbart_large` architectures.

```
sh training/train-mbart-large.sh
sh training/train-mbart-base.sh
```

#### Fine-tune the mBART with parallel data

After mBART is pre-trained with the mix of monolingual data, we can fine-tune it with parallel data that is considerably smaller. We tried both `translation_from_pretrained_bart` and `translation_multi_simple_epoch` for fine-tuning, and the second one is fully debugged and vastly superior in performance.


```
sh training/finetune-mbart-base-mtse.sh
```

#### Generate test sets

The following example contains all the main generating parameters that used for all our test sets. 

```
sh training/generate-mbart-ca-en-test-mtse-example.sh
```

### Parallel corpus filtering

#### Fine-tune mBERT

We fine-tune both mBERT-cased and mBERT-uncased to explore the task of parallel corpus filtering with the GEnCaTa dataset. 

```
sh parallel_corpus_filtering/mbertGencata_0_100_0.000008.sh
sh parallel_corpus_filtering/mbertUncasedGencata_0_100_0.000008.sh
```

#### Filter all the datasets

Once we have obtained the best performing model, we filter all other datasets.

```
python parallel_corpus_filtering/filter_by_corpus.py
```





