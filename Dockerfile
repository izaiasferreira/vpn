FROM ubuntu:22.04

ARG SSH_USER=tunnel
ARG SSH_PASSWORD=t#nn3l

RUN apt-get update && \
    apt-get install -y openssh-server sudo && \
    mkdir /var/run/sshd

# Cria usuário e senha corretamente
RUN useradd -m -s /bin/bash "$SSH_USER" && \
    echo "$SSH_USER:$SSH_PASSWORD" | chpasswd --crypt-method=SHA512 && \
    usermod -aG sudo "$SSH_USER"

# Configurações do SSH
RUN echo "PermitTunnel yes" >> /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config && \
    echo "PermitOpen any" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
