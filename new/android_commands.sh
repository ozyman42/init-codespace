apk add openjdk-17-jdk
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