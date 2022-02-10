from datasets import load_metric
import sys

metric = load_metric("rouge")

with open("results/vilaweb_bart_ca_targets.txt", "r") as f1, open("results/vilaweb_bart_ca_sums.txt", "r") as f2:
    refs = [line.strip() for line in f1.readlines()]
    preds = [line.strip() for line in f2.readlines()]

results = metric.compute(predictions=preds, references=refs)

with open("results/vilaweb_bart_ca_rouge.txt", "w") as f:
    sys.stdout = f
    for k in results:
        print(k)
        print(results[k])
        print("***************************************")
