export CUDA_VISIBLE_DEVICES=$1  # [GPU id]
sup_dict_path=$2 # [path to supervised seed lexicon], e.g., "$PWD/word-align/mono.fbw.lex"
repo=$PWD

# Install MUSE
muse=$repo/MUSE/
muse_dict=$muse/data/crosslingual/dictionaries/de-en.0-5000.txt
if [ ! -f $muse_dict ]; then
    cd $muse/data/
    bash get_evaluation.sh
    cd $repo
fi 

dir="$repo/data"
src_emb="$repo/embed/all-train.tc.clean.mono.de.vec"
tgt_emb="$repo/embed/all-train.tc.clean.mono.en.vec"


db="S2T|T2S"
if [ -f $sup_dict_path ]; then
    out_dir="$repo/outputs/supervised-muse/"
    mkdir -p $out_dir
    echo "supervised lexicon induction"
    python $muse/supervised.py \
        --src_emb $src_emb \
        --tgt_emb $tgt_emb \
        --emb_dim 512 \
        --dico_train $sup_dict_path \
        --save_dict_path $save_dic \
        --normalize_embeddings center \
        --dico_build $db \
        --exp_path $out_dir \
        --eval_file $muse_dict
else
    out_dir="$repo/outputs/unsupervised-muse/"
    mkdir -p $out_dir
    echo "unsupervised lexicon induction"
    python $muse/unsupervised.py \
        --src_lang de \
        --tgt_lang en \
        --emb_dim 512 \
        --src_emb $src_emb\
        --tgt_emb $tgt_emb \
        --normalize_embeddings center \
        --exp_path $out_dir \
        --n_refinement 5 \
        --dis_most_frequent 0\
        --exp_id v1 \
        --dico_eval $muse_dict
fi

