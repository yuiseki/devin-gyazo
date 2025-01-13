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
# Debian/Ubuntu向け:
wget https://github.com/jiro4989/textimg/releases/download/v3.1.10/textimg_3.1.10_amd64.deb
sudo dpkg -i textimg_3.1.10_amd64.deb

# RHEL/CentOS向け:
sudo yum install https://github.com/jiro4989/textimg/releases/download/v3.1.10/textimg-3.1.10-1.el7.x86_64.rpm

# Goがインストールされている場合:
go get -u github.com/jiro4989/textimg/v3

問題が発生した場合は、https://github.com/jiro4989/textimg を参照してください。

# オプション：日本語（CJK）テキストのレンダリング改善：
# Noto Sans CJKフォントのダウンロードとインストール
wget -O NotoSansCJK-Regular.ttc https://github.com/notofonts/noto-cjk/raw/main/Sans/OTC/NotoSansCJK-Regular.ttc
sudo mkdir -p /usr/share/fonts/truetype/noto
sudo mv NotoSansCJK-Regular.ttc /usr/share/fonts/truetype/noto/
sudo fc-cache -f -v

注意：日本語テキストのレンダリングにはNoto Sans CJKフォントが必要です。日本語の端末出力をキャプチャする必要がある場合は、上記のコマンドでインストールしてください。
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

textimgのインストールとシェルコマンドの動作確認：
```bash
# textimgがインストールされている場合、成功してGyazo URLが返されます
devin-gyazo shell ls -alh

# textimgがインストールされていない場合、インストール手順へのエラーメッセージが表示されます
```

shellコマンドの動作:
1. ANSIカラー対応でコマンド出力をキャプチャ
2. 出力を画像に変換
3. Gyazoにアップロードしてパーマリンクを出力
4. 一時ファイルをクリーンアップ

## ライセンス

MIT License
