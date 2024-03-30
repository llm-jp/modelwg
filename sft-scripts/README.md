# SFT scripts

## 実行環境

MDXの`llm-jp-nvlink`環境で実行

## Full parameter SFT

Full parameter SFTは以下の設定に固定して行う

```yaml
max_seq_length: 4096   # llama model
global_batch_size: 64  # = per_device_batch_size * num_devices * gradient_accumulation_steps
num_epochs: 5
learning_rate: 2e-5
lr_scheduler: cosine
warmup_ratio: 0.1
dtype: bfloat16
```

datasetは以下の2種類についてそれぞれ行う

- `jaster`: llm-jp-evalで利用するモデル向けのデータセット
- `gpt4-self-inst`: VicunaQAで利用するモデル向けのデータセット

### 7B models

上記の設定に加え、以下の設定で学習

- single node (8 GPUs => `gradient_accumulation_steps` = 8)
- ZeRO-2

### 13B models

上記の設定に加え、以下の設定で学習

- single node (8 GPU => `gradient_accumulation_steps` = 8)
- ZeRO-3
- gradient_checkpointingを有効化

## LoRA SFT

LoRA SFTは以下の設定に固定して行う（基本的な設定はFull parameter SFTと共通、LRのみ2種類用意）

```yaml
max_seq_length: 4096   # llama model
global_batch_size: 64  # = per_device_batch_size * num_devices * gradient_accumulation_steps
num_epochs: 5
learning_rate: [2e-5, 1e-4]
lr_scheduler: cosine
warmup_ratio: 0.1
dtype: bfloat16
```

datasetは以下の2種類についてそれぞれ行う（Full parameter SFTと共通）

- `jaster`: llm-jp-evalで利用するモデル向けのデータセット
- `gpt4-self-inst`: VicunaQAで利用するモデル向けのデータセット

### 7B models

すべてのモデルについてsingle GPUで学習

### 13B models

`jaster`のモデルについてはsingle GPUで学習
`gpt4-self-inst`のモデルについてはメモリ不足によりsingle GPUでは学習ができなかったため、single node (8 GPU) で学習
