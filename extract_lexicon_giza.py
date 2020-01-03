import argparse
from collections import defaultdict, Counter
import numpy as np
import sys

def read_lex(file, lex, s2t):
    punc = set(["?", ",", ".", "!", "$", "%", "^", "&", "*", "@", "~", "`" "-", "+", "_", "=", "{", "}", "[", "]", "<", ">", "/", "'", '"', "(", ")", ":", ";" ])
    for l in open(file):
        items = l.strip().split(' ')
        if len(items) != 3:
            print('Skip line={} with length={}'.format(l.strip(), len(items)))
            continue
        s = items[0].strip()
        t = items[1].strip()
        p = 1 if len(items) == 2 else float(items[2])
        if len(s) == 0 or len(t) == 0:
            continue
        if (s in punc or t in punc) and s != t:
            continue
        if s2t:
            lex[(s,t)].append(p)
        else:
            lex[(t,s)].append(p)
    return lex

def extract_lexicon(s2t_lex_infile, t2s_lex_infile, src_infile, tgt_infile, lex_outfile, filter_low_prob=False):
    # Read giza++ lexicons from both directions
    lex = defaultdict(list)
    lex = read_lex(s2t_lex_infile, lex, s2t=True)
    lex = read_lex(t2s_lex_infile, lex, s2t=False)
    comb_lex = {k: float(np.mean(v)) for k,v in lex.items()}
    print('No. of lex', len(comb_lex))

    # filter low-probability lexicion
    if filter_low_prob:
        mean_prob = float(np.mean(comb_lex.values()))
        print('Filter lexicions with prob < {}'.format(mean_prob * 0.05))
        comb_lex = {k:v for k,v in comb_lex.items() if v < mean_prob * 0.05}
        print('No. of lex', len(comb_lex))

    # read parallel text
    src_sents = [l.strip().split(' ') for l in open(src_infile)]
    tgt_sents = [l.strip().split(' ') for l in open(tgt_infile)]
    cnt_lex = Counter()
    for src, tgt in zip(src_sents, tgt_sents):
        for sw in src:
            for tw in tgt:
                pair = (sw, tw)
                if pair in comb_lex:
                    cnt_lex[pair] += 1
    print('Count {} lexicons in {}/{}'.format(len(cnt_lex.values()), src_infile, tgt_infile))

    final_lex = {}
    src_words, tgt_words = set(), set()
    with open(lex_outfile, 'w') as writer:
        for (sw, tw), cnt in cnt_lex.most_common():
            if sw not in src_words and tw not in tgt_words:
                final_lex[(sw, tw)] = cnt
                writer.write('{}\t{}\t{}\n'.format(sw, tw, cnt))
            src_words.add(sw)
            tgt_words.add(tw)
    print('No. of extracted lex', len(final_lex))
    return final_lex

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='GIZA++ lexicon extraction')
    parser.add_argument("--s2t_lex_infile", type=str, default="", help="giza++ source to target lexicon input file")
    parser.add_argument("--t2s_lex_infile", type=str, default="", help="giza++ target to source lexicon input file")
    parser.add_argument("--src_infile", type=str, default="", help="parallel source input file")
    parser.add_argument("--tgt_infile", type=str, default="", help="parallel target input file")
    parser.add_argument("--lex_outfile", type=str, default="", help="giza++ lexicon file")
    parser.add_argument("--filter_low_prob", action='store_true', help="whether to filter lexicons with low probability")
    args = parser.parse_args()

    extract_lexicon(args.s2t_lex_infile, args.t2s_lex_infile, args.src_infile, args.tgt_infile, args.lex_outfile, args.filter_low_prob)


