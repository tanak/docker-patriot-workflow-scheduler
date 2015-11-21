### build image

```
$ docker build -t patriot .
```

### start patriot-workflow-scheduler

```
$ docker run -d --name patriot-server patriot worker --foreground start
```

### register jobs

```
$ docker run --rm --volumes-from patriot-server patriot register 2015-09-01 /usr/local/patriot/batch/sample/daily/test.pbc
```

### check logs

```
docker logs patriot-server
```

### connect to container and check if test.pbc worked correctly

```
$ docker exec -i -t patriot-server bash
docker# cat /tmp/test.out
2015-09-01
```

### change test.pbc

```
docker# vi /usr/local/patriot/batch/sample/daily/test.pbc
```
