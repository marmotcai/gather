FROM python:3 AS base

MAINTAINER marmotcai "marmotcai@163.com"

#######################################################

RUN sed -i '$a\alias ll=\"ls -alF\"' ~/.bashrc
RUN sed -i '$a\alias la=\"ls -A\"' ~/.bashrc
RUN sed -i '$a\alias l=\"ls -CF\"' ~/.bashrc

RUN apt-get update && \
    apt-get install -y wget vim openssh-server && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && \
    echo "root:112233" | chpasswd && \
    mkdir /var/run/sshd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

#######################################################

FROM base AS python-base

ARG REQUIREMENTS_URL="NULL"

ENV PIP_ALIYUN_URL="https://mirrors.aliyun.com/pypi/simple"
ENV PIP_TSINGHUA_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

ENV WORK_DIR=/root
WORKDIR ${WORK_DIR}

RUN pip install -i ${PIP_ALIYUN_URL} --upgrade pip && \
    pip -V && python -V

# RUN pip install --upgrade pip

ADD requirements.txt .
RUN pip install -i ${PIP_ALIYUN_URL} -r requirements.txt

RUN echo ${REQUIREMENTS_URL}
RUN if [ "${REQUIREMENTS_URL}" != "NULL" ] ; then wget -O requirements.txt ${REQUIREMENTS_URL} ; \
						  # pip install -i ${PIP_INDEX_URL} --no-cache-dir -r requirements.txt ; \
						  pip install --no-cache-dir -r requirements.txt ; \
						  fi
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

#######################################################

FROM python-base AS python-jupyter-notebook

ENV APP_PATH=${WORK_DIR}/data

WORKDIR $APP_PATH

RUN pip install -i ${PIP_ALIYUN_URL} jupyter

RUN jupyter notebook --generate-config

ENV JUPYTER_NOTEBOOK_CONFIG "/root/.jupyter/jupyter_notebook_config.py"

RUN sed -i '/#c.NotebookApp.ip/a\c.NotebookApp.ip = "0.0.0.0"' ${JUPYTER_NOTEBOOK_CONFIG}
RUN cat ${JUPYTER_NOTEBOOK_CONFIG} | grep c.NotebookApp.ip

RUN sed -i '/#c.NotebookApp.notebook_dir/a\c.NotebookApp.notebook_dir = "/root/data"' ${JUPYTER_NOTEBOOK_CONFIG}
RUN cat ${JUPYTER_NOTEBOOK_CONFIG} | grep c.NotebookApp.notebook_dir

RUN sed -i '/#c.NotebookApp.open_browser/a\c.NotebookApp.open_browser = True' ${JUPYTER_NOTEBOOK_CONFIG}
RUN cat ${JUPYTER_NOTEBOOK_CONFIG} | grep c.NotebookApp.open_browser

RUN sed -i '/#c.ConnectionFileMixin.ip/a\c.ConnectionFileMixin.ip = "*"' ${JUPYTER_NOTEBOOK_CONFIG}
RUN cat ${JUPYTER_NOTEBOOK_CONFIG} | grep c.ConnectionFileMixin.ip

RUN sed -i '/#c.NotebookApp.port/a\c.NotebookApp.port = 8888' ${JUPYTER_NOTEBOOK_CONFIG}
RUN cat ${JUPYTER_NOTEBOOK_CONFIG} | grep c.NotebookApp.port

VOLUME $APP_PATH

RUN echo $APP_PATH

#######################################################

EXPOSE 22 8888

CMD ["jupyter", "notebook", "--allow-root"]
# CMD ["/usr/sbin/sshd", "-D"]

#######################################################



