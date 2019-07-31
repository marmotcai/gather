FROM jupyter/tensorflow-notebook AS tensorflow

MAINTAINER marmotcai "marmotcai@163.com"

RUN pip install tensorflow==2.0.0-beta0
RUN pip install --pre jupyter-tensorboard
RUN pip install tensorlayer
RUN pip install keras
RUN pip install nltk
RUN pip install pandas
RUN pip install tushare
RUN pip install matplotlib
RUN pip install plotly
RUN pip install arrow
RUN pip install tflearn

USER root
# RUN chown jovyan.users data -R
