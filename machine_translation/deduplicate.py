
import pandas as pd

with open('all_parallel_en-ca.ca') as f:
    read_train = f.readlines()

with open('all_parallel_en-ca.en') as f:
    read_test = f.readlines()

# LOSES ONE LINE
#read_train = open('corpus/parallel/all_parallel_en-ca.ca', 'r').read().splitlines()
#read_test = open('corpus/parallel/all_parallel_en-ca.en', 'r').read().splitlines()

# LOSES A LOT OF LINES
#df1 = pd.read_csv('corpus/parallel/all_parallel_en-ca.ca', sep=',', names=['cat'], skip_blank_lines=False, nrows=11558183)
#df2 = pd.read_csv('corpus/parallel/all_parallel_en-ca.en', sep=',', names=['eng'], skip_blank_lines=False, nrows=11558183)

print(len(read_train), len(read_test))

df = pd.DataFrame(list(zip(read_train, read_test)),
               columns =['cat', 'eng'])

#df = pd.concat([df1, df2], axis=1)

print(df.head())

print(df.tail())

df_short = df.drop_duplicates(subset=None, keep='first')

print(len(df_short))

#df_short['cat'].to_csv('train.ca', index=False, header=False)
#df_short['eng'].to_csv('train.en', index=False, header=False)

out = open("deduplicated/train.ca", 'w')
for sentence in df_short['cat']:
    out.write(sentence)

out = open("deduplicated/train.en", 'w')
for sentence in df_short['eng']:
    out.write(sentence)