FROM bitnami/python:3.7-prod

RUN useradd -ms /bin/bash dodock

ARG GIT_BRANCH=develop
ENV PYTHONUNBUFFERED 1
ENV NVM_DIR=/home/dodock/.nvm
ENV NODE_VERSION=12.18.3
ENV PATH="/home/dodock/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

# Install dependencies
WORKDIR /home/dodock/dodock-bench
RUN install_packages \
    git \
    mariadb-client \
    postgresql-client \
    gettext-base \
    wget \
    # for PDF
    libjpeg62-turbo \
    libx11-6 \
    libxcb1 \
    libxext6 \
    libxrender1 \
    libssl-dev \
    fonts-cantarell \
    xfonts-75dpi \
    xfonts-base \
    # For psycopg2
    libpq-dev \
    && wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb \
    && dpkg -i wkhtmltox_0.12.5-1.buster_amd64.deb && rm wkhtmltox_0.12.5-1.buster_amd64.deb \
    && wget https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh \
    && apt-get purge -y wget && apt-get autoremove -y \
    && chown -R dodock:dodock /home/dodock

USER dodock
# Install nvm with node
RUN bash install.sh \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install ${NODE_VERSION} \
    && nvm use v${NODE_VERSION} \
    && nvm alias default v${NODE_VERSION}

# Create dodock-bench directories
RUN mkdir -p apps logs commands /home/dodock/backups

# Setup python environment
RUN python -m venv env \
    && . env/bin/activate \
    && cd apps \
    && git clone --depth 1 -o upstream https://gitlab.com/dokos/dodock -b ${GIT_BRANCH} frappe \
    && pip3 install --no-cache-dir -e /home/dodock/dodock-bench/apps/frappe

USER root
# Copy scripts and templates
COPY build/common/commands/* /home/dodock/dodock-bench/commands/
COPY build/common/common_site_config.json.template /opt/dodock/common_site_config.json.template
COPY build/common/worker/install_app.sh /usr/local/bin/install_app
COPY build/common/worker/bench /usr/local/bin/bench

# Setup docker-entrypoint
COPY build/common/worker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN ln -s /usr/local/bin/docker-entrypoint.sh / # backwards compat

# Use sites volume as working directory
WORKDIR /home/dodock/dodock-bench/sites

# Set ownership of sites directory
RUN chown -R dodock:dodock /home/dodock/dodock-bench/sites

VOLUME [ "/home/dodock/dodock-bench/sites", "/home/dodock/backups" ]

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start"]
