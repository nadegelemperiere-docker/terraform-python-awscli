FROM python:alpine3.18

# Upgrade to fix vulnerabilities
RUN apk --no-cache upgrade

# Install glibc
RUN apk --no-cache --update add curl==8.4.0-r0 && \
    curl https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub -L && \
    curl https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-2.35-r1.apk -o glibc.apk -L && \
    curl https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-bin-2.35-r1.apk -o glibc-bin.apk -L && \
    curl https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-i18n-2.35-r1.apk -o glibc-i18n.apk -L && \
    apk add --no-cache glibc.apk && apk add --no-cache glibc-bin.apk && apk add --no-cache glibc-i18n.apk && \
    apk --no-cache del curl && rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/* && rm ./*.apk

# Install terraform
RUN apk --no-cache --update add curl==8.4.0-r0 && \
    curl https://releases.hashicorp.com/terraform/1.6.4/terraform_1.6.4_linux_amd64.zip -o terraform_1.6.4_linux_amd64.zip -L && \
    unzip terraform_1.6.4_linux_amd64.zip && \
    mv terraform /usr/bin/terraform && \
    rm terraform_1.6.4_linux_amd64.zip

# Install bash
RUN apk add --no-cache --upgrade bash==5.2.15-r5 && \
    rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apk/*

# Install tflint
RUN apk --no-cache --update add curl==8.4.0-r0 && \
    curl "https://raw.githubusercontent.com/terraform-linters/tflint/v0.49.0/install_linux.sh" -o install_linux.sh && \
    chmod +x install_linux.sh && \
    ./install_linux.sh && \
    apk --no-cache del curl && rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/* && \
    rm ./install_linux.sh

# Install AWS CLI
RUN apk --no-cache --update add curl==8.4.0-r0 && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.13.37.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    cp /lib/libz* /usr/lib/. && \
    rm -R aws && rm awscliv2.zip && \
    apk --no-cache del curl && rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/*

# Install git
RUN apk --no-cache --update add git==2.40.1-r0 git-lfs==3.3.0-r6 less==633-r0 openssh==9.3_p2-r0 && \
    git lfs install && \
    rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apk/*

# Install python packages
RUN apk --no-cache --update add curl==8.4.0-r0 libxml2-dev==2.11.6-r0 libxslt-dev==1.1.38-r0 libffi-dev==3.4.4-r2 build-base==0.5-r3 && \
    curl -sSL https://install.python-poetry.org -o get_poetry.py && \
    export POETRY_HOME=/usr/local && \
    python3 get_poetry.py --version=1.7.1 && \
    python3 -m pip install --no-cache-dir --upgrade pip==23.3.1 && \
    pip install --no-cache-dir pykeepass==4.0.6 && \
    pip install --no-cache-dir pip-audit==2.6.1 && \
    pip install --no-cache-dir pylint==3.0.2 && \
    pip install --no-cache-dir poetry-dynamic-versioning==1.1.1 && \
    apk --no-cache del curl && rm get_poetry.py &&  rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apk/*

# Launch test scripts
CMD ["/bin/bash"]