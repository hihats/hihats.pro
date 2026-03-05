IMAGE := ghcr.io/hihats/hihats.pro:latest

.PHONY: build push deploy run login

## build → push → Render deploy を一括実行
deploy: build push
	curl -sf -X POST "$$RENDER_DEPLOY_HOOK_URL"
	@echo "\nDeploy triggered."

build:
	docker build --platform linux/amd64 -t $(IMAGE) .

push:
	docker push $(IMAGE)

## ローカル確認用
run:
	docker run --rm -p 8080:10000 -e PORT=10000 --name hihats.pro $(IMAGE)

## ghcr.io ログイン（初回のみ）
login:
	echo "$$GHCR_PAT" | docker login ghcr.io -u hihats --password-stdin
