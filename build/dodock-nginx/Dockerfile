# This image uses nvm and same base image as the worker image.
# This is done to ensures that node-sass binary remains common.
# node-sass is required to enable website theme feature used
# by Website Manager role in Frappe Framework
FROM bitnami/python:3.7-prod

ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=12.18.3
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN install_packages wget \
    && wget https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh \
    && chmod +x install.sh \
    && ./install.sh \
    && . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION} \
    && nvm use v${NODE_VERSION} && npm install -g yarn

WORKDIR /home/dodock/dodock-bench
RUN mkdir -p /home/dodock/dodock-bench/sites \
    && echo "frappe" > /home/dodock/dodock-bench/sites/apps.txt

RUN install_packages git

ARG GIT_BRANCH=develop
RUN mkdir -p apps sites/assets/css sites/assets/frappe \
    && cd apps \
    && git clone --depth 1 https://gitlab.com/dokos/dodock -b $GIT_BRANCH frappe

COPY build/dodock-nginx/build.sh /build.sh
RUN /build.sh
RUN node --version \
    && npm --version \
    && yarn --version

RUN git clone --depth 1 https://gitlab.com/dokos/docli /tmp/bench \
    && mkdir -p /var/www/error_pages \
    && cp -r /tmp/bench/bench/config/templates /var/www/error_pages

RUN cp -R /home/dodock/dodock-bench/apps/frappe/frappe/public/* /home/dodock/dodock-bench/sites/assets/frappe \
    && cp -R /home/dodock/dodock-bench/apps/frappe/node_modules /home/dodock/dodock-bench/sites/assets/frappe/

FROM nginx:latest
COPY --from=0 /home/dodock/dodock-bench/sites /var/www/html/
COPY --from=0 /var/www/error_pages /var/www/
COPY build/common/nginx-default.conf.template /etc/nginx/conf.d/default.conf.template
COPY build/dodock-nginx/docker-entrypoint.sh /

RUN apt-get update && apt-get install -y rsync && apt-get clean \
    && echo "#!/bin/bash" > /rsync \
    && chmod +x /rsync

VOLUME [ "/assets" ]

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
