FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

ARG SSH_USER=tunnel
ARG SSH_PASSWORD=changeme

ENV SSH_USER=${SSH_USER}
ENV SSH_PASSWORD=${SSH_PASSWORD}

RUN apt-get update && apt-get install -y openssh-server passwd && mkdir /var/run/sshd

RUN useradd -m -s /bin/bash $SSH_USER && \
    echo "$SSH_USER:$SSH_PASSWORD" | chpasswd

RUN echo "PermitTunnel yes" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config && \
    echo "PermitOpen any" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
