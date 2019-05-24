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

#ENV MYSQL_PYTHON_URL="https://nchc.dl.sourceforge.net/project/mysql-python/mysql-python-test/1.2.4b4/MySQL-python-1.2.2.tar.gz"
#RUN wget -O ${WORK_DIR}/mysql_python_url.tar.gz ${MYSQL_PYTHON_URL} && \
#    tar -zxvf ${WORK_DIR}/MySQL-python.tar.gz -C ${WORK_DIR}/MySQL-python && \
#    rm -f ${WORK_DIR}/MySQL-python.tar.gz && cd ${WORK_DIR}/MySQL-python && \
#    python setup.py build && python setup.py install

RUN python -m pip install --upgrade --force pip
RUN pip install setuptools==33.1.1
RUN pip install distribute

RUN pip install MySQL-python

WORKDIR $WORK_DIR

# ENTRYPOINT [ "/bin/bash" ]
