import os
import sys

from huggingface_hub import HfApi, create_repo

def main():
    converted_ckpt = sys.argv[1]
    repo_name = sys.argv[2]
    branch_name = sys.argv[3]
    try:
        create_repo(repo_name, repo_type="model", private=True)
    except:
        print("repo {repo_name} already exists and will be upload target.")

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
    print(f"{uploaded_count} files were uploaded to {repo_name} {branch_name}")


if __name__ == "__main__":
    main()
