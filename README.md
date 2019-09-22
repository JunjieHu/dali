Domain Adaptation of Neural Machine Translation by Lexicon Induction
===
Implemented by [Junjie Hu](http://www.cs.cmu.edu/~junjieh/)

Contact: junjieh@cs.cmu.edu

If you use the codes in this repo, please cite our [ACL2019 paper](https://www.aclweb.org/anthology/P19-1286).

	@inproceedings{hu-etal-2019-domain,
	    title = "Domain Adaptation of Neural Machine Translation by Lexicon Induction",
	    author = "Hu, Junjie and Xia, Mengzhou and Neubig, Graham and Carbonell, Jaime",
	    booktitle = "Proceedings of the 57th Annual Meeting of the Association for Computational Linguistics",
	    month = jul,
	    year = "2019",
	    address = "Florence, Italy",
	    publisher = "Association for Computational Linguistics",
	    url = "https://www.aclweb.org/anthology/P19-1286",
	    doi = "10.18653/v1/P19-1286",
	    pages = "2989--3001",
	}


Installation
==
- Anaconda environment
```
conda env create --file conda-dali-env.txt
```

- Install fairseq
```
cd fairseq && pip install --editable . && cd ..
```

- Install fastText
```
cd fastText && mkdir build && cd build && cmake .. && make && cd ../..
```

- Download MUSE's dictionary
```
cd MUSE/data/ && bash get_evaluation.sh && cd ../..
```

Downloads
==
The preprocessed data and pre-trained models can be found [here](https://drive.google.com/drive/folders/18KMC9OwXgbopKFlK1SIYvuvBJg7RIM7B?usp=sharing). Extract ***dataset.tar.gz*** under the ***dali*** directory. Extract ***{data-bin, it-de-en-epoch40, it2emea-de-en}.tar.gz*** under the ***dali/outputs*** directory.

- ***dataset.tar.gz***: train/dev/test data in five domains: it, emea, acquis, koran, subtitles.
- ***data-bin.tar.gz***: fairseq's binarized data.
- ***it-de-en-epoch40.tar.gz***: fairseq's transformer model pre-trained on data in the it domain.
- ***it2emea-de-en.tar.gz***: fairseq's transformer model adapted from it domain to emea domain using DALI-U.
- ***S2T+T2S-de-en.lex***: the lexicon induced by DALI-U. 

The pre-trained model in the it domain can obtain the BLEU scores in the five domains as follows. After adaptation, the BLEU in the emea test set can be raised to *18.25* from *8.23*. The BLEU scores are slightly different from those in the paper since we used different NMT toolkits (fairseq v.s. OpenNMT), but we observed similar improvements as we found in the paper.

| Out-of-domain | In-domain                                 |
|               | ----------------------------------------- |
|               | it    | emea | koran | subtitles | acquis | 
| ------------- | ----- | ---- | ----- | --------- | ------ |
| it            | 58.94 | 8.23 | 2.5   | 6.26      | 4.34   |


Demo
==
- Preprocess the data in the source (it) domain
```
bash scripts/preprocess.sh
```

- Train the transformer model in the source (it) domain
```
bash scripts/train.sh [GPU id]
```

- Perform DALI's data augmentation
	1. Train the word embeddings
	```
	bash scripts/train-embed.sh
	```
	2. Train the crosslingual embeddings by supervised lexicon induction
	```
	bash scripts/train-muse.sh [path to supervised seed lexicon]
	```
	3. Train the crosslingual embeddings by unsupervised lexicon induction
	``` 
	bash scripts/train-muse.sh
	```
	3. Obtain the word translation by nearest neighbor search
	```
	python3 extract_lexicon.py \
	  --src_emb $PWD/outputs/unsupervised-muse/debug/v1/vectors-de.txt \
	  --tgt_emb $PWD/outputs/unsupervised-muse/debug/v1/vectors-en.txt \
	  --output $PWD/outputs/unsupervised-muse/debug/v1/S2T+T2S-de-en.lex \
	  --dico_build "S2T&T2S"
	```
	4. Perform word-for-word back-translation
	```
	bash scripts/wfw_backtranslation.sh 
	```	
	

- Preprocess the data in the target (emea) domain 
```
bash scripts/preprocess-da.sh
```

- Adapt the pre-train model to the target (emea) domain
```
bash scripts/train-da-opt.sh
```

- Translate the test1 set in the emea domain
```
bash scripts/translate.sh \
  outputs/it-de-en-epoch40/checkpoint_best.pt \
  outputs/it-de-en-epoch40/decode-test1-best.txt \
  outputs/data-bin-join/it \
  test1
```
