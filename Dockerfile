FROM ubuntu:focal
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
        tmux \
        software-properties-common \
        # My stuff
    && rm -rf /var/lib/apt/lists/* \
    # This is the folder containing 'links' to benv and build script generator
    && apt-get update \
    && apt-get upgrade -y \
    && add-apt-repository universe \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
RUN npm i -g pnpm
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# https://next--tauri.netlify.app/next/guides/getting-started/prerequisites/linux
RUN apt install -y \
    libwebkit2gtk-4.0-dev \
    build-essential \
    libssl-dev \
    libgtk-3-dev \
    libayatana-appindicator3-dev \
    librsvg2-dev
RUN rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android
# Standalone install
RUN apt install -y default-jdk
RUN export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O cmdline-tools.zip
RUN unzip cmdline-tools.zip
RUN mkdir -p ~/.android/cmdline-tools/latest
RUN mv cmdline-tools/* ~/.android/cmdline-tools/latest
RUN rm -d cmdline-tools
RUN rm cmdline-tools.zip
RUN export ANDROID_HOME="$HOME/.android"
RUN export NDK_HOME="$ANDROID_HOME/ndk/25.0.8775105"
RUN export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin/"
RUN yes | sdkmanager --licenses
RUN sdkmanager "platforms;android-33" "platform-tools" "ndk;25.0.8775105" "build-tools;33.0.0"