# LLM-jp Model-WG working directory

https://github.com/llm-jp/modelwg

## Megatron to Hugging Face Llama2 Model Converter

We're using Megatron to Hugging Face Llama2 converter implemented by Fujii-san.  
https://github.com/rioyokotalab/Megatron-Llama2

### Install

```console
$ ./install_Megatron_Llama2.sh
```

### Conversion

- Input Megatron-LM checkpoint path
  - `/data/checkpoints_7b/model_name/`
  - required files
    - `iter_NNNNNNN/`
    - `latest_checkpointed_iteration.txt`
- Output Hugging Face model path
  - `/model/7B_HF/llm-jp-7b-model-name/`
- Hugging Face tokenizer model path
  - `/model/llm-jp-tokenizer/hf/ver2.2/tokenizer_model/`

Example:
```console
./convert_megatron_to_hf_llama.sh /data/checkpoints_7b/model_name/ /model/7B_HF/llm-jp-7b-model-name/ /model/llm-jp-tokenizer/hf/ver2.2/tokenizer_model/
```

### Upload to HF

```console
$ source Megatron-Llama2/venv/bin/activate
$ python upload_to_hf.py /model/7B_HF/llm-jp-7b-63500step.code10K_en20K_ja30K_ver2.2/ llm-jp/7b-v1.0.1-63500step.code10K_en20K_ja30K_ver2.2 main
```

## Megatron-DeepSpeed to Hugging Face GPT2 converter

### 175B version

#### Install

```console
$ ./install_convert2hf-175b.sh
```

#### Conversion

- Input Megatron-LM checkpoint path
  - `/model/175B/global_step21000/`
- Output Hugging Face model path
  - `/model/175B_HF/llm-jp-175b-21k/`
- Hugging Face tokenizer model path
  - `/model/llm-jp-tokenizer/hf/ver2.2/code20K_en40K_ja60K.ver2.2_hf_fast.b4/`

Example:
```console
$ ./convert_mds-13b_to_hf_gpt2.sh /model/175B/global_step21000/ /model/175B_HF/llm-jp-175b-21k/ /model/llm-jp-tokenizer/hf/ver2.2/code20K_en40K_ja60K.ver2.2_hf_fast.b4/
```

### 13B version

#### Install

```console
$ ./install_convert2hf-13b.sh
```

#### Conversion

- Input Megatron-LM checkpoint path
  - `/model/llmjp0/Megatron-DeepSpeed/outputs/checkpoint/ds_gpt_v101_fattn_nfs_0825-gpt_1.3B_fold00_gpu96_node12_lr2.0e-4_gbs1536_mbs4_nwk8_zero1_pp1/global_step8654/`
- Output Hugging Face model path
  - `/model/13B_HF/llm-jp-13b-v1.0/`
- Hugging Face tokenizer model path
  - `/model/llm-jp-tokenizer/hf/ver2.1/code10k_en20k_ja30k.ver2.1_hf_fast/`

Example:
```console
$ ./convert_mds-13b_to_hf_gpt2.sh /model/llmjp0/Megatron-DeepSpeed/outputs/checkpoint/ds_gpt_v101_fattn_nfs_0825-gpt_1.3B_fold00_gpu96_node12_lr2.0e-4_gbs1536_mbs4_nwk8_zero1_pp1/global_step8654/ /model/13B_HF/llm-jp-13b-v1.0/ /model/llm-jp-tokenizer/hf/ver2.1/code10k_en20k_ja30k.ver2.1_hf_fast/
```

## Supervised Fine-tuning with llm-jp-sft

https://github.com/llm-jp/llm-jp-sft/

Usage in MDX environment:  
https://github.com/llm-jp/llm-jp-sft/blob/main/mdx/README.md

### Install

```console
$ ./install_llm-jp-sft.sh
```

### Enabling venv

```console
$ cd llm-jp-sft/
$ source venv/bin/activate
```

### Single-GPU LoRA SFT

For Llama models:
```console
$ CUDA_VISIBLE_DEVICES=0 mdx/train_peft_single_gpu.sh /model/7B_HF/model_name/ /model/7B_HF/model_name/ dataset/ mdx/dataset_jaster.sh 5 /model/7B_HF/model_name-jaster-lora-all 2 32 --peft_target_model llama-all
$ CUDA_VISIBLE_DEVICES=0 mdx/train_peft_single_gpu.sh /model/7B_HF/model_name/ /model/7B_HF/model_name/ dataset/ mdx/dataset_gpt4_self_inst_ja.sh 5 /model/7B_HF/model_name-self-inst-lora-all 2 32 --peft_target_model llama-all
```

For GPT-2 models:
```console
$ CUDA_VISIBLE_DEVICES=0 mdx/train_peft_single_gpu.sh llm-jp/llm-jp-13b-v1.0 llm-jp/llm-jp-13b-v1.0 dataset/ mdx/dataset_jaster.sh 5 results/llm-jp/llm-jp-13b-v1.0-jaster-lora 1 64
$ CUDA_VISIBLE_DEVICES=0 mdx/train_peft_single_gpu.sh llm-jp/llm-jp-13b-v1.0 llm-jp/llm-jp-13b-v1.0 dataset/ mdx/dataset_gpt4_self_inst_ja.sh 5 results/llm-jp/llm-jp-13b-v1.0-self-inst-lora 1 64
```

### Multi-GPU Full-parameter SFT

```console
$ mdx/train_full_single_node.sh configs/accelerate_config_zero3.yaml /model/7B_HF/model_name/ /model/7B_HF/model_name/ dataset/ mdx/dataset_jaster_ja.sh 3 /model/7B_HF/smodel_name-jaster-full 2 16
$ mdx/train_full_single_node.sh configs/accelerate_config_zero3.yaml /model/7B_HF/model_name/ /model/7B_HF/model_name/ dataset/ mdx/dataset_gpt4_self_inst_ja.sh 3 /model/7B_HF/model_name-self-inst-full 2 16
```

## llm-jp-eval

https://github.com/llm-jp/llm-jp-eval

### Install

```consoles
$ ./install_llm-jp-eval.sh
```

### Enabling venv

```console
$ cd llm-jp-eval/
$ source venv/bin/activate
```

### Single-GPU Evaluation

```console
$ CUDA_VISIBLE_DEVICES=0 python scripts/evaluate_llm.py model.pretrained_model_name_or_path=/model/7B_HF/model_name/ tokenizer.pretrained_model_name_or_path=/model/7B_HF/model_name/ target_dataset=all wandb.run_name=model_name
$ CUDA_VISIBLE_DEVICES=0 python scripts/evaluate_llm.py model.pretrained_model_name_or_path=/model/7B_HF/model_name/ tokenizer.pretrained_model_name_or_path=/model/7B_HF/model_name/ dataset_dir=dataset/tuning/dev target_dataset=gpt4_self_inst_ja wandb.run_name=model_name
```
