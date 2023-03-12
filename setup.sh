#!/bin/bash
sudo apt-get update
sudo apt-get install tmux -y
sudo apt-get install xauth -y
npm i -g pnpm
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
node -e "p=require('path');f=require('fs');let l=p.resolve('/home/codespace/.vscode-remote/data/Machine/settings.json'); \
        let c=JSON.parse(f.readFileSync(l).toString());c['workbench.colorTheme']='Default Dark+'; \
        fs.writeFileSync(l, JSON.stringify(c, null, 2))"
# https://next--tauri.netlify.app/next/guides/getting-started/prerequisites/linux
sudo apt install -y libwebkit2gtk-4.0-dev \
    build-essential \
    libssl-dev \
    libgtk-3-dev \
    libayatana-appindicator3-dev \
    librsvg2-dev
rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android
# Standalone install
sudo apt install -y default-jdk
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O cmdline-tools.zip
unzip cmdline-tools.zip
mkdir -p ~/.android/cmdline-tools/latest
mv cmdline-tools/* ~/.android/cmdline-tools/latest
rm -d cmdline-tools
rm cmdline-tools.zip
export ANDROID_HOME="$HOME/.android"
export NDK_HOME="$ANDROID_HOME/ndk/25.0.8775105"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin/"
yes | sdkmanager --licenses
sdkmanager "platforms;android-33" "platform-tools" "ndk;25.0.8775105" "build-tools;33.0.0"