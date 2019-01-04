FROM homdx/kivymd-store:004

COPY . app

RUN sudo chown -Rv user ${WORK_DIR}/app
#USER ${USER}

RUN date && cd /home/user/.buildozer/android/platform && cd wget --quiet https://dl.google.com/android/repository/android-ndk-r17c-linux-x86_64.zip && unzip android-ndk-r17c-linux-x86_64.zip && rm android-ndk-r17c-linux-x86_64.zip && date

RUN pip3 install buildozer==0.37 Cython==0.28.6 --upgrade && pip2 list && pip3 list \
 && cd app && cp -vf buildozer-python2.spec buildozer.spec \
 && patch -p0 <main-without-cred.patch  && time buildozer android debug && mkdir ~/result \
 && cp /home/user/hostcwd/app/.buildozer/android/platform/build/dists/funcrash/build/outputs/apk/debug/*.apk ~/result

CMD tail -f /var/log/faillog

#ENTRYPOINT ["buildozer"]
