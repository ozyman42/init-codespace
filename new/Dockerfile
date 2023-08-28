FROM alpine/git:2.40.1 AS git_binary
FROM linuxserver/openssh-server:amd64-version-9.3_p2-r0 AS openssh_server_binary
FROM keinos/sqlite3:3.42.0 AS sqlite_binary
FROM debian:12.1-slim as apt_installer
RUN apt-get update && apt-get -y install \
    # sudo
    sudo=1.9.13p3-1+deb12u1

FROM debian:12.1-slim
COPY startup.sh /tmp/startup.sh
RUN chmod +x /tmp/startup.sh

# Install sudo
COPY --from=apt_installer /usr/bin/sudo /usr/bin/sudo
COPY --from=apt_installer /lib/x86_64-linux-gnu/libaudit.so.1 /lib/x86_64-linux-gnu/libaudit.so.1
COPY --from=apt_installer /lib/x86_64-linux-gnu/libselinux.so.1 /lib/x86_64-linux-gnu/libselinux.so.1
COPY --from=apt_installer /usr/libexec/sudo/libsudo_util.so.0 /usr/libexec/sudo/libsudo_util.so.0
COPY --from=apt_installer /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so.6
COPY --from=apt_installer /lib/x86_64-linux-gnu/libcap-ng.so.0 /lib/x86_64-linux-gnu/libcap-ng.so.0
COPY --from=apt_installer /lib/x86_64-linux-gnu/libpcre2-8.so.0 /lib/x86_64-linux-gnu/libpcre2-8.so.0
COPY --from=apt_installer /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
COPY --from=apt_installer /usr/libexec/sudo/sudoers.so /usr/libexec/sudo/sudoers.so

# Install git
COPY --from=git_binary /usr/bin/git /usr/bin/git
COPY --from=git_binary /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=git_binary /usr/lib/libpcre2-8.so.0 /usr/lib/libpcre2-8.so.0
COPY --from=git_binary /lib/libz.so.1 /lib/libz.so.1

# Install OpenSSH Server
COPY --from=openssh_server_binary /usr/sbin/sshd.pam /usr/sbin/sshd
COPY --from=openssh_server_binary /usr/bin/ssh-keygen /usr/bin/ssh-keygen
COPY --from=openssh_server_binary /usr/bin/ssh /usr/bin/ssh
# COPY --from=openssh_server_binary /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
# COPY --from=openssh_server_binary /lib/libz.so.1 /lib/libz.so.1
COPY --from=openssh_server_binary /lib/libcrypto.so.3 /lib/libcrypto.so.3
COPY --from=openssh_server_binary /lib/libpam.so.0 /lib/libpam.so.0
COPY --from=openssh_server_binary /etc/ssh/sshd_config /etc/ssh/sshd_config
RUN useradd -r -s /bin/false sshd
RUN mkdir /var/empty && chown root:root /var/empty && chmod 755 /var/empty

# Install SQLite
COPY --from=sqlite_binary /usr/bin/sqlite3 /usr/bin/sqlite3
# COPY --from=sqlite_binary /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
# COPY --from=sqlite_binary /lib/libz.so.1 /lib/libz.so.1

# Install docker
# We enable the "docker-in-docker" feature in vscode devcontainer
# https://github.com/devcontainers/features/tree/main/src/docker-in-docker
# https://www.youtube.com/watch?v=gVDIAU2TuZs

# Install Kubernetes (in Docker) (kind)


# Install GCloud


# Install Terraform


# Install Node and PNPM


# Install Rust


# Install Java


# Install Android


# Install Tauri


# Install NativeScript


# Install Capacitor

# User setup
ENV USER ozy
RUN adduser $USER
# https://unix.stackexchange.com/questions/193066/how-to-unlock-account-for-public-key-ssh-authorization-but-not-for-password-aut
RUN usermod -p '*' $USER
RUN echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER $USER
WORKDIR /home/$USER
COPY .bashrc .bashrc
RUN mkdir .ssh
RUN echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDqv2GX5EijhgCIJ7f+0wHcVDCHAxLT7pYIWLxZ+3rLK alex.l.leung@gmail.com" >> .ssh/authorized_keys

# Start
ENTRYPOINT ["/tmp/startup.sh"]