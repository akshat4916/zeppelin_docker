FROM ubuntu:18.04
 
ENV ZEPPELIN_PORT 8080
ENV ZEPPELIN_HOME /usr/local/zeppelin
ENV DEBIAN_FRONTEND=noninteractive
 
EXPOSE $ZEPPELIN_PORT
 
#install java
RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository ppa:openjdk-r/ppa && \     
  apt-get update && \
  apt-get install -y openjdk-8-jdk
 
#install other
RUN apt-get install -y \
  npm \
  vim \
  wget

#install conda befoer numpy
RUN apt-get -y update && \
	apt-get install -y bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
ENV PATH /opt/conda/bin:$PATH

RUN echo "Install python related packages" && \
    apt-get -y update && \
    apt-get install -y python-dev python-pip && \
    apt-get install -y gfortran && \
    # numerical/algebra packages
    apt-get install -y libblas-dev libatlas-base-dev liblapack-dev && \
    # font, image
    apt-get install -y libpng-dev libfreetype6-dev libxft-dev && \
    # for tkinter
    apt-get install -y python-tk libxml2-dev libxslt-dev zlib1g-dev && \
    pip install --upgrade pip && \
    pip install numpy==1.18.1 pandas==1.0.0 matplotlib==3.1.3 pandasql==0.7.3 ipython==7.12.0 jupyter_client==5.3.4 ipykernel==5.1.4 bokeh==1.4.0 ggplot==0.11.5 grpcio==1.26.0 bkzep==0.6.1 scikit-learn==0.22.1
 
#install Zeppelin
RUN wget http://apache.cs.utah.edu/zeppelin/zeppelin-0.8.1/zeppelin-0.8.1-bin-all.tgz && \
  tar -zxf zeppelin-0.8.1-bin-all.tgz -C /usr/local/ && \
  mv /usr/local/zeppelin* $ZEPPELIN_HOME
 
WORKDIR $ZEPPELIN_HOME
CMD bin/zeppelin.sh