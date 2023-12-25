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
python upload_to_hf.py /model/7B_HF/llm-jp-7b-63500step.code10K_en20K_ja30K_ver2.2/ llm-jp/7b-v1.0.1-63500step.code10K_en20K_ja30K_ver2.2 main
```