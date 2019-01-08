FROM homdx/pydelhi_mobile:api27

#USER ${USER}

ENV SDK_TOOLS="sdk-tools-linux-4333796.zip"
ENV NDK_DL="https://dl.google.com/android/repository/android-ndk-r17c-linux-x86_64.zip"
ENV NDKVER=r17c
ENV NDKDIR=/home/user/.buildozer/
ENV NDKAPI=21
ENV ANDROIDAPI=28
ENV PIP=pip3

RUN rm -rf /home/user/.buildozer/android/platform/android-sdk-24/ \
   && cd ${NDKDIR} && wget https://dl.google.com/android/repository/${SDK_TOOLS}
RUN cd ${NDKDIR} && unzip ./sdk-tools-*.zip && chmod +x ./tools//bin/sdkmanager
RUN yes | ${NDKDIR}/tools/bin/sdkmanager --licenses
RUN ${NDKDIR}/tools/bin/sdkmanager --update
RUN ${NDKDIR}/tools/bin/sdkmanager "platform-tools" "platforms;android-28" "build-tools;28.0.3"

# Obtain Android NDK:
RUN ls -la /home/user/.buildozer/android/platform/ && mkdir -p /tmp/ndk/ && cd /tmp/ndk/ && wget ${NDK_DL} && unzip -q android-ndk*.zip && sudo mv android-*/ /ndk/ && ls -la /home/user/.buildozer/android/platform/

COPY . app2

RUN sudo chown -Rv user ${WORK_DIR}/app2

RUN sudo apt install -qq --yes zip python3-virtualenv python3-pip \
    && pip2 uninstall cython buildozer --yes && pip3 install buildozer==0.37 cython==0.28.6 sh --user

RUN echo rm -rf /home/user/.buildozer/android/platform/android-sdk-24 && sudo apt-get install python3.7 --yes && sudo git clone https://github.com/kivy/python-for-android.git && sudo chown user -R python-for-android && sudo wget https://github.com/homdx/pydelhi_mobile/releases/download/0.1.1/patch-so-python37.patch && patch -p0 <patch-so-python37.patch \
 && cd app2 && cp -vf buildozer-python3.spec buildozer.spec \
 && patch -p0 <main-without-cred.patch  && time buildozer android debug || echo done

RUN cd app2 && cp -vf buildozer-python31.spec buildozer.spec \
 && time buildozer android debug || echo done2

CMD tail -f /var/log/faillog

#ENTRYPOINT ["buildozer"]
