# Catalan Summarization Model

### Preprocess

#### Tokenize

```
sh finetuning/tokenize-bpe-bart-ca.sh 

sh finetuning/tokenize-spm-mbart-large-v1.sh
```

#### Binarize and Index de data

```
sh finetuning/preprocess.sh 
```

### Training

#### Generate BART and mBART

```
sh finetuning/generate-bart-ca-ft-catsum.sh

sh finetuning/generate-mbart-large-v1-ft-catsum.sh 

```

#### Fine-tune

```
sh finetuning/finetune-bart-ca.sh 

sh finetuning/finetune-mbart-large-v1.sh

```

### Evaluating

#### NASCA

```
python evulation/evaluate_nasca.py
```

#### Vilasum

```
python evulation/run_rouge.py

```
