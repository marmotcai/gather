FROM python AS python-builder

MAINTAINER marmotcai "marmotcai@163.com"

ENV WORK_DIR=/root
WORKDIR ${WORK_DIR}

ENV APP_NAME=easyquotation
ENV APP_GIT_URL=https://github.com/shidenggui/easyquotation.git

RUN git clone $APP_GIT_URL

#RUN cd $APP_NAME && \
#    python setup.py install

# ENTRYPOINT [ "python" ]
