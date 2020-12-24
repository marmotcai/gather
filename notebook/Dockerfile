FROM python:3.7 AS python-jupyter-notebook

LABEL maintainer="marmotcai@163.com"

ENV APP_DIR="/workspaces/app"
ENV DATA_PATH="/workspaces/data"

#######################################################

ENV PIP_MIRRORS_URL="https://mirrors.aliyun.com/pypi/simple"
ENV PIP_MIRRORS_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

RUN python -m pip install --upgrade pip -i ${PIP_MIRRORS_URL}
RUN pip install jupyter pandas numpy tensorflow
# -i ${PIP_MIRRORS_URL}

# ADD requirements.txt .
# RUN pip install -r requirements.txt -i ${PIP_MIRRORS_URL}

RUN jupyter notebook --generate-config

ENV JUPYTER_NOTEBOOK_CONFIG "/root/.jupyter/jupyter_notebook_config.py"

RUN sed -i '/c.NotebookApp.ip/a\c.NotebookApp.ip = "0.0.0.0"' ${JUPYTER_NOTEBOOK_CONFIG}
RUN cat ${JUPYTER_NOTEBOOK_CONFIG} | grep c.NotebookApp.ip

RUN sed -i '/c.NotebookApp.notebook_dir/a\c.NotebookApp.notebook_dir = "/workspaces/data"' ${JUPYTER_NOTEBOOK_CONFIG}
RUN cat ${JUPYTER_NOTEBOOK_CONFIG} | grep c.NotebookApp.notebook_dir

RUN sed -i '/c.NotebookApp.open_browser/a\c.NotebookApp.open_browser = True' ${JUPYTER_NOTEBOOK_CONFIG}
RUN cat ${JUPYTER_NOTEBOOK_CONFIG} | grep c.NotebookApp.open_browser

RUN sed -i '/c.ConnectionFileMixin.ip/a\c.ConnectionFileMixin.ip = "*"' ${JUPYTER_NOTEBOOK_CONFIG}
RUN cat ${JUPYTER_NOTEBOOK_CONFIG} | grep c.ConnectionFileMixin.ip

RUN sed -i '/c.NotebookApp.port/a\c.NotebookApp.port = 80' ${JUPYTER_NOTEBOOK_CONFIG}
RUN cat ${JUPYTER_NOTEBOOK_CONFIG} | grep c.NotebookApp.port

RUN sed -i '/c.NotebookApp.token/a\c.NotebookApp.token = "aa112233"' ${JUPYTER_NOTEBOOK_CONFIG}
RUN cat ${JUPYTER_NOTEBOOK_CONFIG} | grep c.NotebookApp.token

RUN echo "work dir: " ${APP_DIR}
WORKDIR ${APP_DIR}
RUN ls -l

VOLUME $DATA_PATH

RUN echo $DATA_PATH

# #######################################################
# 
EXPOSE 80
# 
CMD ["jupyter", "notebook", "--allow-root"]
# 
# #######################################################
