#!/bin/bash
sudo apt-get update
sudo apt-get install tmux -y
npm i -g pnpm
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
node -e "p=require('path');f=require('fs');let l=p.resolve('/home/codespace/.vscode-remote/data/Machine/settings.json'); \
        let c=JSON.parse(f.readFileSync(l).toString());c['workbench.colorTheme']='Default Dark+'; \
        fs.writeFileSync(l, JSON.stringify(c, null, 2))"
# https://next--tauri.netlify.app/next/guides/getting-started/prerequisites/linux
sudo apt install libwebkit2gtk-4.0-dev \
    build-essential \
    libssl-dev \
    libgtk-3-dev \
    libayatana-appindicator3-dev \
    librsvg2-dev
rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android x86_64-linux-android
# Standalone install
sudo apt install default-jdk
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O cmdline-tools.zip
unzip cmdline-tools.zip
mkdir ~/.android/cmdline-tools/latest
mv cmdline-tools/* ~/.android/cmdline-tools/latest
rm cmdline-tools
export ANDROID_HOME="$HOME/.android"
export NDK_HOME="$ANDROID_HOME/ndk/25.0.8775105"
~/.android/cmdline-tools/latest/bin/sdkmanager "platforms;android-33" "platform-tools" "ndk;25.0.8775105" "build-tools;33.0.0"