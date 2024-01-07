import os
import sys
import tempfile

from huggingface_hub import HfApi, create_repo
from huggingface_hub.utils._errors import BadRequestError, HfHubHTTPError


def main():
    converted_ckpt = sys.argv[1]
    repo_name = sys.argv[2]
    branch_name = sys.argv[3]
    try:
        create_repo(repo_name, repo_type="model", private=True)
    except HfHubHTTPError as e:
        if str(e).startswith("409 Client Error: Conflict for url: "):
            print(f"repo {repo_name} already exists and will be upload target.")
        else:
            raise e

    api = HfApi()
    if branch_name != "main":
        try:
            api.create_branch(
                repo_id=repo_name,
                repo_type="model",
                branch=branch_name,
            )
        except:
            print(f"branch {branch_name} already exists, try again...")
            exit(1)

    print(f"to upload: {converted_ckpt}")
    uploaded_count = 0
    for file in os.listdir(converted_ckpt):
        path_or_file = os.path.join(converted_ckpt, file)
        if not os.path.isfile(path_or_file):
            print(f"skipping {file} ...")
            continue
        print(f"uploading {file} to branch {branch_name} ...")
        retry = False
        while True:
            try:
                api.upload_file(
                    path_or_fileobj=path_or_file,
                    path_in_repo=file,
                    repo_id=repo_name,
                    repo_type="model",
                    commit_message=f"Upload {file}",
                    revision=branch_name,
                )
                print(f"successfully uploaded {file}")
                uploaded_count += 1
                break
            except BadRequestError as e:
                if file == "README.md":
                    temp_path, base_model_line = copy_with_base_model_filter(path_or_file)
                    if temp_path:
                        print(f"{base_model_line} does not exist in Hugging Face hub. Retrying upload README.md with the base_model line removed.", file=sys.stderr)
                        path_or_file = temp_path
                        continue
                raise e
    print(f"{uploaded_count} files were uploaded to {repo_name} {branch_name}")


def copy_with_base_model_filter(path):
    in_model_card = None
    base_model_line = None
    lines = []
    with open(path, "r", encoding="utf8") as fin:
        for _ in fin:
            line = _.rstrip("\r\n")
            if in_model_card and not base_model_line and line.startswith("base_model:"):
                 base_model_line = line
                 continue
            if line == "---":
                if in_model_card is None:
                    in_model_card = True
                elif in_model_card:
                    in_model_card = False
                    if base_model_line:
                        lines.append(line)
                        lines.append("**TODO: Add base_model description in model card section**")
                        lines.append("")
            lines.append(_)
    if base_model_line:
        with tempfile.NamedTemporaryFile(mode="w", delete_on_close=False) as fout:
            print(*lines, sep="\n", file=fout)
        return fout.name, base_model_line
    else:
        return None, None
            

if __name__ == "__main__":
    main()
