# Mental Health Tracker

## Run

```
$ flutter run
```

## Deploy

```
$ flutter build web
$ cd build/web
$ echo '{}' > composer.json
$ echo 'web: vendor/bin/heroku-php-apache2' > Procfile
$ echo '<?php include_once("index.html"); ?>' > index.php
$ git init; git add .; git commit -m "Initialize."
$ heroku git:remote -a mental-tracker
$ git push heroku main:master
```
