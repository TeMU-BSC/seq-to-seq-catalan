import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--which_data", default='train',
                    help="expects train, valid or test")
parser.add_argument("--folder", default='clean/',
                    help="expects the file where the data is located")
parser.add_argument("--out_folder", default='final/',
                    help="expects the file where the data should be stored")
parser.add_argument("--lang_pair", default='en-ca',
                    help="language pair separated by -")

args = parser.parse_args()

tgt, src = args.lang_pair.split('-')

with open(args.folder + '/' + args.which_data + '.'+ tgt) as f:
    cat = f.readlines()

with open(args.folder + '/' + args.which_data + '.' + src) as f:
    eng = f.readlines()

remove_list = []

for i, line in enumerate(cat):
    if i % 10000 == 0:
        print(i)
    len_cat_line = len(line.split())
    len_eng_line = len(eng[i].split())
    if len_cat_line < 3 or len_eng_line < 3 or len_cat_line > 75 \
            or len_eng_line > 75 or '>' in line or '<' in line or '\t' in line:
        remove_list.append(i)

print('Removed lines:',len(remove_list))

for index in sorted(remove_list, reverse=True):
    del cat[index]
    del eng[index]

out = open(args.out_folder + '/' + args.which_data + '.'+ src,'w')
for sentence in eng:
    out.write(sentence)

out = open(args.out_folder + '/'+ args.which_data + '.'+ tgt,'w')
for sentence in cat:
    out.write(sentence)


