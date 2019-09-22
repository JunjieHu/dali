#!/bin/bash
sl=de
tl=en

sd="it"
td="emea"

gpu=yes
path=$1       # checkpoint path, e.g., $PWD/outputs/${sd}-${sl}-${tl}-epoch40/checkpoint_best.pt
out_file=$2   # decode file, e.g., $PWD/outputs/${sd}-${sl}-${tl}-epoch40/decode-best-beam5.txt
data_dir=$3   # binarized data folder, e.g., $PWD/datasets/${sd}2${td}/
split=$4      # prefix of test set, e.g., test, test1, test2

if [[ $gpu == yes ]]; then
fairseq-generate \
    $data_dir \
    --source-lang ${sl} --target-lang ${tl} \
    --path $path \
    --beam 5 --lenpen 1.2 \
    --gen-subset $split \
    --batch-size 1 \
    --remove-bpe="@@ " > $out_file
else
fairseq-generate \
    $data_dir \
    --source-lang ${sl} --target-lang ${tl} \
    --path $path \
    --beam 5 --lenpen 1.2 \
    --gen-subset ${split} \
    --remove-bpe="@@ " \
    --batch-size 1 \
    --cpu > $out_file
fi

grep ^H- $out_file | cut -d' ' -f2- > ${out_file}.out 
