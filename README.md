## hihats.pro
portfolio of hihats

## Setup
### build
```
$ docker build -t hihats.pro .
```

### run container on local machine
```
$ docker run --rm -p 8080:80 -e HOSTNAME=0.0.0.0 -e PORT=80 --name hihats.pro hihats.pro
```

### deploy to heroku
```
$ heroku login
$ heroku container:login

$ heroku apps
$ heroku container:push -a hihatspro web
```

### release on heroku
```
$ heroku container:release web -a hihatspro
```
