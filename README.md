## hihats.pro
portfolio of hihats

## Setup
### build
```
$ docker build --platform linux/amd64 -t hihats.pro .
```

### run container on local machine
```
$ docker run --rm -p 8080:10000 -e PORT=10000 --name hihats.pro hihats.pro
```

### deploy to Render (via ghcr.io)

`Makefile` にデプロイ手順がまとまっている。

1. `gh` に packages 系スコープを付与（初回のみ）
   ```
   gh auth refresh -h github.com -s write:packages,read:packages
   ```
2. ghcr.io にログイン（`gh auth token` を都度使用。固定トークンの保存は不要）
   ```
   make login
   ```
3. ビルド & プッシュ & Render デプロイを一括実行（Render は linux/amd64 のみ対応）
   ```
   make deploy
   ```

#### 注意事項
- `gh auth token` が返すトークンは、GitHub の「1年間未使用で自動失効」ルールのみが適用される（固定期限ではない）。定期的に `gh` コマンドを使っていれば実質失効しない。
- Render 側に登録した registry credential (`ghcr-hihats`) は自動更新されない。`gh auth login`/`logout` をやり直してトークンが変わった場合は、Render ダッシュボード側の値も `gh auth token` の新しい出力に手動で貼り直すこと。
