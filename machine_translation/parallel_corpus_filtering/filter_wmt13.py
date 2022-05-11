from importlib.machinery import SourceFileLoader
from transformers import AutoTokenizer, AutoModelForSequenceClassification, pipeline
from datasets import load_dataset
from sklearn.metrics import precision_recall_fscore_support as score
import numpy as np
from time import time
import statistics
import sys
import random
    
PATH = "model/"

def create_not_aligned(source,target):
    index = 0
    target_not_aligned = []
    for line_src in source:
        bag_of_sents = target.copy()
        bag_of_sents.pop(index)
        line_tgt = random.choice(bag_of_sents)
        target_not_aligned.append(line_tgt)
        index += 1
    return target_not_aligned

def load_dataset(source_file,target_file):
    source = open(source_file).read().splitlines()
    target = open(target_file).read().splitlines()

    target_not_aligned = create_not_aligned(source,target)
    full_source = source + source
    full_target = target + target_not_aligned
    data = zip(full_source,full_target)
    scores = ['aligned'] * 3000 + ['not_aligned'] * 3000
    return data, scores

def main():
    source_file = sys.argv[1]
    target_file = sys.argv[2]
    
    print(source_file.replace('.txt','').upper(),'-',target_file.replace('.txt','').upper())
    
    print("Creating synthetic data")
    data, scores = load_dataset(source_file,target_file)

    tokenizer = AutoTokenizer.from_pretrained(PATH)
    model = AutoModelForSequenceClassification.from_pretrained(PATH)
    
    print("Loading pipeline")
    pipe = pipeline("text-classification", model=model, tokenizer=tokenizer, device=0)

    print("Executing pipeline")
    predictions = []
    for source, target in data:
        source = source.replace('\n','')
        target = target.replace('\n','')
        prediction = pipe([(source, target)], max_length=512, truncation=True)
        label = prediction[0]['label']
        predictions.append(label)

    precision, recall, fscore, support = score(scores, predictions, pos_label='aligned',average='binary')
    print('Accuracy: {} / F1: {} / Precision: {} / Recall: {} / '.format(round(sum([1 for x in zip(predictions,scores) if x[0]==x[1]]) / len(predictions),3),
                                                        round(fscore,3),
                                                        round(precision, 3),
                                                        round(recall, 3)))

main()
