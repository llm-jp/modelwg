import json
import sys

from transformers import AutoTokenizer


def update_special_token_settings(tokenizer, model_config: dict):
    assert len(tokenizer) == model_config["vocab_size"], f'Different vocab size definitions: {len(tokenizer)=} and {model_config["vocab_size"]=}'
    new_model_config = dict(model_config)
    for token, id in [
        ("bos_token_id", tokenizer.bos_token_id),
        ("eos_token_id", tokenizer.eos_token_id),
        ("pad_token_id", tokenizer.pad_token_id),
    ]:
        if token not in model_config:
            print(f"no definition: model_config[{token}]", file=sys.stderr)
        elif model_config[token] != id:
            print(f"inconsistent: model_config[{token}]={model_config[token]}", file=sys.stderr)
        else:
            print(f"consistent: model_config[{token}]={model_config[token]}", file=sys.stderr)
            continue
        print(f"update {token}={id}", file=sys.stderr)
        new_model_config[token] = id
    return new_model_config


def main():
    model_dir = sys.argv[1]
    with open(f"{model_dir}/config.json", "r", encoding="utf8") as fin:
        model_config = json.load(fin)
    tokenizer = AutoTokenizer.from_pretrained(f"{model_dir}")
    new_model_config = update_special_token_settings(tokenizer, model_config)
    with open(f"{model_dir}/config.json", "w", encoding="utf8") as fout:
        json.dump(new_model_config, fout, indent=4, ensure_ascii=True)


if __name__ == "__main__":
    main()
