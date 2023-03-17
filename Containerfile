ARG ALPINE_VERSION=3.16.2
# ╭――――――――――――――――---------------------------------------------------------――╮
# │                                                                           │
# │ STAGE 1: configure-python -- Pull and configure the python environment    │
# │                                                                           │
# ╰―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――╯
FROM gautada/alpine:$ALPINE_VERSION as configure-python

# ╭――――――――――――――――――――╮
# │ METADATA           │
# ╰――――――――――――――――――――╯
LABEL version="2022-10-18"
LABEL source="https://github.com/gautada/python-container.git"
LABEL maintainer="Adam Gautier <adam@gautier.org>"
LABEL description="Container that provides a python development environment."

# ╭――――――――――――――――――――╮
# │ ENVIRONMENT        │
# ╰――――――――――――――――――――╯
COPY python.sh /etc/profile.d/python.sh
# RUN /bin/ln -s /opt/development/awscli.credentials /etc/container/configmap.d/awscli.credentials \
# && /bin/ln -s /opt/development/awscli.config /etc/container/configmap.d/awscli.config

# ╭――――――――――――――――――――╮
# │ ENTRYPOINT         │
# ╰――――――――――――――――――――╯
# COPY 10-ep-container.sh /etc/container/entrypoint.d/10-ep-container.sh
RUN /bin/rm /etc/container/entrypoint
COPY entrypoint /etc/container/entrypoint

# ╭――――――――――――――――――――╮
# │ PACKAGES           │
# ╰――――――――――――――――――――╯
RUN /sbin/apk add --no-cache build-base git nodejs npm openssh-client openssh python3 py3-pip yarn

RUN /sbin/apk add --no-cache py3-cffi cargo linux-headers python3-dev
RUN /sbin/apk add --no-cache py3-pandas py3-matplotlib

# ╭――――――――――――――――――――╮
# │ SUDO               │
# ╰――――――――――――――――――――╯
# COPY wheel-sshd /etc/container/wheel.d/wheel-sshd
# COPY wheel-ssh-keygen /etc/container/wheel.d/wheel-ssh-keygen
COPY wetty-wheel /etc/container/wetty-wheel
RUN /bin/ln -fsv /etc/container/wetty-wheel /etc/sudoers.d/wetty-wheel

# ╭――――――――――――――――――――╮
# │ USER               │
# ╰――――――――――――――――――――╯
ARG USER=python
# VOLUME /opt/$USER
RUN /bin/mkdir -p /opt/$USER \
 && /usr/sbin/addgroup $USER \
 && /usr/sbin/adduser -D -s /bin/ash -G $USER $USER \
 && /usr/sbin/usermod -aG wheel $USER \
 && /bin/echo "$USER:$USER" | chpasswd
# && /bin/chown $USER:$USER -R /opt/$USER
USER $USER
WORKDIR /home/$USER

# ╭――――――――――――――――――――╮
# │ PORTS              │
# ╰――――――――――――――――――――╯
EXPOSE 8080

# ╭――――――――――――――――――――╮
# │ CONFIGURE          │
# ╰――――――――――――――――――――╯
# RUN /usr/bin/pip3 install --upgrade pip \
#  && /usr/bin/yarn global add wetty

RUN /usr/bin/pip3 install jupyterlab 
RUN /usr/bin/pip3 install yfinance 

# RUN /usr/bin/pip3 install pandas-datareader
# RUN /usr/bin/pip3 install matplotlib

# COPY client.py /home/python/client.py
# USER root
