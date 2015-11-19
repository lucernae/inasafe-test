#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM ubuntu:precise
MAINTAINER Tim Sutton<tim@kartoza.com>

RUN echo "deb http://qgis.org/debian-ltr precise main" >> /etc/apt/sources.list
RUN echo "deb http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu precise main" >> /etc/apt/sources.list
RUN apt-get update -y

#-------------Application Specific Stuff ----------------------------------------------------
RUN apt-get install -y \
    build-essential \
    xvfb \
    x-ttcidfont-conf \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-scalable \
    xfonts-cyrillic \
    git \
    python-pip \
    xvfb \
    python-nose \
    python-coverage \
    pyflakes \
    python-nosexcover \
    python-scientific \
    python-dev

RUN pip install --upgrade pip pep8 pylint numpy

#RUN gpg --keyserver keyserver.ubuntu.com --recv 3FF5FFCAD71472C4
#RUN gpg --export --armor 3FF5FFCAD71472C4 | sudo apt-key add -
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key 3FF5FFCAD71472C4

RUN apt-get install -y --force-yes \
    qgis \
    python-qgis

#ENV QGIS_PREFIX_PATH /usr
#ENV PYTHONPATH ${QGIS_PREFIX_PATH}/share/qgis/python/:${QGIS_PREFIX_PATH}/share/qgis/python/plugins:
#ENV LD_LIBRARY_PATH ${QGIS_PREFIX_PATH}/share/qgis/python/plugins/
#ENV LD_LIBRARY_PATH ${QGIS_PREFIX_PATH}/lib

# This section taken on 2 July 2015 from
# https://docs.docker.com/examples/running_ssh_service/
# Sudo is needed by pycharm when it tries to pip install packages
RUN apt-get update && apt-get install -y openssh-server sudo
RUN mkdir /var/run/sshd
RUN echo 'root:docker' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Open port 22 as we will be using a remote interpreter from pycharm
EXPOSE 22

# End of cut & paste section

# Mount inasafe and insafe_data under /

ADD run-test.sh /run-test.sh
RUN chmod +x /run-test.sh
RUN mkdir -p /home/test/inasafe
WORKDIR /home/test/inasafe
RUN echo "Xvfb :99 &" >> ~/.bashrc
RUN echo "export DISPLAY=:99" >> ~/.bashrc
RUN echo "source /home/test/inasafe/run-env-linux.sh /usr" >> ~/.bashrc

#ENTRYPOINT ["make"]


# Here we list packages to test by default
#CMD ["safe_qgis"]
#CMD ["/run-test.sh"]
CMD ["/usr/sbin/sshd", "-D"]
