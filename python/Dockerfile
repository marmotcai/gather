FROM python AS python-builder

MAINTAINER marmotcai "marmotcai@163.com"

RUN apt update && \
    apt install -y vim

RUN sed -i '$a\alias ll=\"ls -alF\"' ~/.bashrc
RUN sed -i '$a\alias la=\"ls -A\"' ~/.bashrc
RUN sed -i '$a\alias l=\"ls -CF\"' ~/.bashrc

ENV WORK_DIR=/root
WORKDIR ${WORK_DIR}

ENV APP_NAME=easyquotation
ENV APP_GIT_URL=https://github.com/shidenggui/easyquotation.git

RUN git clone $APP_GIT_URL

RUN cd $APP_NAME && \
    python setup.py install

# ENTRYPOINT [ "python" ]
