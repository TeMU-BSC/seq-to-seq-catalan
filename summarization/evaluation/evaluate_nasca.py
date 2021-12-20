# Usage example: python3 evaluate_rouge.py data/gpt_summaries.json 
import argparse
import json
import datasets
from itertools import chain 
import pprint
import numpy as np 
from transformers import pipeline

DATASET_PATH = 'data/casum_test'
tokenizer = AutoTokenizer.from_pretrained("ELiRF/NASCA")
summarizer = pipeline("summarization", model="ELiRF/NASCA")
rouge = datasets.load_metric('rouge')

def get_rouge(ground_truths,predictions):
    scores = {'rouge1':'','rougeL':''}
    for score in scores.keys():
        rouge_score = rouge.compute(predictions=predictions, references=ground_truths)
        rouge_score = rouge_score['rouge1'].mid
        rouge_score = [round(score,3) for score in rouge_score]
        scores[score] = rouge_score
    return scores

def predict(texts):
    predictions = []
    for article in texts:
        #TODO filter by length
        #if len(tokenizer(article)['input_ids']) > 1000:
            #filter by lenght ---> what lenght?
        summary = summarizer(article, max_length=50, min_length=5, clean_up_tokenization_spaces=True)[0]['summary_text']
        predictions.append(summary)
    return predictions
    
if __name__ == '__main__':
    gt_sum = open(DATASET_PATH+'.sum','r').readlines()
    gt_full = open(DATASET_PATH+'.full','r').readlines()
    predictions = predict(gt_full)
    with open('output/predictions.txt','w'):
        for line in predictions:
            print(line+'\n')
    results = get_rouge(gt_sum,predictions)
    pp = pprint.PrettyPrinter(indent=4)
    pp.pprint(results)