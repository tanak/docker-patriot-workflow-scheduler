# VERSION   0.1

FROM ubuntu:14.04
MAINTAINER Takayuki Tanaka <takat007@gmail.com>

ENV INSTALL_DIR /usr/local/patriot
ENV TOOL_DIR /usr/local/patriot-workflow-scheduler
ENV VERSION 0.7.2
ENV TERM xterm

# install prerequisites
RUN \
  apt-get update &&\
  apt-get install -y git ruby2.0 ruby2.0-dev build-essential &&\
  rm /usr/bin/ruby /usr/bin/gem /usr/bin/irb /usr/bin/rdoc /usr/bin/erb &&\
  ln -s /usr/bin/ruby2.0 /usr/bin/ruby &&\
  ln -s /usr/bin/gem2.0 /usr/bin/gem &&\
  ln -s /usr/bin/irb2.0 /usr/bin/irb &&\
  ln -s /usr/bin/rdoc2.0 /usr/bin/rdoc &&\
  ln -s /usr/bin/erb2.0 /usr/bin/erb &&\
  gem update --system &&\
  gem pristine --all

# setup patriot-workflow-scheduler
RUN \
  cd /usr/local &&\
  # git clone https://github.com/CyberAgent/patriot-workflow-scheduler.git
  git clone https://github.com/tanak/patriot-workflow-scheduler.git

RUN \
  cd ${TOOL_DIR} &&\
  gem build patriot-workflow-scheduler.gemspec &&\
  gem install patriot-workflow-scheduler-${VERSION}.gem &&\
  patriot-init ${INSTALL_DIR}

RUN \
  apt-get install -y sqlite3 libsqlite3-dev

RUN \
  cd ${TOOL_DIR}/plugins/patriot-sqlite3-client &&\
  gem build patriot-sqlite3-client.gemspec &&\
  ${INSTALL_DIR}/bin/patriot plugin install ${TOOL_DIR}/plugins/patriot-sqlite3-client/patriot-sqlite3-client-0.7.0.gem &&\
  sqlite3 ${INSTALL_DIR}/patriot.sqlite < ${TOOL_DIR}/misc/sqlite3.sql &&\
  mv ${INSTALL_DIR}/config/patriot.ini ${INSTALL_DIR}/config/patriot-mysql.ini  &&\
  mv ${INSTALL_DIR}/config/patriot-sqlite.ini ${INSTALL_DIR}/config/patriot.ini 
  
# test execute
RUN \
  cd ${INSTALL_DIR} &&\
  ./bin/patriot execute 2015-04-01 batch/sample/daily/test.pbc &&\
  cat /tmp/test.out

# test register
RUN \
  cd ${INSTALL_DIR} &&\
  ./bin/patriot register 2015-04-01 batch/sample/daily/test.pbc
RUN \
  sqlite3 ${INSTALL_DIR}/patriot.sqlite "select * from jobs"

CMD \
  cd ${INSTALL_DIR} &&\
  # ./bin/patriot worker start
  ./bin/patriot worker --foreground start