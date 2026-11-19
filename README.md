# Otoscopy image classification with synthetic augmentation

Research code associated with **StyleGAN-based synthetic image augmentation for multi-class otoscopy image classification**, Seda Camalan, Carl D. Langefeld, Amy Zinnia, Aaron C. Moberly and Metin N. Gurcan, *Scientific Reports* (2026).

Paper: https://doi.org/10.1038/s41598-026-56954-z

## Status and provenance

This repository collects existing research scripts from the author's `Autoscope_2/Codes` workspace. Source files are preserved byte-for-byte; only this README, `.gitignore`, and `SOURCE_MANIFEST.json` were added for this collection. The manifest records original relative locations and SHA-256 hashes.

This is an archival collection of related experiments, **not a verified final publication release or a turnkey reproduction**. Training has not been rerun. Scripts contain historical absolute filesystem paths that must be adjusted before use. Helper scripts can copy or write files; inspect their destinations before running them.

## Layout

```text
code/
  Transfer_learning_for_multiclass/  MATLAB classification experiments
    pytorch_code/                  Supplementary Python classification code
  general_purpose/                 Image preparation and augmentation helpers
  DatasetGAN/
    stylegan3/                     NVIDIA StyleGAN repository used in local experiments
    stylegan2-ada-pytorch/          Related StyleGAN2-ADA code
SOURCE_MANIFEST.json                Source-file provenance and integrity hashes
```

Git history, caches, notebooks, autosaves, images, datasets, checkpoints, binary results and manuscript drafts are not included.

## Classification experiments

The principal MATLAB scripts are in `code/Transfer_learning_for_multiclass/`:

| Script | Intended experiment |
|---|---|
| `Classify_segmentedTM_resnet101_gpu_cmp_wo_aug_4cls.m` | Composite images without augmentation |
| `Classify_segmentedTM_resnet101_gpu_cmp_with_aug_4cls.m` | Classical augmentation |
| `Classify_segmentedTM_resnet101_gpu_com_synt_4cls.m` | Composite/synthetic experiment; inspect split logic and destination |
| `Classify_segmentedTM_resnet101_gpu_com_Train_synt_4cls.m` | Synthetic images in training |
| `Classify_segmentedTM_resnet101_gpu_com_Train_Val_synt_4cls.m` | Synthetic images in training and validation |

Other scripts retain earlier two-class, still-image and Inception experiments. Some output destinations overlap; filenames alone do not establish which script produced a published result.

### Environment and starting point

The paper reports MATLAB R2020a with Deep Learning Toolbox and a GPU. Install the ResNet-101 support package and Parallel Computing Toolbox as required by the GPU calls. The GAN environment is specified in `code/DatasetGAN/stylegan3/environment.yml` (Python 3.8+, PyTorch 1.9.1 and CUDA toolkit 11.1); consult the bundled upstream README for platform and GPU requirements. These historical dependencies have not been tested on current environments.

For a classification run:

1. Obtain the approved image data separately.
2. Open a copy of the selected MATLAB script and configure `location` and `destination` for your system. Create a distinct output directory for each experiment.
3. Add the classification directory to the MATLAB path so `freezeWeights.m` and `createLgraphUsingConnections.m` can be resolved.
4. Inspect the filename-based case grouping, fold construction, augmentation settings and output names before executing the script.

For GAN training, inspect `code/DatasetGAN/stylegan3/myreadme.txt`, `train.py`, `dataset_tool.py` and `gen_images.py`. The historical commands refer to external training ZIPs; they are records of previous experiments, not commands validated for immediate execution.

## Data and saved results (not uploaded)

The four diagnostic classes are **Effusion, Normal, Perforation and Tympanosclerosis**. Data remain outside GitHub. Under the original `Autoscope_2` workspace:

| Relative location | Contents |
|---|---|
| `Dataset_for_transfer_learning/Composite/` | 815 composite files: 249 Effusion, 340 Normal, 113 Perforation, 113 Tympanosclerosis |
| `Dataset_for_transfer_learning/Composite_four_with_Synthetic/` | 1,631 composite and synthetic files |
| `Dataset_for_transfer_learning/Still/` | Supplementary still-image experiments |
| `Dataset_for_transfer_learning/Still_four_with_Synthetic/` | Supplementary still and synthetic experiments |
| `Codes/DatasetGAN/stylegan2-ada-pytorch/dataset/` | GAN training ZIPs, including `effusion_gan.zip`, `normal_gan.zip`, `perforation_gan.zip`, `tympano_gan.zip` |
| `Codes/DatasetGAN/stylegan3/training-runs/` | GAN checkpoints, run configurations, logs and preview images |
| `Codes/Transfer_learning_for_multiclass/Results/com_4cls/` | Classification models, fold files and accuracy/confusion-matrix results |

The four class-specific GAN ZIPs total approximately 368 GB (decimal). Obtain access and the current storage location from the project maintainers. No image filenames or clinical records are included in the source manifest.

The classical-augmentation dataset referenced by scripts at `binol/Projects/Eardrum/datasets/alpha_composites_2_thr_multi_rfn_v4_aug/` has been deleted, as confirmed by the workspace owner. This repository does not restore it.

## Known differences from the paper

- The paper describes StyleGAN3, but retained training instructions use `--cfg=stylegan2`. An inspected tympanosclerosis run configuration explicitly names `training.networks_stylegan2.Generator`. A folder named `stylegan3` does not establish the architecture of a particular trained model.
- The paper reports 816 composite images; the inspected directory contains 815, with 249 rather than 250 Effusion images.
- The paper reports 10 classification epochs; inspected MATLAB scripts specify 100.
- Existing scripts and saved results represent multiple experiments. Final publication provenance and exact fold assignments require further reconciliation.

## Licensing

The bundled NVIDIA implementations retain their original license files and notices. Consult `code/DatasetGAN/stylegan3/LICENSE.txt` and `code/DatasetGAN/stylegan2-ada-pytorch/LICENSE.txt` before use. No new license is asserted for the original project-specific research scripts; contact the authors for reuse permission. The paper's license should not be assumed to license the code.
