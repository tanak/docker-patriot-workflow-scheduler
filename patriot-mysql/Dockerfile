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
  apt-get install -y git ruby2.0 ruby2.0-dev build-essential &&\
  rm /usr/bin/ruby /usr/bin/gem /usr/bin/irb /usr/bin/rdoc /usr/bin/erb &&\
  ln -s /usr/bin/ruby2.0 /usr/bin/ruby &&\
  ln -s /usr/bin/gem2.0 /usr/bin/gem &&\
  ln -s /usr/bin/irb2.0 /usr/bin/irb &&\
  ln -s /usr/bin/rdoc2.0 /usr/bin/rdoc &&\
  ln -s /usr/bin/erb2.0 /usr/bin/erb &&\
  gem update --system &&\
  gem pristine --all

RUN apt-get install -y libmysqlclient-dev

# setup patriot-workflow-scheduler
RUN \
  cd /usr/local &&\
  git clone https://github.com/CyberAgent/patriot-workflow-scheduler.git &&\
  cd ${TOOL_DIR} &&\
  gem build patriot-workflow-scheduler.gemspec &&\
  gem install patriot-workflow-scheduler-${VERSION}.gem &&\
  patriot-init ${INSTALL_DIR}

# setup mysql connecter
# RUN \
#   cd ${TOOL_DIR}/plugins/patriot-mysql2-client &&\
#   gem build patriot-mysql2-client.gemspec &&\
#   ${INSTALL_DIR}/bin/patriot plugin install ${TOOL_DIR}/plugins/patriot-mysql2-client/patriot-mysql2-client-0.7.0.gem
RUN ${INSTALL_DIR}/bin/patriot plugin install patriot-mysql2-client

RUN \
  sed -i -e 's/jobstore\.root\.class=.*/plugins=patriot-mysql2-client\njobstore.root.class=Patriot::JobStore::RDBJobStore\njobstore.root.adapter=mysql2\njobstore.root.database=test_patriot_rdb_job_store\njobstore.root.host=mysql4patriot\njobstore.root.username=test\njobstore.root.password=test\n/' ${INSTALL_DIR}/config/patriot.ini

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

ENTRYPOINT ["/usr/local/patriot/bin/patriot"]
