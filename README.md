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

### Anima Base v1.0 のみ使う場合

1. [EasyAnimaInstaller.bat](https://github.com/hybskgks28275/EasyAnima/raw/main/EasyAnima/EasyAnimaInstaller.bat?ver=0) を右クリックから保存します。
2. インストール先の **空フォルダ** を `C:/EasyAnima/` や `D:/EasyAnima/` などの浅いパスに用意して、ここに `EasyAnimaInstaller.bat` を移動して実行します。
	- **`発行元を確認できませんでした。このソフトウェアを実行しますか？` と表示されたら `実行` します。**
	- **`WindowsによってPCが保護されました` と表示されたら、`詳細表示` から `実行` します。**
	- **`Microsoft Visual C++ 2015-2022 Redistributable` のインストールで `このアプリがデバイスに変更を加えることを許可しますか？` と表示されたら `はい` とします。**

Anima Base v1.0 だけを使う場合は、`EasyAnimaInstaller.bat` の実行だけで完了です。

### インストール中の pip エラー表示について

インストール中に赤文字で pip の `ERROR` が出力されることがあります。
セットアップが停止せず最後まで進んだ場合は、依存関係の確認や再試行中に表示されたものなので無視して問題ありません。

### All-in-One インストール

全てのサンプル workflow を使いたい場合は、All-in-One インストールを行います。

- 初回インストール時に行う場合は、`EasyAnimaInstaller.bat` の確認メッセージで `y` または `yes` を入力します。
- 後から追加する場合は、インストール済みフォルダの `EasyAnima/AllInOne.bat` を実行します。

All-in-One インストールでは Civitai から Turbo LoRA を取得するため、どちらの方法でも Civitai API Key が必要です。
追加の Anima Base 派生 Checkpoint は `AllInOne.bat` の初回確認メッセージで `y` または `yes` を入力した場合のみダウンロードします。
初回にダウンロードしなかった場合は、以後 `Update.bat` 実行時にも追加の派生 Checkpoint はダウンロードしません。
`AllInOne.bat` の完了後は `AllInOneInstalled.txt` が作成され、以後 `Update.bat` 実行時にも All-in-One の内容を更新します。

`AllInOne.bat` は `Setup-AnimaBaseV10.bat` の内容に加えて、以下を追加します。

- カスタムノード
	- `hybskgks28275/ComfyUI-Anima-NAG`
	- `AdamNizol/ComfyUI-Anima-Enhancer`
	- `Comfy-Org/Nvidia_RTX_Nodes_ComfyUI`
	- `ltdrdata/ComfyUI-Impact-Pack`
	- `ltdrdata/was-node-suite-comfyui`
	- `spacepxl/ComfyUI-Image-Filters`
	- `kohya-ss/ComfyUI-Anima-LLLite`
	- `bugltd/ComfyLab-Pack`
	- `hybskgks28275/ComfyUI-hybs-nodes`
- LoRA
	- `ComfyUI/models/loras/anima-turbo-lora-v0.1.safetensors`
	- Civitai API Key が必要です。
- checkpoint
	- `ComfyUI/models/checkpoints/sam3.1_multiplex_fp16.safetensors`
- optional checkpoint
	- `ComfyUI/models/checkpoints/animayume_v05.safetensors`
	- `ComfyUI/models/checkpoints/copycatAnima_20260519.safetensors`
	- `ComfyUI/models/checkpoints/silvermoonmixAnima_v10.safetensors`
	- `AllInOne.bat` の初回確認メッセージで `y` または `yes` を入力した場合のみダウンロードします。
	- ダウンロードした場合は `AllInOneInstalled.txt` に `ExtraCheckpoints=1` が記録され、以後の `Update.bat` でも更新対象になります。
	- Civitai API Key が必要です。
- ControlNet
	- `ComfyUI/models/controlnet/anima-lllite-any-test-like-v2.safetensors`
	- `ComfyUI/models/controlnet/anima-lllite-inpainting-v2.safetensors`
- workflow
	- `Workflows/*.json` を `ComfyUI/user/default/workflows` にコピーします。
- input
	- `Image/*.png` を `ComfyUI/input` にコピーします。

## 使い方

- `ComfyUi.bat` で起動します。
	- 初回起動時にブラウザキャッシュにある過去のワークフローが開かれ、エラーになる場合があります。エラーを無視してワークフローを閉じてください。
- `Setup-AnimaBaseV10.bat` で ComfyUI の更新と Anima Base v1.0 のモデル配置を行います。
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
- `CN-anytest-like.json`
	- Anima-LLLite の any-test-like モデルを使う ControlNet サンプルです。
	- `ComfyUI-Anima-LLLite`、`anima-lllite-any-test-like-v2.safetensors`、`anytest.png` を使用します。
- `Detailer.json`
	- 読み込んだ画像に対して、マスク作成、SEGS 変換、Detailer 処理を行うサンプルです。
	- `ComfyUI-Impact-Pack`、`ComfyUI-Image-Filters`、SAM 3.1 checkpoint を使用します。
- `Upscale.json`
	- 読み込んだ画像を latent に戻して再生成し、RTX Video Super Resolution で拡大するサンプルです。
	- `Nvidia_RTX_Nodes_ComfyUI` を使用します。
- `XYPlot_CheckPoint.json`
	- Checkpoint を切り替えて比較する XY Plot サンプルです。
	- `ComfyLab-Pack` と `ComfyUI-hybs-nodes` を使用します。
- `XYPlot_LoRA.json`
	- LoRA の条件を切り替えて比較する XY Plot サンプルです。
	- `ComfyLab-Pack` を使用します。
- `XYPlot_Prompt.json`
	- prompt の条件を切り替えて比較する XY Plot サンプルです。
	- `ComfyLab-Pack` を使用します。

## 主な更新

### 2026/05/23

- XY Plot 系のサンプル workflow を追加しました。
	- `XYPlot_CheckPoint.json`
	- `XYPlot_LoRA.json`
	- `XYPlot_Prompt.json`
- All-in-One セットアップに追加カスタムノードを追加しました。
	- `bugltd/ComfyLab-Pack`
	- `hybskgks28275/ComfyUI-hybs-nodes`
- `AllInOne.bat` で確認メッセージに `y` または `yes` を入力した場合のみ、追加の Anima Base 派生 Checkpoint をダウンロードするようにしました。

### 2026/05/21

- `Update.bat` の不具合を修正しました。
	- 日本語メッセージや括弧ブロックで cmd の解釈が崩れる問題を避けるため、更新処理を整理しました。
	- リモートに存在しないローカルブランチ名を掴んだ場合は `main` にフォールバックするようにしました。
- `Update.bat` を All-in-One インストール済み環境に対応しました。
	- `AllInOne.bat` 正常完了時に `AllInOneInstalled.txt` を作成します。
	- `AllInOneInstalled.txt` がある場合、`Update.bat` 実行時に `AllInOne.bat` も実行します。
- サンプル workflow を追加しました。
	- `CN-anytest-like.json`

### 2026/05/16

- `SimpleComfyUi` をフォークし、プロジェクト名を `EasyAnima` に変更して、Anima Base v1.0 の最低生成環境向けに更新しました。
	- Python 3.13 系、PyTorch 2.11.0+cu130、triton-windows 3.6 系を既定にしました。
	- Anima Base v1.0 のモデル配置、最小 workflow、All-in-One セットアップを追加しました。
	- `Update.bat` を `git reset --hard` ではなく fast-forward 更新に変更しました。

## ライセンス

このリポジトリの内容は [MIT License](./LICENSE.txt) です。
別途ライセンスファイルがあるフォルダ以下は、そのライセンスです。
