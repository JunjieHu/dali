
REPO=$PWD
mosesdecoder="$REPO/mosesdecoder"
dir="$REPO/data"

domain='acquis'
out_dir="$REPO/outputs/moses-${domain}"

mkdir -p "${out_dir}"
cd "${out_dir}"
nohup nice ${mosesdecoder}/scripts/training/train-model.perl -root-dir train \
-corpus ${dir}/${src}-train.tc.clean                  \
-f de -e en -alignment grow-diag-final-and -reordering msd-bidirectional-fe \
-last-step 6  \
-external-bin-dir ${mosesdecoder}/tools >& training.out &	
echo "Training on ${domain}"

cd $REPO

python extract_lexicon_giza.py \
    --s2t_lex_infile $out_dir/lex.f2e \
    --t2s_lex_infile $out_dir/lex.e2f \
    --src_infile $dir/${domain}-train.tc.de.clean \
    --tgt_infile $dir/${domain}-train.tc.en.clean \
    --lex_outfile $out_dir/lex
