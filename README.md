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
$ CUDA_VISIBLE_DEVICES=0 mdx/train_peft_single_gpu.sh /model/7B_HF/model_name/ /model/7B_HF/model_name/ ./dataset mdx/dataset_gpt4_self_inst_ja.sh 5 /model/7B_HF/model_name-self-inst-lora-all 2 16 --peft_target_model llama-all
```

For GPT-2 models:
```console
$ CUDA_VISIBLE_DEVICES=0 mdx/train_peft_single_gpu.sh llm-jp/llm-jp-13b-v1.0 llm-jp/llm-jp-13b-v1.0 ./dataset mdx/dataset_gpt4_self_inst_ja.sh 5 results/llm-jp/llm-jp-13b-v1.0-self-inst-lora 2 16
```

### Multi-GPU Full-parameter SFT

```console
$ mdx/train_full_single_node.sh configs/accelerate_config_zero3.yaml /model/7B_HF/model_name/ /model/7B_HF/model_name/ ./dataset mdx/dataset_gpt4_self_inst_ja.sh 3 /model/7B_HF/model_name-self-inst-full 2 16
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
```
