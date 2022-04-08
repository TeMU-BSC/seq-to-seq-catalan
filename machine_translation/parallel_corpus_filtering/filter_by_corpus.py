from transformers import AutoTokenizer, AutoModelForSequenceClassification, pipeline
from datasets import load_dataset
from sklearn.metrics import precision_recall_fscore_support as score
import numpy as np
from time import time
import statistics
import sys
    
PATH = "best_model/"

def return_stats(level,list):
    mean = str(round(statistics.mean(list),2))
    mins = str(min(list))
    maxs = str(max(list))
    #mode = str(round(statistics.mode(list),2))
    median = str(round(statistics.median(list),2))
    return "\t".join([level,mean,mins,maxs,median])

def load_dataset(en,ca):
    en = open(en).readlines()
    ca = open(ca).readlines()
    data = zip(ca,en)
    #data = zip(ca[140000:], en[140000:])
    return data

def main():
    name = sys.argv[1]
    ca = sys.argv[2]
    en = sys.argv[3]

    t = time()
    tokenizer = AutoTokenizer.from_pretrained(PATH)
    model = AutoModelForSequenceClassification.from_pretrained(PATH)
    
    print("Loading pipeline")
    pipe = pipeline("text-classification", model=model, tokenizer=tokenizer, device=0)

    print("Loading parallel data")
    data = load_dataset(en,ca)

    out_clean_ca = open('out/'+name+'_clean.ca','w')
    out_clean_en = open('out/'+name+'_clean.en','w')
    
    out_dirty_ca = open('out/'+name+'_dirty.ca','w')
    out_dirty_en = open('out/'+name+'_dirty.en','w')

    out_stats = open('out/'+name+'_stats.txt','w')
    print("Executing pipeline")
    all_clean = []
    all_dirty = []
    count = 0
    for ca, en in data:
        ca = ca.replace('\n','')
        en = en.replace('\n','')
        prediction = pipe([(ca, en)], max_length=512, truncation=True)
        label = prediction[0]['label']
        avg_len = (len(ca.split())+len(en.split()))/2
        if label == 'aligned':
            out_clean_ca.write(ca+'\n')
            out_clean_en.write(en+'\n')
            all_clean.append(avg_len)
        else:
            out_dirty_ca.write(ca+'\n')
            out_dirty_en.write(en+'\n')
            all_dirty.append(avg_len)
        if count % 10000 == 0: #to count progress
            out_stats.write(" ".join(["Processed samples:",str(count)])+"\n")
            out_stats.write(" ".join(["Aligned:",str(len(all_clean))])+"\n")
            out_stats.write(" ".join(["Not aligned:",str(len(all_dirty))])+"\n")
            out_stats.write(" ".join(["Time passed: {} mins".format(round((time() - t) / 60, 2))])+"\n")
        count +=1

    perc_clean = len(all_clean)*100/(len(all_clean)+len(all_dirty))
    perc_dirty = len(all_dirty)*100/(len(all_clean)+len(all_dirty))

    out_stats.write(" ".join(["Clean samples:",str(len(all_clean)),str(perc_clean)])+"\n")
    out_stats.write("Level\tMean\tMin\tMax\tMedian\n")
    out_stats.write(return_stats("Words",all_clean)+"\n")

    out_stats.write(" ".join(["Dirty samples:",str(len(all_dirty)),str(perc_dirty)])+"\n")
    out_stats.write("Level\tMean\tMin\tMax\tMedian\n")
    out_stats.write(return_stats("Words",all_dirty)+"\n")

main()
