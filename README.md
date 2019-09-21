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

- fastText
```
git clone https://github.com/facebookresearch/fastText.git
```
- MUSE
```
git clone https://github.com/facebookresearch/MUSE.git
cd MUSE
git checkout 16d5183
```

- Install fairseq
```
git clone https://github.com/pytorch/fairseq.git
cd fairseq/
git checkout v0.3.0-723-g851c022
```

Downloads
==
The preprocessed data and pre-trained models can be found [here](https://drive.google.com/drive/folders/18KMC9OwXgbopKFlK1SIYvuvBJg7RIM7B?usp=sharing).

- dataset.tar.gz: train/dev/test data in five domains: it, emea, acquis, koran, subtitles.
- data-bin.tar.gz: fairseq's binarized data.
- it-de-en-epoch40.tar.gz: fairseq's transformer model pre-trained on data in the it domain.
- it2emea-de-en.tar.gz: fairseq's transformer model adapted from it domain to emea domain using DALI-U.

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
	2. Train the crosslingual embeddings
	```
	bash scripts/train-muse.sh
	```
	3. Obtain the word translation by nearest neighbor search
	4. Perform word-for-word back-translation

- Preprocess the data in the target (emea) domain 
```
bash scripts/preprocess-da.sh
```

- Adapt the pre-train model to the target (emea) domain
```
bash scripts/train-da-opt.sh
```

