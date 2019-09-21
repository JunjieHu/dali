
def read_lexicons(lexicon_infile, delimiter=' ', src2tgt=True):
  lexicons = set()
  for line in open(lexicon_infile, 'r'):
    items = tuple(line.strip().split(delimiter))
    if len(items) == 2:
      lex = items if src2tgt else (items[1], items[0])
      lexicons.add(lex)
  print(f'Finish reading {len(lex)} lexicon entries from {file}')
  return lexicons 

def read_text(file, delimiter=' '):
  return [l.strip().split(delimiter) for l in open(file)]

def write_text(sents, file):
  with open(file, 'w') as f:
    for sent in sents:
      f.write(sent + '\n')

def word2word_backtranslate(lexicon_infile, tgt_infile, src_outfile):
  """
  Args: 
    lexicon_infile: path to the input lexicons
    tgt_infile: path to the input target sentences
    src_outfile: path to save the w2w-backtranslated source sentences
  """
  lexicons = read_lexicons(lexicon_infile)
  tgts = read_text(tgt_infile)
  tgt_dict = defaultdict(list)
  for (s, t) in lexicons:
    tgt_dict[t].append(s)

  srcs = []
  cnt = total = 0.0
  for tgt in tgts:
    src = []
    for t in tgt:
      if t in tgt_dict:
        ridx = random.randint(0, len(tgt_dict[t] - 1))
        src.append(tgt_dict[t][ridx])
        cnt += 1
      else:
        src.append(t)
      total += 1
    srcs.append(" ".join(src))
  print(f'Transalte {cnt} out of {total} words ({cnt / total * 100}\%)')

  write_text(srcs, src_outfile)
  return srcs



  
