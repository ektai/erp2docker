ARG GIT_BRANCH=develop
ARG TAG=latest
FROM registry.gitlab.com/dokos/dokidocker/dodock-worker:${TAG}

ARG GIT_BRANCH
RUN install_app erpnext https://gitlab.com/dokos/dokos ${GIT_BRANCH}

RUN chown -R dodock:dodock /home/dodock/dodock-bench /home/dodock/backups
