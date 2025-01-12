# セットアップガイド

## Gyazo APIの利用開始方法

このリポジトリのスクリプトを使用するには、Gyazo Access Tokenが必要です。以下の手順で取得してください：

1. **メールアドレスの準備**
   - 有効なメールアドレスを用意してください

2. **Gyazoアカウントの作成**
   - [Gyazo Signup](https://gyazo.com/signup) にアクセス
   - 登録フォームに必要事項を入力
   - 注意：ユーザー登録には人間によるreCAPTCHAの確認が必要です

3. **APIドキュメントの確認**
   - [Gyazo API Documentation](https://gyazo.com/api) にOAuth APIのドキュメントがあります

4. **アプリケーションの登録**
   - [Gyazo OAuth Applications](https://gyazo.com/oauth/applications) にアクセス
   - 「New Application」ボタンをクリック
   - アプリケーション情報を入力

5. **Access Tokenの生成**
   - アプリケーション登録後
   - 「Your access token」セクションを探す
   - 「Generate」ボタンをクリックしてAccess Tokenを生成

6. **Access Tokenの設定**
   - Access Tokenを取得したら：
     - システム管理者に共有
     - 管理者がDevinの設定画面でSecretsに追加
     - `GYAZO_ACCESS_TOKEN`環境変数として利用可能になります

## Access Tokenの使用方法

このリポジトリのスクリプトは、環境変数としてAccess Tokenを設定する必要があります：

```bash
export GYAZO_ACCESS_TOKEN="your-access-token-here"
```

**重要**: Access Tokenをバージョン管理システムにコミットしないでください。必ず環境変数やセキュアなシークレット管理を使用してください。
