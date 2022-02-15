# Sequence-to-sequence Resources for Catalan

In this work, we introduce sequence-to-sequence language resources for Catalan, a moderately under-resourced language, towards two tasks, namely: Summarization and Machine Translation (MT). We present two new summarization datasets in the domain of newswire. We also introduce a parallel Catalan to English corpus, paired with three different brand new test sets. Finally, we evaluate the data presented with competing state of the art models, and we develop baselines for these tasks using a newly created Catalan BART. We release the resulting resources of this work under open license to encourage the development of language technology in Catalan.

## Materials

We openly release the outcome materials produced in the framework of this publication:
* [BART-base-ca](https://huggingface.co/projecte-aina/bart-base-ca), a BART-based Catalan language model

### Summarization
* [CaSum](https://huggingface.co/datasets/projecte-aina/casum/), a Catalan abstrative summaritzation dataset
* [VilaSum](https://huggingface.co/datasets/projecte-aina/vilasum/), a Catalan abstrative summaritzation testsets
* [BART-base-ca-casum](https://huggingface.co/projecte-aina/bart-base-ca-casum), a Catalan abstractive summarization model

### Machine Translation (soon)
* GEnCaTA, a Catalan-English high quality corpus for MT
* Evaluation Resources for Catalan-English MT

## Citation
If you use any of these resources (datasets or models) in your work, please cite our latest preprint:

```bibtex
@misc{degibert2022sequencetosequence,
      title={Sequence-to-Sequence Resources for Catalan}, 
      author={Ona de Gibert and Ksenia Kharitonova and Blanca Calvo Figueras and Jordi Armengol-Estapé and Maite Melero},
      year={2022},
      eprint={2202.06871},
      archivePrefix={arXiv},
      primaryClass={cs.CL}
}
```

## License
MIT License

Copyright (c) 2020 Text Mining Unit at BSC

