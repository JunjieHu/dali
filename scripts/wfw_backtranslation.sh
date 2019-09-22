export CUDA_VISIBLE_DEVICES=$1 
sl=de
tl=en

sd='it'
td='emea'

data_dir=${PWD}/dataset/
output_dir=${PWD}/dataset/${td}-lex-w2w+${sd}
mkdir -p $output_dir

for sp in "${td}-train.bpe.clean" "${td}-dev.bpe"; do
    python wfw_backtranslation.py \
        --lexicon_infile ${PWD}/outputs/unsupervised-muse/debug/v1/S2T+T2S-de-en.lex \
        --tgt_infile ${data_dir}/${sp}.en.mono \
        --src_outfile ${output_dir}/${sp}.de.mono
    ln -s ${data_dir}/${sp}.en.mono ${output_dir}/${sp}.en.mono

    num_td=$(< $data_dir/$sp.en.mono wc -l)
    src_sp=${sp/$td/$sd}
    head -n $num_td ${data_dir}/${src_sp}.en > ${output_dir}/${src_sp}.en
    head -n $num_td ${data_dir}/${src_sp}.de > ${output_dir}/${src_sp}.de
    
    cat $output_dir/$sp.en.mono $output_dir/$src_sp.en > $output_dir/${sp/$td/${td}-w2w-unsup+${sd}-para}.en
    cat $output_dir/$sp.de.mono $output_dir/$src_sp.de > $output_dir/${sp/$td/${td}-w2w-unsup+${sd}-para}.de
done