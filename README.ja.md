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

## インストール

npmを使用してグローバルにインストール:
```bash
npm install -g @yuiseki/devin-gyazo
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

コマンドの動作:
1. 現在のブラウザタブのスクリーンショットを撮影
2. メタデータ付きでGyazoにアップロード:
   - タイトル: ウェブページのタイトル
   - URL: ウェブページのURL
3. Gyazoのパーマリンクを出力
4. 一時ファイルをクリーンアップ

## ライセンス

MIT License
