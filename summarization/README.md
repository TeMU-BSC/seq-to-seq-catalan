# Catalan Summarization Model

### Preprocess

#### Tokenize
The Catalan `bart_base` BART uses BPE tokenizer with a dictionary of 51.2K size whereas the original SentencePiece dictionary of `mbart_large` is 250K. 
```
sh finetuning/tokenize-bpe-bart-ca.sh 
sh finetuning/tokenize-spm-mbart-large-v1.sh
```

#### Binarize and Index the data
```
sh finetuning/preprocess.sh 
```

### Training

#### Fine-tune

Both the Catalan BART and mBART are fine-tuned with a CaSum dataset for approx. 4 epochs. Performance on a validation dataset serves as an indicator for stopping.

```
sh finetuning/finetune-bart-ca.sh 
sh finetuning/finetune-mbart-large-v1.sh
```

### Evaluating

#### Generate BART and mBART summarizations

The following scripts contain the principal parameters that were used for generationg the test summarizations both with the Catalan BART and mBART.
```
sh evaluation/generate-bart-ca-ft-catsum.sh
sh evaluation/generate-mbart-large-v1-ft-catsum.sh 
```

#### Calculating ROUGE from results (BART Ca and mBART)

```
python evulation/run_rouge.py
```

#### Generate and evaluate NASCA summarizations

```
python evulation/evaluate_nasca.py
```