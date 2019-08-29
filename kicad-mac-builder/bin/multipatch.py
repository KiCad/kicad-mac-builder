#!/usr/bin/env python

import sys, subprocess, os, glob

def main():
    patch_args = []
    patches = []
    processing_patch_args = True

    for arg in sys.argv[1:]:
        if arg == "--":
            processing_patch_args = False
            continue
        if processing_patch_args:
            patch_args.append(arg)
        else:
            patches.append(arg)

    print("Patch args:")
    print(patch_args)
    real_patches = []
    for patch in patches:
        real_patches.extend(glob.glob(patch))
    real_patches = sorted(real_patches)
    print("Patches:")
    print(real_patches)

    subprocess.call("pwd")

    for patch in real_patches:
        failed = False
        command = ["patch"] + patch_args + ["<", patch]
        print("Patching with ", ' '.join(command))
        try:
            status = os.system(" ".join(command))
        except OSError as e:
            failed = True
            print("execution failed:", e)

        if status != 0:
            failed = True
            print("patch returned non-zero status code: ", status)

        if not failed:
            print("Patch complete.")
        if failed:
            print("Exiting")
            sys.exit(1)
    print("Patching complete.")

if __name__ == "__main__":
    main()
