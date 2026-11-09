IMAGE_REPO := ghcr.io/hihats/hihats.pro
IMAGE := $(IMAGE_REPO):latest
# rev-parse, not describe: tag names can contain shell metacharacters and would be expanded unquoted below
# untracked files count as dirty because COPY . ships them; docs/ is skipped since .dockerignore drops it
GIT_DIRTY := $(if $(shell git status --porcelain -- . ':!docs'),-dirty)
IMAGE_SHA := $(IMAGE_REPO):$(shell git rev-parse --short HEAD)$(GIT_DIRTY)

.PHONY: build push deploy check-hook run local login

## build → push → Render deploy を一括実行
deploy: check-hook build push
	curl -sf -X POST "$$RENDER_DEPLOY_HOOK_URL"
	@echo "\nDeploy triggered."

## フック URL が空のまま push まで進むと、:latest だけ更新されて本番は未デプロイになるため先に止める
check-hook:
	@test -n "$$RENDER_DEPLOY_HOOK_URL" || { echo "RENDER_DEPLOY_HOOK_URL is empty (.envrc 変更後なら direnv allow)" >&2; exit 1; }

build:
	docker build --platform linux/amd64 -t $(IMAGE) -t $(IMAGE_SHA) .

push:
	docker push $(IMAGE_SHA)
	docker push $(IMAGE)

## ローカル確認用（ネイティブアーキテクチャでビルド＆起動）
local:
	docker build -t hihats.pro .
	docker run --rm -p 8080:10000 -e PORT=10000 --name hihats.pro hihats.pro

## デプロイ用イメージでローカル実行
run:
	docker run --rm -p 8080:10000 -e PORT=10000 --name hihats.pro $(IMAGE)

## ghcr.io ログイン（gh CLI のトークンを都度使用。GHCR_PAT は不要）
login:
	gh auth token | docker login ghcr.io -u hihats --password-stdin
