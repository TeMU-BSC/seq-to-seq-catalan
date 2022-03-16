
with open('final/train.ca') as f:
    cat = f.readlines()

with open('final/train.en') as f:
    eng = f.readlines()

remove_list = []

for i, line in enumerate(cat):
    if len(line.split()) < 1 or len(eng[i].split()) < 1:
        remove_list.append(i)

print(len(remove_list))

for index in sorted(remove_list, reverse=True):
    del cat[index]
    del eng[index]

out = open('final/train.en-ca.en','w')
for sentence in eng:
    out.write(sentence)

out = open('final/train.en-ca.ca','w')
for sentence in cat:
    out.write(sentence)


