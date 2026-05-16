# EasyAnima

[English README](README_en.md)

NVIDIA ビデオカードを搭載した Windows PC で [ComfyUI](https://github.com/comfyanonymous/ComfyUI) と [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager) を `venv` で [マニュアルインストール](https://github.com/comfyanonymous/ComfyUI?tab=readme-ov-file#manual-install-windows-linux) し、[Anima Base v1.0](https://huggingface.co/circlestone-labs/Anima) を最低限生成できる状態にします。

`Setup-AnimaBaseV10.bat` で Anima Base v1.0 のモデル、Qwen3 text encoder、Qwen-Image VAE、最小 workflow を配置します。

## 謝辞と問い合わせについて

この fork は [Zuntan03/SimpleComfyUi](https://github.com/Zuntan03/SimpleComfyUi) と [Zuntan03/EasyTools](https://github.com/Zuntan03/EasyTools) を元にしています。元リポジトリを公開・保守されている zuntan 氏に感謝します。

この fork および Anima Base v1.0 向けの変更は hybskgks28275 が開発・保守しています。この fork 版に関する質問、不具合報告、要望を zuntan 氏へ問い合わせないでください。

## Portable Package との主な違い

- `ComfyUI Manager` をインストールします。
- Python 3.13 系の `venv` を利用します。
- PyTorch 2.11.0+cu130、`triton-windows`、SageAttention を導入します。
- `python_embeded` 直接でなく `venv` 経由で利用します。

## インストール方法

1. [EasyAnimaInstaller.bat](https://github.com/hybskgks28275/EasyAnima/raw/main/EasyAnima/EasyAnimaInstaller.bat?ver=0) を右クリックから保存します。
2. インストール先の **空フォルダ** を `C:/EasyAnima/` や `D:/EasyAnima/` などの浅いパスに用意して、ここに `EasyAnimaInstaller.bat` を移動して実行します。
	- **`発行元を確認できませんでした。このソフトウェアを実行しますか？` と表示されたら `実行` します。**
	- **`WindowsによってPCが保護されました` と表示されたら、`詳細表示` から `実行` します。**
	- **`Microsoft Visual C++ 2015-2022 Redistributable` のインストールで `このアプリがデバイスに変更を加えることを許可しますか？` と表示されたら `はい` とします。**

## 使い方

- `ComfyUi-Anima.bat` で Anima 向けに起動します。
	- 初回起動時にブラウザキャッシュにある過去のワークフローが開かれ、エラーになる場合があります。エラーを無視してワークフローを閉じてください。
- `ComfyUi.bat` でも通常起動できます。
- `Setup-AnimaBaseV10.bat` で ComfyUI の更新と Anima Base v1.0 のモデル配置を行います。
- `AllInOne.bat` で追加カスタムノード、Turbo LoRA、SAM 3.1 checkpoint、追加 workflow を配置します。
- `Update.bat` で更新します。
	- `Update.bat` は `git pull --ff-only` で fast-forward 更新します。

## 仕様

- `ComfyUi_Activate.bat` で `venv\Scripts\activate` したコンソールを開きます。
- Git にパスが通っていれば利用し、無ければポータブル版をインストールします。
- Python は 3.13.x にパスが通っていれば利用し、無ければポータブル版をインストールします。
- ComfyUI と ComfyUI Manager は、インストール時にリリースされている最新バージョンをインストールします。
	- バージョンを変更したい場合は `EasyTools/ComfyUi/` にある `ComfyUi-Version.txt` と `ComfyUiManager-Version.txt` の内容をリリース済みバージョンに変更してください。
	- `ComfyUi-Version.txt` や `ComfyUiManager-Version.txt` を削除すると、リポジトリの最新リビジョンに更新します。
- `pip` で `venv` に各種モジュールをインストールします。
	- `torch==2.11.0+cu130`
	- `torchvision==0.26.0+cu130`
	- `torchaudio==2.11.0+cu130`
	- `triton-windows==3.6.0.post26`
	- `sageattention`
		- インストールに失敗しても、基本セットアップは続行します。
- Anima Base v1.0 のモデルファイルを配置します。
	- `ComfyUI/models/diffusion_models/anima_baseV10.safetensors`
	- `ComfyUI/models/text_encoders/qwen_3_06b_base.safetensors`
	- `ComfyUI/models/vae/qwen_image_vae.safetensors`

## Anima Base v1.0 の初期検証

- 最小 workflow は `ComfyUI/user/default/workflows/AnimaBaseV10.json` に配置されます。
- 初期検証は `896x1152`, steps `30`, CFG `4` を想定しています。
- 8GB VRAM で重い場合は、解像度や batch size を下げてください。

## サンプル workflow

- `AnimaBaseV10.json`
	- Anima Base v1.0 の最小生成 workflow です。
	- `896x1152`, steps `30`, CFG `4` の初期検証向けです。
- `AnimaTurboLoRAwithNAG.json`
	- Anima Turbo LoRA と NAG を使った高速生成向け workflow です。
	- `ComfyUI-Anima-NAG`、`ComfyUI-Anima-Enhancer`、`anima-turbo-lora-v0.1.safetensors` を使用します。
- `Detailer.json`
	- 読み込んだ画像に対して、マスク作成、SEGS 変換、Detailer 処理を行うサンプルです。
	- `ComfyUI-Impact-Pack`、`ComfyUI-Image-Filters`、SAM 3.1 checkpoint を使用します。
- `Upscale.json`
	- 読み込んだ画像を latent に戻して再生成し、RTX Video Super Resolution で拡大するサンプルです。
	- `Nvidia_RTX_Nodes_ComfyUI` を使用します。

## All-in-One セットアップ

`AllInOne.bat` は `Setup-AnimaBaseV10.bat` の内容に加えて、以下を追加します。

- カスタムノード
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
	- `Workflows/*.json` を `ComfyUI/user/default/workflows` にコピーします。

## 主な更新

### 2026/05/16

- `SimpleComfyUi` をフォークし、プロジェクト名を `EasyAnima` に変更して、Anima Base v1.0 の最低生成環境向けに更新しました。
	- Python 3.13 系、PyTorch 2.11.0+cu130、triton-windows 3.6 系を既定にしました。
	- Anima Base v1.0 のモデル配置、最小 workflow、All-in-One セットアップを追加しました。
	- `Update.bat` を `git reset --hard` ではなく fast-forward 更新に変更しました。

## ライセンス

このリポジトリの内容は [MIT License](./LICENSE.txt) です。
別途ライセンスファイルがあるフォルダ以下は、そのライセンスです。
