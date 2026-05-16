# EasyAnima

[日本語 README](README.md)

[Manual installation](https://github.com/comfyanonymous/ComfyUI?tab=readme-ov-file#manual-install-windows-linux) of [ComfyUI](https://github.com/comfyanonymous/ComfyUI) and [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) using `venv` on Windows PC with NVIDIA graphics card, prepared for minimal [Anima Base v1.0](https://huggingface.co/circlestone-labs/Anima) generation.

`Setup-AnimaBaseV10.bat` places the Anima Base v1.0 model, Qwen3 text encoder, Qwen-Image VAE, and the minimum workflow.

## Acknowledgements And Support

This fork is based on [Zuntan03/SimpleComfyUi](https://github.com/Zuntan03/SimpleComfyUi) and [Zuntan03/EasyTools](https://github.com/Zuntan03/EasyTools). Thanks to zuntan for publishing and maintaining the original repositories.

This fork and the Anima Base v1.0 changes are developed and maintained by hybskgks28275. Please do not contact zuntan for questions, bug reports, or requests related to this fork.

## Main Differences From Portable Package

- Installs `ComfyUI Manager`.
- Uses a Python 3.13 series `venv`.
- Installs PyTorch 2.11.0+cu130, `triton-windows`, and SageAttention.
- Uses `venv` instead of directly using `python_embeded`.

## Installation

1. Right-click and save [EasyAnimaInstaller.bat](https://github.com/hybskgks28275/EasyAnima/raw/main/EasyAnima/EasyAnimaInstaller.bat?ver=0).
2. Prepare an **empty folder** at a shallow path like `C:/EasyAnima/` or `D:/EasyAnima/` as the installation destination, move `EasyAnimaInstaller.bat` here and run it.
	- **If you see `Publisher could not be verified. Do you want to run this software?`, click `Run`.**
	- **If you see `Windows protected your PC`, click `More info` then `Run anyway`.**
	- **If you see `Do you want to allow this app to make changes to your device?` during `Microsoft Visual C++ 2015-2022 Redistributable` installation, click `Yes`.**

## Usage

- Launch Anima with `ComfyUi-Anima.bat`.
	- On first launch, past workflows in browser cache may open and cause errors. Please ignore the errors and close the workflow.
- You can also use `ComfyUi.bat` for the normal launch path.
- Run `Setup-AnimaBaseV10.bat` to update ComfyUI and place the Anima Base v1.0 files.
- Run `AllInOne.bat` to add extra custom nodes, Turbo LoRA, the SAM 3.1 checkpoint, and extra workflows.
- Update with `Update.bat`.
	- `Update.bat` uses `git pull --ff-only` for fast-forward updates.

## Specifications

- `ComfyUi_Activate.bat` opens a console with `venv\Scripts\activate` activated.
- Uses Git if it's in PATH, otherwise installs portable version.
- Uses Python 3.13.x if it's in PATH, otherwise installs portable version.
- ComfyUI and ComfyUI Manager install the latest version released at the time of installation.
	- To change versions, modify the contents of `ComfyUi-Version.txt` and `ComfyUiManager-Version.txt` in `EasyTools/ComfyUi/` to released versions.
	- Deleting `ComfyUi-Version.txt` or `ComfyUiManager-Version.txt` will update to the latest revision of the repository.
- Installs modules to `venv` with `pip`.
	- `torch==2.11.0+cu130`
	- `torchvision==0.26.0+cu130`
	- `torchaudio==2.11.0+cu130`
	- `triton-windows==3.6.0.post26`
	- `sageattention`
		- If installation fails, the base setup continues.
- Places the Anima Base v1.0 model files.
	- `ComfyUI/models/diffusion_models/anima_baseV10.safetensors`
	- `ComfyUI/models/text_encoders/qwen_3_06b_base.safetensors`
	- `ComfyUI/models/vae/qwen_image_vae.safetensors`

## Anima Base v1.0 Initial Test

- The minimum workflow is placed at `ComfyUI/user/default/workflows/AnimaBaseV10.json`.
- The initial test target is `896x1152`, steps `30`, CFG `4`.
- If 8GB VRAM is tight, lower the resolution or batch size.

## All-in-One Setup

`AllInOne.bat` adds the following files on top of `Setup-AnimaBaseV10.bat`.

- Custom nodes
	- `hybskgks28275/ComfyUI-Anima-NAG`
	- `AdamNizol/ComfyUI-Anima-Enhancer`
	- `Comfy-Org/Nvidia_RTX_Nodes_ComfyUI`
	- `ltdrdata/ComfyUI-Impact-Pack`
	- `ltdrdata/was-node-suite-comfyui`
	- `spacepxl/ComfyUI-Image-Filters`
- LoRA
	- `ComfyUI/models/loras/anima-turbo-lora-v0.1.safetensors`
- checkpoint
	- `ComfyUI/models/checkpoints/sam3.1_multiplex_fp16.safetensors`
- workflow
	- Copies `Workflows/*.json` to `ComfyUI/user/default/workflows`.
	- `ComfyUI/user/default/workflows/workflowForSDXLNoobaiXL_animaTurboLoraNAG.zip`
	- The zip is deleted after extraction into the same folder.

## Major Updates

### 2026/05/15

- Forked `SimpleComfyUi`, renamed the project to `EasyAnima`, and updated it for a minimal Anima Base v1.0 generation environment.
	- Changed defaults to Python 3.13 series, PyTorch 2.11.0+cu130, and triton-windows 3.6 series.
	- Added Anima Base v1.0 model placement, the minimum workflow, and the All-in-One setup.
	- Changed `Update.bat` from `git reset --hard` to fast-forward updates.

## License

The contents of this repository are under [MIT License](./LICENSE.txt).
Folders with separate license files follow those licenses.
