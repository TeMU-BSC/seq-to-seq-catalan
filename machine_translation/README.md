# CA-EN Machine Translation Model

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

#### Binarize and Index de data

```
sh preprocess-data-0.10.2.sh
sh preprocess-test-data-0.10.2.sh
```

### Training




