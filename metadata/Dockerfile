FROM davidemms/orthofinder

RUN apt-get -qq update && apt-get -qq -y install \
    automake \
    build-essential \
    bzip2 \
    cmake \
    curl \
    default-jre \
    fort77 \
    ftp \
    g++ \
    gcc \
    gfortran \
    git \
    libblas-dev \
    libbz2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libdb-dev \
    libghc-zlib-dev

RUN apt-get -qq update && apt-get -qq -y install \
    libjpeg-dev \
    liblzma-dev \
    libncurses-dev \
    libncurses5-dev \
    libpcre3-dev \
    libpng-dev \
    libreadline-dev \
    libreadline-dev \
    libssl-dev \
    libtbb-dev \
    libx11-dev \
    libxml2-dev \
    libxt-dev \
    libzmq3-dev \
    make \
    nano \
    perl \
    pkg-config \
    python3 \
    python3-dev \
    python3-distutils \
    python3-pip \
    python3-setuptools \
    rsync \
    texlive-latex-base \
    tzdata \
    unzip \
    wget \
    x11-common \
    zlib1g-dev

## Perl prereqs for TransDecoder
RUN curl -L https://cpanmin.us | perl - App::cpanminus
RUN cpanm install DB_File
RUN cpanm install URI::Escape

ENV SRC /usr/local/src
ENV BIN /usr/local/bin

# copied directly from https://github.com/TransDecoder/TransDecoder/blob/master/Docker/Dockerfile
WORKDIR $SRC
ENV TRANSDECODER_CO=817d772325c8a354aec6b94ac58993b994ac7392

RUN git clone https://github.com/TransDecoder/TransDecoder.git && \
   cd TransDecoder && \
   git checkout $TRANSDECODER_CO && \
   mv * $BIN