FROM rocker/r-base:4.2.1

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
    lmodern \
    locales \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set norsk bokmaal as default system locale
RUN sed -i 's/^# *\(nb_NO.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen \
    && echo "LANG=\"nb_NO.UTF-8\"" > /etc/default/locale \
    && update-locale LANG=nb_NO.utf8

ENV LC_ALL=nb_NO.UTF-8
ENV LANG=nb_NO.UTF-8
ENV TZ=Europe/Oslo

# install package dependencies
RUN R -e "install.packages(c(\"rapbase\", \"remotes\", \"tinytex\"))" \
    && R -e "tinytex::install_tinytex()" \
    && R -e "tinytex::tlmgr_install(c(\"hyphen-norwegian\", \
                                      \"collection-langeuropean\", \
                                      \"datetime\", \
                                      \"fmtcount\", \
                                      \"sectsty\", \
                                      \"marginnote\", \
                                      \"babel-norsk\", \
                                      \"lato\", \
                                      \"fontaxes\", \
                                      \"caption\", \
                                      \"fancyhdr\", \
                                      \"lastpage\", \
                                      \"textpos\", \
                                      \"titlesec\", \
                                      \"framed\", \
                                      \"ragged2e\", \
                                      \"ucs\", \
                                      \"subfig\", \
                                      \"eso-pic\", \
                                      \"grfext\", \
                                      \"oberdiek\", \
                                      \"pdfpages\", \
                                      \"microtype\", \
                                      \"pdflscape\"))"

CMD ["R"]
