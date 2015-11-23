# VERSION   0.1

FROM ubuntu:14.04
MAINTAINER Takayuki Tanaka <takat007@gmail.com>

ENV INSTALL_DIR /usr/local/patriot
ENV TOOL_DIR /usr/local/patriot-workflow-scheduler
ENV VERSION 0.8.0.alpha
ENV TERM xterm

# install prerequisites
RUN \
  apt-get update &&\
  apt-get install -y git ruby2.0 ruby2.0-dev build-essential sqlite3 libsqlite3-dev &&\
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
  git clone https://github.com/tanak/patriot-workflow-scheduler.git &&\
  cd ${TOOL_DIR} &&\
  git checkout docker &&\
  gem build patriot-workflow-scheduler.gemspec &&\
  gem install patriot-workflow-scheduler-${VERSION}.gem &&\
  patriot-init ${INSTALL_DIR}

# setup sqlite3 connecter
RUN \
  cd ${TOOL_DIR}/plugins/patriot-sqlite3-client &&\
  gem build patriot-sqlite3-client.gemspec &&\
  ${INSTALL_DIR}/bin/patriot plugin install ${TOOL_DIR}/plugins/patriot-sqlite3-client/patriot-sqlite3-client-0.7.0.gem &&\
  sqlite3 ${INSTALL_DIR}/patriot.sqlite < ${TOOL_DIR}/misc/sqlite3.sql &&\
  mv ${INSTALL_DIR}/config/patriot.ini ${INSTALL_DIR}/config/patriot-mysql.ini &&\
  mv ${INSTALL_DIR}/config/patriot-sqlite.ini ${INSTALL_DIR}/config/patriot.ini &&\
  sed -i -e 's/jobstore\.root\.database=.*/jobstore.root.database=\/usr\/local\/patriot\/patriot.sqlite/' ${INSTALL_DIR}/config/patriot.ini

# Remove unnecessary packages
RUN apt-get purge -y build-essential
RUN apt-get autoremove -y

# Clear package repository cache
RUN apt-get clean all

# test execute
RUN \
  cd ${INSTALL_DIR} &&\
  ./bin/patriot execute 2015-04-01 batch/sample/daily/test.pbc &&\
  cat /tmp/test.out

VOLUME ["/usr/local/patriot"]
ENTRYPOINT ["/usr/local/patriot/bin/patriot"]
