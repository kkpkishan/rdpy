#FROM alpine:3.11
FROM debian:buster-slim
# Include dist
ADD dist/ /root/dist/
#
# Get and install dependencies & packages

RUN apt-get update
RUN  apt-get install -y \
            git \
            openssl \
            python2.7 \
            python-pip \
            curl

# Install deps 
RUN    pip install --no-cache-dir --upgrade cffi && \
    pip install --no-cache-dir \
                hpfeeds \
                twisted \
                pyopenssl \
                qt4reactor \
                service_identity \
                rsa==3.4.2 \
                pyasn1 
#
# Install rdpy from git
RUN    mkdir -p /opt && \
    cd /opt && \
    git clone https://github.com/t3chn0m4g3/rdpy && \
    cd rdpy && \
    git checkout 1d2a4132aefe0637d09cac1a6ab83ec5391f40ca && \
    python setup.py install && \
#
# Setup configs
    cp /root/dist/* /opt/rdpy/ && \
    mkdir -p /var/log/rdpy 
#
RUN mkdir -p /usr/share/man/man1 /usr/share/man/man2
RUN apt-get update && \
apt-get install -y --no-install-recommends \
        openjdk-11-jre aria2 bzip2
RUN mkdir -p /etc/listbot &&\
    cd /etc/listbot \
    aria2c -s16 -x 16 https://listbot.sicherheitstacho.eu/cve.yaml.bz2 &&\
    aria2c -s16 -x 16 https://listbot.sicherheitstacho.eu/iprep.yaml.bz2 &&\
    bunzip2 *.bz2

RUN mkdir -p /usr/share/logstash
RUN aria2c -s 16 -x 16 https://artifacts.elastic.co/downloads/logstash/logstash-oss-7.10.2-linux-x86_64.tar.gz
RUN tar xvfz logstash-oss-7.10.2-linux-x86_64.tar.gz --strip-components=1 -C /usr/share/logstash/
RUN rm -rf /usr/share/logstash/jdk
RUN /usr/share/logstash/bin/logstash-plugin install logstash-filter-translate
RUN /usr/share/logstash/bin/logstash-plugin install logstash-output-syslog
RUN mkdir -p /etc/logstash/conf.d/
RUN cp /root/dist/logstash.conf /etc/logstash/conf.d/logstash.conf
RUN cp /root/dist/tpot_es_template.json /etc/logstash/tpot_es_template.json 
RUN cp /root/dist/update.sh /usr/bin/
RUN chmod 755 /usr/bin/update.sh 
#
RUN cp /root/dist/services.sh /services.sh
RUN chmod +x /services.sh
RUN apt-get autoremove --purge -y && \
    apt-get clean && \
rm -rf /logstash-oss-7.10.2-linux-x86_64.tar.gz #/var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ./services.sh
