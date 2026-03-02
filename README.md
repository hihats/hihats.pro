## hihats.pro
portfolio of hihats

## Setup
### build
```
$ docker build -t hihats.pro .
```

### run container on local machine
```
$ docker run --rm -p 8080:10000 -e PORT=10000 --name hihats.pro hihats.pro
```

### deploy to Render (via ghcr.io)

1. ghcr.io にログイン（初回のみ）
   ```
   echo $GHCR_PAT | docker login ghcr.io -u hihats --password-stdin
   ```
2. ビルド & プッシュ
   ```
   docker build -t ghcr.io/hihats/hihats.pro:latest .
   docker push ghcr.io/hihats/hihats.pro:latest
   ```
3. Render にデプロイ
   ```
   curl -X POST $RENDER_DEPLOY_HOOK_URL
   ```
