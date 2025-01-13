# テストガイド

このドキュメントではdevin-gyazo CLIコマンドのテスト手順について説明します。

## 前提条件

1. パッケージをグローバルにインストール：
   ```bash
   npm install -g @yuiseki/devin-gyazo
   ```

2. Gyazoアクセストークンの設定：
   ```bash
   export GYAZO_ACCESS_TOKEN="あなたのアクセストークン"
   ```

## ブラウザスクリーンショットのテスト

### `browser auto`コマンドのテスト

1. 特定のウェブページをブラウザで開く（例：https://www.cas.go.jp/）
2. browser autoコマンドを実行：
   ```bash
   devin-gyazo browser auto
   ```
3. 結果の確認：
   - コマンドが正常に実行されることを確認
   - 返されたGyazo URLをブラウザで開く
   - スクリーンショットが正しいウェブページの内容を表示していることを確認
   - タイトルとURLのメタデータが正しく取得されていることを確認

### テストケース例：内閣官房ウェブサイト

1. 内閣官房ウェブサイトを開く：
   ```bash
   # ブラウザで以下のURLにアクセス
   https://www.cas.go.jp/
   ```

2. browser autoコマンドを実行：
   ```bash
   devin-gyazo browser auto
   ```

3. 期待される結果：
   - コマンドがGyazo URLを返す
   - スクリーンショットが内閣官房ウェブサイトを表示している
   - タイトルがウェブページのタイトルと一致する
   - URLメタデータがhttps://www.cas.go.jp/を示している

### 手動モードのテスト

1. ブラウザで任意のウェブページを開く
2. 手動パラメータでbrowserコマンドを実行：
   ```bash
   devin-gyazo browser "ページタイトル" "https://example.com"
   ```
3. autoモードと同じ手順で結果を確認