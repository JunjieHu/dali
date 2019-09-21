export CUDA_VISIBLE_DEVICES=$1
repo=$PWD

# Install MUSE
muse=$repo/MUSE/
# git clone https://github.com/facebookresearch/MUSE.git
# git checkout 16d5183
# cd $muse/data/
# bash get_evaluation.sh
# cd $repo

dir="$repo/data"
src_emb="$repo/embed/all-train.tc.clean.mono.de.vec"
tgt_emb="$repo/embed/all-train.tc.clean.mono.en.vec"

out_dir="$repo/outputs/unsupervised-muse/"
db="S2T|T2S"
mkdir -p $out_dir
# dict_path="$repo/word-align/mono.fbw.lex"
# python $muse/supervised.py \
#     --src_emb $src_emb \
#     --tgt_emb $tgt_emb \
#     --emb_dim 512 \
#     --dico_train $dict_path \
#     --save_dict_path $save_dic \
#     --normalize_embeddings center,renorm \
#     --dico_build $db \
#     --exp_path $out_dir \
#     --eval_file $dev_dict

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
       --dico_eval $muse/data/crosslingual/dictionaries/de-en.0-5000.txt 

