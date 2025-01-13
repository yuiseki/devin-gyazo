# devin-gyazo

Devinがスクリーンショットを簡単にGyazoにアップロードできるNode.js CLIツールです。

「Gyazoる」「Gyazoって」という動詞は「スクリーンショットを撮影してGyazoにアップロードする」という意味です。

## 機能

- ブラウザスクリーンショットの自動キャプチャ機能
- ウェブページのタイトルとURLを自動的に保持
- Gyazo APIを使用した直接アップロード
- シンプルで使いやすいCLIインターフェース
- 一時ファイルの自動クリーンアップ

## 必要条件

- Gyazoアカウントとアクセストークン（[セットアップガイド](SETUP.ja.md)を参照）
- Node.jsとnpm
- textimgコマンド（shellサブコマンドに必要）

## インストール

### devin-gyazoのインストール

npmを使用してグローバルにインストール:
```bash
npm install -g @yuiseki/devin-gyazo
```

### textimgのインストール（shellコマンドに必要）

`shell`サブコマンドを使用するにはtextimgが必要です：

```bash
# .debパッケージをダウンロード
wget https://github.com/jiro4989/textimg/releases/download/v3.1.9/textimg_3.1.9_linux_amd64.deb

# パッケージをインストール
sudo dpkg -i textimg_3.1.9_linux_amd64.deb

# オプション：CJK文字のレンダリング改善のためにNoto Sans CJKフォントをインストール
sudo mkdir -p /usr/share/fonts/truetype/noto
wget -O NotoSansCJK-Regular.ttc https://github.com/notofonts/noto-cjk/raw/main/Sans/OTC/NotoSansCJK-Regular.ttc
sudo mv NotoSansCJK-Regular.ttc /usr/share/fonts/truetype/noto/
sudo fc-cache -f -v
```

Gyazoアクセストークンの設定:
```bash
export GYAZO_ACCESS_TOKEN="your-access-token-here"
```

## 使い方

### ブラウザスクリーンショット
```bash
# 現在のブラウザタブからタイトルとURLを自動検出
devin-gyazo browser

# 上記と同じ、明示的に自動モードを指定
devin-gyazo browser auto

# タイトルとURLを手動で指定
devin-gyazo browser "ページタイトル" "https://example.com"
```

browserコマンドの動作:
1. 現在のブラウザタブのスクリーンショットを撮影
2. メタデータ付きでGyazoにアップロード:
   - タイトル: ウェブページのタイトル
   - URL: ウェブページのURL
3. Gyazoのパーマリンクを出力
4. 一時ファイルをクリーンアップ

### シェル出力のスクリーンショット
```bash
# コマンド出力をキャプチャしてアップロード
devin-gyazo shell ls -la

# 任意のシェルコマンドで動作
devin-gyazo shell "git status"
```

shellコマンドの動作:
1. ANSIカラー対応でコマンド出力をキャプチャ
2. 出力を画像に変換
3. Gyazoにアップロードしてパーマリンクを出力
4. 一時ファイルをクリーンアップ

## ライセンス

MIT License
