sl=de
tl=en

sd='it'
td='emea'
data_dir=${PWD}/dataset/${td}-lex-w2w+${sd}
out_dir=${PWD}/outputs/
dest_dir=$out_dir/data-bin-join/${sd}2${td}/
mkdir -p $dest_dir

fairseq-preprocess --source-lang ${sl} --target-lang $tl \
	--trainpref $data_dir/${td}-w2w-unsup+${sd}-para.train.bpe.clean \
	--validpref $data_dir/${td}-w2w-unsup+${sd}-para.train.bpe.clean \
	--testpref $data_dir/${td}-test.bpe \
	--destdir $dest_dir \
	--srcdict $out_dir/data-bin-join/${sd}/dict.${sl}.txt \
	--tgtdict $out_dir/data-bin-join/${td}/dict.${tl}.txt

