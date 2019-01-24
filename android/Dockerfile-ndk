FROM marmotcai/android-sdk AS android-ndk

ENV WORK_DIR /opt

WORKDIR $WORK_DIR

# Install Android NDK.
ENV	ANDROID_NDK_URL="https://dl.google.com/android/repository/android-ndk-r16b-linux-x86_64.zip" \
	ANDROID_NDK_HOME="$ANDROID_HOME/android-ndk-r16b" \
	ANDROID_TOOLCHAIN_HOME="$ANDROID_HOME/toolchain_android/aarch64"

# Installs Android NDK
RUN wget -O ndk.zip ${ANDROID_NDK_URL} && \
	unzip ndk.zip -d $ANDROID_HOME && rm -f ndk.zip

# RUN echo y | android update sdk --no-ui --all --filter build-tools-24.0.3 && \
#     echo y | android update sdk --no-ui --all --filter android-24

RUN mkdir -p $ANDROID_TOOLCHAIN_HOME
RUN $ANDROID_NDK_HOME/build/tools/make-standalone-toolchain.sh --platform=android-24 --install-dir=$ANDROID_TOOLCHAIN_HOME --arch=arm64 --force

# Update PATH for the above.
ENV PATH $PATH:$ANDROID_TOOLCHAIN_HOME/bin