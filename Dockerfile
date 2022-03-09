FROM python:alpine3.15

# Install glibc
RUN apk --no-cache --update add curl==7.80.0-r0 binutils==2.37-r3 && \
    curl https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub -L && \
    curl https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk -o glibc.apk -L && \
    curl https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-bin-2.34-r0.apk -o glibc-bin.apk -L && \
    curl https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-i18n-2.34-r0.apk -o glibc-i18n.apk -L && \
    apk add --no-cache glibc.apk && apk add --no-cache glibc-bin.apk && apk add --no-cache glibc-i18n.apk && \
    apk --no-cache del curl && rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/*

# Install pylint
RUN pip install --no-cache-dir pylint==2.12.2

# Install terraform
RUN apk --no-cache --update add terraform==1.1.7-r0 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apk/*

# Install tflint
RUN apk --no-cache --update add curl==7.80.0-r0  && \
    curl "https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh" -o install_linux.sh && \
    sed -i 's/unzip\s-u/unzip/g' ./install_linux.sh && cat ./install_linux.sh && \
    chmod +x install_linux.sh && \
    sh ./install_linux.sh && \
    apk --no-cache del curl && rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN apk --no-cache --update add curl==7.80.0-r0  && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.4.23.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    cp /lib/libz* /usr/lib/. && \
    rm -R aws && rm awscliv2.zip && \
    apk --no-cache del curl && rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/*

# Install git
RUN apk --no-cache --update add git==2.34.1-r0 git-lfs==3.0.2-r0 less==590-r0 openssh==8.8_p1-r1 && \
    git lfs install && \
    rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apk/*

# Install bash
RUN apk add --no-cache --upgrade bash==5.1.16-r0 && \
    rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apk/*

# Install keepass
RUN apk --no-cache --update add libxml2-dev==2.9.12-r2 libxslt-dev==1.1.34-r1 libffi-dev==3.4.2-r1 build-base==0.5-r2 && \
    python3 -m pip install --no-cache-dir --upgrade pip==22.0.4 && \
    pip install --no-cache-dir pykeepass==4.0.1 && \
    rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apk/*

# Create user
RUN adduser -D --home /home/technogix technogix
USER technogix

# Launch test scripts
CMD ["/bin/bash"]