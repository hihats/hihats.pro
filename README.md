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

### deploy to Render
This project uses [Render Blueprint](https://render.com/docs/blueprint-spec) (`render.yaml`) with Docker runtime and GitHub integration.

1. Connect the GitHub repository on [Render Dashboard](https://dashboard.render.com/)
2. Create a new **Web Service** from the Blueprint (`render.yaml`)
3. Set environment variables (`AWS_REGION`, `AWS_ACCESS_KEY`, `AWS_SECRET_ACCESS_KEY`, `S3_BUCKET_NAME`) in the Render Dashboard
4. Pushes to `master` trigger automatic deploys
