FROM alpine/git:2.40.1 AS git_binary
FROM linuxserver/openssh-server:amd64-version-9.3_p2-r0 AS openssh_server_binary
FROM keinos/sqlite3:3.42.0 AS sqlite_binary
FROM rancher/k3d:5.3.0-dind-linux-amd64 AS kubernetes_binary
FROM google/cloud-sdk:444.0.0-alpine AS gcloud_binary
FROM hashicorp/terraform:1.5.5 as terraform_binary
FROM node:alpine3.18 as node_binary
RUN corepack prepare pnpm@8.7.1 --activate
RUN corepack enable
FROM python:3.9-alpine3.18 as python_binary

FROM node_binary as node_gyp_installer
# Install Python
COPY --from=python_binary /usr/local/bin/python3 /usr/local/bin/python3
COPY --from=python_binary /usr/local/lib/libpython3.9.so.1.0 /usr/local/lib/libpython3.9.so.1.0
COPY --from=python_binary /usr/local/bin/pip /usr/local/bin/pip
COPY --from=python_binary /usr/local/bin/pip3 /usr/local/bin/pip3
COPY --from=python_binary /usr/local/lib/python3.9/ /usr/local/lib/python3.9/
# libpython3.so
# pkgconfig
ENV PYTHON /usr/local/bin/python3
ENV PYTHONHOME /usr/local
RUN apk add make g++

FROM node_gyp_installer as cdktf_binary
ENV PNPM_HOME /usr/local/bin
RUN pnpm install -g cdktf-cli

FROM rust:alpine3.18 as rust_binary
FROM alpine:3.18 as alpine_installer
RUN apk add \
    sudo \
    bash
FROM alpine:3.18
COPY startup.sh /tmp/startup.sh
RUN chmod +x /tmp/startup.sh

# Install sudo
COPY --from=alpine_installer /usr/bin/sudo /usr/bin/sudo
COPY --from=alpine_installer /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=alpine_installer /usr/lib/sudo/libsudo_util.so.0 /usr/lib/sudo/libsudo_util.so.0
COPY --from=alpine_installer /usr/lib/sudo/sudoers.so /usr/lib/sudo/sudoers.so

# Install bash
COPY --from=alpine_installer /bin/bash /bin/bash
# COPY --from=alpine_installer /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=alpine_installer /usr/lib/libreadline.so.8 /usr/lib/libreadline.so.8
COPY --from=alpine_installer /usr/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6

# Install git
COPY --from=git_binary /usr/bin/git /usr/bin/git
# COPY --from=git_binary /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=git_binary /usr/lib/libpcre2-8.so.0 /usr/lib/libpcre2-8.so.0
# COPY --from=git_binary /lib/libz.so.1 /lib/libz.so.1

# Install OpenSSH Server
COPY --from=openssh_server_binary /usr/sbin/sshd.pam /usr/sbin/sshd
COPY --from=openssh_server_binary /usr/bin/ssh-keygen /usr/bin/ssh-keygen
COPY --from=openssh_server_binary /usr/bin/ssh /usr/bin/ssh
# COPY --from=openssh_server_binary /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
# COPY --from=openssh_server_binary /lib/libz.so.1 /lib/libz.so.1
COPY --from=openssh_server_binary /lib/libcrypto.so.3 /lib/libcrypto.so.3
COPY --from=openssh_server_binary /lib/libpam.so.0 /lib/libpam.so.0
COPY --from=openssh_server_binary /etc/ssh/sshd_config /etc/ssh/sshd_config
# RUN adduser -D -s /bin/false sshd
# RUN mkdir /var/empty && chown root:root /var/empty && chmod 755 /var/empty

# Install SQLite
COPY --from=sqlite_binary /usr/bin/sqlite3 /usr/bin/sqlite3
# COPY --from=sqlite_binary /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
# COPY --from=sqlite_binary /lib/libz.so.1 /lib/libz.so.1

# Install docker
# We enable the "docker-in-docker" feature in vscode devcontainer
# https://github.com/devcontainers/features/tree/main/src/docker-in-docker
# https://www.youtube.com/watch?v=gVDIAU2TuZs

# Install Kubernetes (k3d)
COPY --from=kubernetes_binary /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=kubernetes_binary /bin/k3d /bin/k3d

# Install GCloud
COPY --from=gcloud_binary /google-cloud-sdk/bin/gcloud /bin/gcloud

# Install Node and PNPM
COPY --from=node_binary /usr/local/bin/node /usr/local/bin/node
# COPY --from=node_binary /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=node_binary /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=node_binary /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1
RUN ln -s /usr/local/lib/node_modules/corepack/dist/pnpm.js /usr/local/bin/pnpm
RUN ln -s /usr/local/lib/node_modules/corepack/dist/pnpx.js /usr/local/bin/pnpx
COPY --from=node_binary /usr/local/lib/node_modules/corepack /usr/local/lib/node_modules/corepack
ENV PNPM_HOME /usr/local/bin
# Musl library may be required?

# Install Terraform
COPY --from=terraform_binary /bin/terraform /bin/terraform
COPY --from=cdktf_binary /usr/local/bin/cdktf /usr/local/bin/cdktf
COPY --from=cdktf_binary /usr/local/bin/global /usr/local/bin/global

# Install Rust
COPY --from=rust_binary /usr/local/cargo/bin /usr/local/cargo/bin
ENV PATH $PATH:/usr/local/cargo/bin

# Install Java


# Install Android


# Install Tauri
# TODO: waiting for ecosystem to mature a bit

# Install NativeScript
# TODO: we'll see if I ever try native script again

# Install Capacitor

# User setup
ENV USER ozy
RUN adduser -D $USER
RUN echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chown $USER -R /usr/local/bin
USER $USER
WORKDIR /home/$USER
COPY .bashrc .bashrc
RUN mkdir .ssh
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDqv2GX5EijhgCIJ7f+0wHcVDCHAxLT7pYIWLxZ+3rLK alex.l.leung@gmail.com" >> .ssh/authorized_keys

# Start
ENTRYPOINT ["/tmp/startup.sh"]
CMD ["bash"]
