#!/usr/bin/env python
# Author: Ona de Gibert
# This file is used to removes sentences in testsets and validation sets from parallel training sets
# It expects two parallel train files and one or more test sets
# It writes the output in a folder called "clean"

import argparse
import ntpath

def read_files(train,test):
    read_train_list = [] 
    read_test_list = []
    for file in train:
        with open(file) as f:
            read_train = f.readlines()
        read_train_list.append(read_train)
    for file in test:
        with open(file) as f:
            read_test = f.readlines()
        read_test_list.extend(read_test)
    return read_train_list, set(read_test_list)

def clean_train(train, test):
    index = 0
    common_lines_indeces = []
    for line in train[0]:
        if line in test: # if a line in test is contained in the train files, remove it
            common_lines_indeces.append(index)
        index += 1
    print(index)
    for file in train:
        for index in sorted(common_lines_indeces, reverse=True):
            del file[index]
    return(train)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--train", nargs="+", default=['-'],
                        help="expects two parallel train files paths, first one same language as test")
    parser.add_argument("--test", nargs="+", default=['-'],
                        help="test files paths")
    parser.add_argument('--folder', default='clean/', help='folder to save the data')
    
    args = parser.parse_args()
    train_filenames = [ntpath.basename(file) for file in args.train]

    train, test = read_files(args.train, args.test)
    train_raw_lines = len(train[0])
    train_clean = clean_train(train, test)
    train_clean_lines = len(train[0])
    for index in range(2):
        out = open(args.folder + train_filenames[index], 'w')
        for sentence in train_clean[index]:
            out.write(sentence)
        #out.write('\n'.join(train_clean[index]))

    removed_lines = train_raw_lines - train_clean_lines
    print("Removed {} lines for {}".format(removed_lines,train_filenames[0]))


if __name__ == "__main__":
    main()

