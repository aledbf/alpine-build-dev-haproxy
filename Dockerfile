FROM    alpine:3.2

RUN     apk -U add alpine-sdk

RUN     mkdir -p /var/cache/distfiles && \
        adduser -D packager && \
        addgroup packager abuild && \
        chgrp abuild /var/cache/distfiles && \
        chmod g+w /var/cache/distfiles && \
        echo "packager    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER    packager

WORKDIR /work

RUN abuild-keygen -a -i

ADD haproxy /work

RUN sudo chown -R packager /work

RUN abuild -c -r -P /work/haproxy
