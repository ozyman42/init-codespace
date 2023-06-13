FROM ubuntu:focal
ENV USER_HOME=/root
RUN apt-get update \
  && apt-get upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    make \
    unzip \
    # The tools in this package are used when installing packages for Python
    build-essential \
    swig3.0 \
    # Required for ts
    moreutils \
    rsync \
    zip \
    libgdiplus \
    jq \
    # Others
    sqlite3 \
    wget \
    curl \
    software-properties-common \
    git \
    sudo \
    tmux \
    # My stuff
  # This is the folder containing 'links' to benv and build script generator
  && apt-get update \
  && apt-get upgrade -y \
  && add-apt-repository main \
  && add-apt-repository restricted \
  && add-apt-repository universe \
  && add-apt-repository multiverse

# ========
# NODE
# ========
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=$USER_HOME/.nvm
ENV NODE_VERSION=20.3.0
RUN . "$NVM_DIR/nvm.sh" && nvm install $NODE_VERSION
RUN . "$NVM_DIR/nvm.sh" && nvm use v$NODE_VERSION
ENV PATH="${USER_HOME}/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version
RUN npm i -g pnpm
RUN pnpm setup
RUN source ~/.bashrc

# ========
# RUST
# ========
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="${USER_HOME}/.cargo/bin:${PATH}"

# ========
# JAVA
# ========
RUN DEBIAN_FRONTEND=noninteractive apt install -y openjdk-14-jdk
ENV JAVA_HOME=/usr/lib/jvm/java-14-openjdk-amd64

# ========
# ANDROID
# ========
ENV ANDROID_HOME="${USER_HOME}/.android"

# Method 1 (via IDE)
# https://adamtheautomator.com/android-studio/
# https://www.youtube.com/watch?v=nqQkxKiOht4
# RUN add-apt-repository ppa:maarten-fonville/android-studio
# RUN apt-get update
# RUN DEBIAN_FRONTEND=noninteractive apt install -y android-studio

# Method 2 (via command line tools)
# https://developer.android.com/tools/sdkmanager
RUN DEBIAN_FRONTEND=noninteractive apt install -y android-sdk
RUN yes | sdkmanager --licenses
RUN sdkmanager "build-tools" "cmdline-tools" "emulator" "ndk" "patcher" "platform-tools" "platforms;android-34"

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
RUN pnpm add -g nativescript
RUN ns doctor android

# ========
# CLEANUP
# ========
RUN rm -rf /var/lib/apt/lists/*
