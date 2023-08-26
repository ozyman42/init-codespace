FROM ubuntu:focal
ENV USER_HOME=/root
RUN apt-get update && apt-get upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    make \
    unzip \
    build-essential \
    swig3.0 \
    moreutils \
    rsync \
    zip \
    libgdiplus \
    jq \
    sqlite3 \
    wget \
    curl \
    software-properties-common \
    git \
    sudo \
    tmux \
    openssh-server \
    ca-certificates \
    gnupg \
    apt-transport-https

# =========
# DOCKER
# =========
# https://docs.docker.com/engine/install/ubuntu/
RUN sudo install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN sudo chmod a+r /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN sudo apt-get update
RUN sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# ========== 
# KUBERNETES
# ==========
# https://kind.sigs.k8s.io/docs/user/quick-start#installation
RUN [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
RUN chmod +x ./kind
RUN sudo mv ./kind /usr/local/bin/kind
# https://www.cherryservers.com/blog/install-kubectl-ubuntu
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x ./kubectl
RUN sudo mv ./kubectl /usr/local/bin/kubectl

# =========
# GCLOUD
# =========
# https://cloud.google.com/sdk/docs/install-sdk#deb
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN sudo apt-get update && sudo apt-get install google-cloud-cli

# =========
# TERRAFORM
# =========
RUN sudo apt install gpg-agent
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
RUN sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN sudo apt update
RUN sudo apt install terraform

# ========
# NODE
# ========
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=$USER_HOME/.nvm
ENV NODE_VERSION=20.3.0
RUN . "$NVM_DIR/nvm.sh" && nvm install $NODE_VERSION
RUN . "$NVM_DIR/nvm.sh" && nvm use v$NODE_VERSION
ENV PATH="${USER_HOME}/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN npm i -g pnpm

# ========
# RUST
# ========
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="${USER_HOME}/.cargo/bin:${PATH}"

# ========
# JAVA
# ========
RUN DEBIAN_FRONTEND=noninteractive apt install -y openjdk-17-jdk
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# ========
# ANDROID
# ========
# https://developer.android.com/tools
# https://developer.android.com/studio#command-line-tools-only
WORKDIR $USER_HOME
ENV ANDROID_HOME="${USER_HOME}/.android"
ENV ANDROID_ZIP_NAME="commandlinetools-linux-9477386_latest.zip"
RUN wget "https://dl.google.com/android/repository/$ANDROID_ZIP_NAME"
RUN unzip $ANDROID_ZIP_NAME
RUN rm $ANDROID_ZIP_NAME
RUN mkdir -p .android/cmdline-tools
RUN mv cmdline-tools ./.android/cmdline-tools/latest
ENV PATH="${PATH}:${USER_HOME}/.android/cmdline-tools/latest/bin"
RUN yes | sdkmanager --licenses
RUN sdkmanager "platforms;android-33" "platform-tools" "build-tools;33.0.0" "emulator" "ndk;25.2.9519653"
ENV PATH="${PATH}:${USER_HOME}/.android/platform-tools"
# We can't use the x86_64 version as this requires hardware acceleration which codespaces doesn't support so I tried ARM
# However ARM doesn't work either, so instead we're trying mesh VPN, see:
# - https://www.reddit.com/r/androiddev/comments/11fzzjk/how_android_devs_can_use_github_codespaces/
# - https://tailscale.com/kb/1160/github-codespaces/

# ========
# TAURI
# ========
# https://next--tauri.netlify.app/next/guides/getting-started/prerequisites/linux
RUN DEBIAN_FRONTEND=noninteractive apt install -y \
  libwebkit2gtk-4.0-dev \
  build-essential \
  libssl-dev \
  libgtk-3-dev \
  libayatana-appindicator3-dev \
  librsvg2-dev
RUN rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android

# ============
# NATIVESCRIPT
# ============
RUN npm install -g nativescript@8.5.3
RUN ns doctor android

# ==========
# CAPACITOR
# ==========
RUN npm install -g @capacitor/cli

# ========
# CLEANUP
# ========
RUN rm -rf /var/lib/apt/lists/*
