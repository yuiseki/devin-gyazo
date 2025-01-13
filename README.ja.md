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

- Gyazoアカウントとアクセストークン（[セットアップガイド](SETUP.ja.md)を参照）
- CLI使用の場合: Node.jsとnpm
- シェルスクリプト使用の場合:
  - APIリクエスト用の`curl`
  - JSON解析用の`jq`
  - ターミナルテキストレンダリングとANSIカラー対応用の`textimg`
  - （オプション）CJK文字のレンダリング改善用のNoto Sans CJKフォント

## インストール

### NPMパッケージ（推奨）

npmを使用してグローバルにインストール:
```bash
npm install -g @yuiseki/devin-gyazo
```

Gyazoアクセストークンの設定:
```bash
export GYAZO_ACCESS_TOKEN="your-access-token-here"
```

### 手動セットアップ（代替方法）

シェルスクリプトを直接使用する場合:

1. リポジトリをクローン:
   ```bash
   git clone https://github.com/yuiseki/devin-gyazo.git
   ```

2. 必要なツールをインストール:
   ```bash
   sudo apt-get update
   sudo apt-get install -y curl jq
   
   # ターミナルテキストレンダリング用のtextimgをインストール
   wget https://github.com/jiro4989/textimg/releases/download/v3.1.9/textimg_3.1.9_linux_amd64.deb
   sudo dpkg -i textimg_3.1.9_linux_amd64.deb
   
   # オプション: CJK文字のレンダリング改善用のNoto Sans CJKフォントをインストール
   wget https://github.com/notofonts/noto-cjk/raw/main/Sans/OTC/NotoSansCJK-Regular.ttc
   sudo mkdir -p /usr/share/fonts/truetype/noto
   sudo mv NotoSansCJK-Regular.ttc /usr/share/fonts/truetype/noto/
   sudo fc-cache -f -v
   ```

3. Node.js依存関係のインストール（自動モードに必要）:
   ```bash
   npm ci
   ```

4. Gyazoアクセストークンの設定:
   ```bash
   export GYAZO_ACCESS_TOKEN="your-access-token-here"
   ```

## 使い方

### CLIの使用（推奨）

#### ブラウザスクリーンショット
```bash
# 現在のブラウザタブからタイトルとURLを自動検出
devin-gyazo browser

# 上記と同じ、明示的に自動モードを指定
devin-gyazo browser auto

# タイトルとURLを手動で指定
devin-gyazo browser "ページタイトル" "https://example.com"
```

### シェルスクリプトの使用（代替方法）

オリジナルのシェルスクリプトも引き続き利用可能です：

#### ブラウザスクリーンショット
```bash
# 自動モード
./gyazo-browser.sh auto

# 手動モード
./gyazo-browser.sh "ページタイトル" "https://example.com"
```
手動モードを使用する前に：
1. ブラウザのスクリーンショットを撮影し、`/home/ubuntu/screenshots/`に保存してください
2. ブラウザの正確なページタイトルとURLを指定してスクリプトを実行してください

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
