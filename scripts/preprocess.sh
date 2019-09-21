sl=de
tl=en

d='it'
repo=$PWD
data_dir=$repo/dataset/
out_dir=$repo/outputs/
mkdir -p $out_dir/data-bin-join/${d}

fairseq-preprocess --source-lang ${sl} --target-lang $tl \
	--trainpref $data_dir/${d}-train.bpe.clean \
	--validpref $data_dir/${d}-dev.bpe \
	--testpref $data_dir/${d}-test.bpe,$data_dir/emea-test.bpe,$data_dir/koran-test.bpe,$data_dir/subtitles-test.bpe,$data_dir/acquis-test.bpe \
	--destdir $out_dir/data-bin-join/${d}/ \
	--srcdict $out_dir/data-bin-join/${d}/dict.${sl}.txt \
	--tgtdict $out_dir/data-bin-join/${d}/dict.${tl}.txt

