# devin-gyazo

Gyazoでスクリーンショットを撮影・アップロードするための自動化スクリプト集です。

## 機能

- ブラウザのスクリーンショットを自動的に「Gyazoる」
- Gyazo APIを使用して直接「Gyazoって」アップロード
- JSONレスポンスからパーマリンクURLを抽出
- 一時ファイルの自動クリーンアップ

## 必要条件

- APIリクエスト用の`curl`
- JSON解析用の`jq`
- Gyazoアカウントとアクセストークン

## セットアップ

1. 必要なツールをインストール:
   ```bash
   sudo apt-get update
   sudo apt-get install -y curl jq
   ```

2. Gyazoアクセストークンの設定:
   ```bash
   export GYAZO_ACCESS_TOKEN="your-access-token-here"
   ```

## 使い方

スクリプトは `/home/ubuntu/screenshots/` ディレクトリにある最新のスクリーンショットを自動的に見つけて、Gyazoにアップロードします:

```bash
./gyazo-screenshot.sh
```

スクリプトの動作:
1. 最新のスクリーンショットを探す
2. Gyazoにアップロード（「Gyazoる」）
3. Gyazoのパーマリンクを出力
4. 一時ファイルをクリーンアップ

## エラー処理

スクリプトには様々なエラーチェックが含まれています:
- GYAZO_ACCESS_TOKENが設定されているか確認
- 必要なコマンド（curl、jq）の確認
- スクリーンショットファイルの存在確認
- アップロード失敗時の適切な処理

## ライセンス

MIT License
