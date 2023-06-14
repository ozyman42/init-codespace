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
    tmux

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
RUN pwd
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

# ========
# CLEANUP
# ========
RUN rm -rf /var/lib/apt/lists/*
