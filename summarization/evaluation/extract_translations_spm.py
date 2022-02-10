from fairseq.data.encoders.sentencepiece_bpe import SentencepieceBPE
from argparse import Namespace

encoder = SentencepieceBPE(args = Namespace(sentencepiece_model='mbart.cc25/sentence.bpe.model'))

results = "results/vilaweb_mbart_large_v1.out"

with open(results, "r") as f:
    lines = f.readlines()
    targets = [encoder.decode(line.split("\t")[1].strip()) for line in lines if line.startswith("T")]
    hyp = [encoder.decode(line.split("\t")[2].strip()) for line in lines if line.startswith("H")]

with open("results/vilaweb_mbart_targets.txt","w") as f1, open("results/vilaweb_mbart_sums.txt", "w") as f2:
    for t, d in zip(targets, hyp):
        f1.write(t + '\n')
        f2.write(d + '\n')
