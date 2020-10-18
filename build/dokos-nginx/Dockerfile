ARG NODE_IMAGE_TAG=12-prod
ARG GIT_BRANCH=develop
ARG TAG=latest
FROM bitnami/node:${NODE_IMAGE_TAG}

ARG GIT_BRANCH
COPY build/dokos-nginx/install_app.sh /install_app

RUN /install_app erpnext https://gitlab.com/dokos/dokos ${GIT_BRANCH}

FROM registry.gitlab.com/dokos/dokidocker/dodock-nginx:${TAG}

COPY --from=0 /home/dodock/dodock-bench/sites/ /var/www/html/
COPY --from=0 /rsync /rsync
RUN echo "erpnext" >> /var/www/html/apps.txt

VOLUME [ "/assets" ]

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
