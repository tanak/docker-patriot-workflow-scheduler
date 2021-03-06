This is a project to help users to try [patriot-workflow-scheduler](https://github.com/CyberAgent/patriot-workflow-scheduler) easily.

## setup

```
$ docker-compose pull
$ docker-compose build
```

## start mysql

```
$ docker-compose up -d mysql4patriot
$ docker-compose logs mysql4patriot
```

Wait for mysql server to start. After several seconds, you can see logs like:  
```
mysql4patriot | Version: '5.7.9'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
```

Now you are ready to start worker. Ctrl-C to exit logs output.

## start worker

```
$ docker-compose up -d patriot-worker
$ docker-compose logs patriot-worker
```

## check status on Web UI

#### check port of Web UI

```
$ docker ps
... 0.0.0.0:32783->36104/tcp ...
```

open  
http://localhost:32783/jobs

## register a job

on another terminal to see logs.

```
$ docker-compose run --rm patriot-client register 2015-09-03 /usr/local/patriot/batch/sample/daily/test.pbc
```

## check if the job registered above is successfully processed

open "Succeeded" on Web UI  
or open http://localhost:32783/jobs/?state=0

## create your own jobs

/tmp on host is mounted on docker patriot-client:/patriot-batches  
so you can create job files on host and try them on docker.  
Now you create jobs with dependencies.  

```
host$ vi /tmp/test2.pbc
```

```
job_group {
  produce ['sleep10']

  sh {
    name 'output_date_and_sleep_10'
    commands <<-EOS
      hostname > /patriot-batches/test2a.out
      date >> /patriot-batches/test2a.out
      sleep 10
    EOS
  }
}

job_group {
  require ['sleep10']

  sh {
    name 'output_date_after_require_job_finished'
    commands <<-EOS
      hostname > /patriot-batches/test2b.out
      date >> /patriot-batches/test2b.out
    EOS
  }
}
```

## register the job
```
$ docker-compose run --rm patriot-client register 2015-09-03 /patriot-batches/test2.pbc
```

## check if the job registered above is successfully processed

```
host$ cat /tmp/test2a.out
f23cd8db21c0
Mon Nov 23 05:37:55 UTC 2015
```

10 seconds later

```
host$ cat /tmp/test2b.out
f23cd8db21c0
Mon Nov 23 05:38:26 UTC 2015
```

## stop and remove containers

```
$ docker-compose stop 
$ docker-compose rm patriot-worker
```

or if you don't need jobs history, you can remove mysql container too.

```
$ docker-compose rm mysql4patriot
```

## working on multiple workers

```
$ docker-compose up -d mysql4patriot
$ docker-compose scale patriot-worker=3
$ docker-compose logs
```
on another terminal to see logs

```
$ docker-compose run --rm patriot-client register 2015-09-03 /patriot-batches/test2.pbc
$ cat /tmp/test2a.out
```

10 seconds later

```
$ cat /tmp/test2b.out
```

### Sqlite version

check patriot-sqlite3 for patriot-workflow-scheduler with sqlite3 connector

