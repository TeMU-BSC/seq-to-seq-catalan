import sentencepiece as spm

# `m.vocab` is just a reference. not used in the segmentation.
spm.SentencePieceTrainer.train('--input=tokenized/tokenizer_corpus.en-ca --model_prefix=tokenized/m --vocab_size=32768 --character_coverage=0.9990 --byte_fallback')

# makes segmenter instance and loads the model file (m.model)
sp = spm.SentencePieceProcessor()
sp.load('tokenized/m.model')

# encode: text => id
print(sp.encode_as_pieces('This is a test'))
print(sp.encode_as_ids('This is a test'))

# decode: id => text
print(sp.decode_pieces(['▁This', '▁is', '▁a', '▁t', 'est']))
print(sp.decode_ids([209, 31, 9, 375, 586]))
