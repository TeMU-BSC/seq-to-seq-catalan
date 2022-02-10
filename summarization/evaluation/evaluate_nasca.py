# Usage example: python3 evaluate_rouge.py data/gpt_summaries.json 
import argparse
import json
import datasets
from itertools import chain 
import pprint
import numpy as np 
from transformers import pipeline, AutoTokenizer
from datasets import load_metric

DATASET_PATH = "/path/to/vilaweb"
tokenizer = AutoTokenizer.from_pretrained("ELiRF/NASCA")
summarizer = pipeline("summarization", model="ELiRF/NASCA")
rouge = datasets.load_metric('rouge')

XSUM_KWARGS = dict(num_beams=6, length_penalty=1.0, max_length=60, min_length=10, no_repeat_ngram_size=3)
CNN_KWARGS = dict(num_beams=4, length_penalty=2.0, max_length=140, min_length=55, no_repeat_ngram_size=3)

def get_rouge(ground_truths, predictions):
    scores = {'rouge1':0,'rougeL':0}
    rouge_score = rouge.compute(predictions=predictions, references=ground_truths)
    for score in scores:
        val = rouge_score[score].mid
        scores[score] = val
    return scores

def predict(texts):
    predictions = []
    ids = []
    for i, article in enumerate(texts):
        # filter by length for NASCA model 
        if len(tokenizer(article)['input_ids']) > 512:
            continue
        summary = summarizer(article, clean_up_tokenization_spaces=True, **XSUM_KWARGS)[0]['summary_text']
        predictions.append(summary)
        # keep track of final ids used
        ids.append(i)
    return predictions, ids
    
if __name__ == '__main__':
    gt_sum = open(DATASET_PATH+'.sum','r').readlines()
    gt_full = open(DATASET_PATH+'.full','r').readlines()
    predictions, ids = predict(gt_full)
    with open('results/vilaweb_predictions.txt','w') as f1, open('results/vilaweb_ids.txt','w') as f2:
        for line, id in zip(predictions, ids):
            f1.write(line+'\n')
            f2.write(str(id)+'\n')
    results = get_rouge(np.array(gt_sum)[np.array(ids)], np.array(predictions))
    pp = pprint.PrettyPrinter(indent=4)
    pp.pprint(results)
