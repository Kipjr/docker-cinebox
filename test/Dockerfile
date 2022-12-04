FROM ubuntu:latest

ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections

RUN apt-get update -y && apt-get install -y \
        bash \
        nano \
        curl \
        python3 \
        python3-pip \
        nginx \
        screen \
        net-tools \
        iputils-ping \
        resolvconf \
        iptables \
        dnsutils \
        traceroute \
    && python3 -m pip install --no-cache-dir --upgrade pip \
    && rm -rf /tmp/* /var/tmp/* /var/cache/* /root/.cache/*

ADD test.sh /test.sh
