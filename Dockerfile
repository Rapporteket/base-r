FROM rocker/r-ver:4.2.2

LABEL maintainer "Are Edvardsen <are.edvardsen@helse-nord.no>"

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl3-gnutls \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libxml2-dev \
    libssl-dev \
    libmariadb-dev \
    libmysqlclient21 \
    lmodern \
    locales \
    wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set norsk bokmaal as default system locale
RUN sed -i 's/^# *\(nb_NO.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen \
    && echo "LANG=\"nb_NO.UTF-8\"" > /etc/default/locale \
    && update-locale LANG=nb_NO.utf8

ENV LC_ALL=nb_NO.UTF-8
ENV LANG=nb_NO.UTF-8
ENV TZ=Europe/Oslo

# install R package dependencies and TinyTeX
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN install2.r --error --skipinstalled --ncpus -1 \
    rapbase \
    remotes \
    && rm -rf /tmp/downloaded_packages \ 
    && wget -qO- "https://yihui.org/tinytex/install-unx.sh" | sh -s - --admin --no-path \
    && mv /root/.TinyTeX /opt/.TinyTeX \
    && /opt/.TinyTeX/bin/x86_64-linux/tlmgr path add \
    && tlmgr install \
        amsmath \
        babel-norsk \
        bigintcalc \
        bitset \
        booktabs \
        caption \
        collection-langeuropean \
        datetime \
        epstopdf-pkg \
        eso-pic \
        etexcmds \
        etoolbox \
        fancyhdr \
        float \
        fmtcount \
        fontaxes \
        framed \
        geometry \
        gettitlestring \
        grfext \
        hycolor \
        hyperref \
        hyphen-norwegian \
        intcalc \
        kvdefinekeys \
        kvsetkeys \
        lastpage \
        latex-amsmath-dev \
        lato \
        letltxmacro \
        ltxcmds \
        marginnote \
        microtype \
        oberdiek \
        pdfescape \
        pdflscape \
        pdfpages \
        ragged2e \
        refcount \
        rerunfilecheck \
        sectsty \
        stringenc \
        subfig \
        textpos \
        titlesec \
        ucs \
        uniquecounter \
        xcolor \
        zapfding

CMD ["R"]
