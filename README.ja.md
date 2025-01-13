# devin-gyazo

Gyazoでスクリーンショットを撮影・アップロードするための自動化スクリプト集です。

「Gyazoる」「Gyazoって」という動詞は「スクリーンショットを撮影してGyazoにアップロードする」という意味です。

## 機能

- メタデータ対応のブラウザスクリーンショット自動キャプチャ（ウェブページのタイトルをそのまま使用）
- ANSIカラー対応のシェル出力キャプチャ
- アプリケーション識別付きのGyazo APIを使用した直接アップロード
- JSONレスポンスからパーマリンクURLを抽出
- 一時ファイルの自動クリーンアップ

## 必要条件

- APIリクエスト用の`curl`
- JSON解析用の`jq`
- ターミナルテキストレンダリングとANSIカラー対応用の`textimg`
- Gyazoアカウントとアクセストークン（[セットアップガイド](SETUP.ja.md)を参照）
- （オプション）CJK文字のレンダリング改善用のNoto Sans CJKフォント

## セットアップ

1. リポジトリをクローン:
   ```bash
   cd ~/repos/
   git clone https://github.com/yuiseki/devin-gyazo.git
   ```

2. 必要なツールをインストール:
   ```bash
   sudo apt-get update
   sudo apt-get install -y curl jq
   ```

2. Gyazoアクセストークンの設定:
   ```bash
   export GYAZO_ACCESS_TOKEN="your-access-token-here"
   ```

## 使い方

### ブラウザスクリーンショット

メタデータ付きでブラウザスクリーンショットをアップロードするには gyazo-browser.sh を使用します。自動モードまたは手動モードを選択できます:

> **重要**: スクリーンショットは `/home/ubuntu/screenshots/` ディレクトリに以下のいずれかの形式で保存する必要があります：
> - `browser_*.png`: 手動でキャプチャしたスクリーンショット（例: `browser_20240113_120000.png`）
> - `playwright_*.png`: 自動でキャプチャしたスクリーンショット（例: `playwright_2024-01-13T12-00-00Z.png`）
>
> スクリプトは自動的にいずれかの形式に一致する最新のファイルを探します。

### 自動モード
```bash
~/repos/devin-gyazo/gyazo-browser.sh auto
```
以下の処理を自動的に行います：
1. 現在アクティブなChromeタブのスクリーンショットを撮影
2. タブからページタイトルとURLを取得
3. 取得したデータを使用してGyazoにアップロード

スクリーンショットはアップロード前にスクリーンショットディレクトリに保存されます。

### 手動モード
```bash
~/repos/devin-gyazo/gyazo-browser.sh "ページタイトル" "https://example.com"
```

スクリプトの動作:
1. 最新のブラウザスクリーンショット（browser_*.png）を探す
2. メタデータ付きでGyazoにアップロード:
   - アプリ名: "Devin Browser"
   - タイトル: ウェブページのタイトルをそのまま使用
   - リファラーURL: 指定したページURL
3. Gyazoのパーマリンクを出力
4. 一時ファイルをクリーンアップ

### シェル出力

シェル出力をキャプチャしてアップロードするには gyazo-shell.sh を使用します:

```bash
~/repos/devin-gyazo/gyazo-shell.sh "ls -la"
```

スクリプトの動作:
1. ANSIカラー対応でコマンド出力をキャプチャ
2. 出力を画像に変換
3. アプリ名 "Devin Shell" でGyazoにアップロード
4. Gyazoのパーマリンクを出力
5. 一時ファイルをクリーンアップ

## エラー処理

スクリプトには様々なエラーチェックが含まれています:
- GYAZO_ACCESS_TOKENが設定されているか確認
- 必要なコマンド（curl、jq）の確認
- スクリーンショットファイルの存在確認
- アップロード失敗時の適切な処理

## ライセンス

MIT License
