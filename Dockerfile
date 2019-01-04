FROM homdx/kivymd-store:004

#USER ${USER}

#18b 17c to 16b
#ARG ndkfile=android-ndk-r18b-linux-x86_64.zip
#ARG ndkfile=android-ndk-r17c-linux-x86_64.zip
ARG ndkfile=android-ndk-r16b-linux-x86_64.zip

RUN date && cd /home/user/.buildozer/android/platform && time wget --quiet https://dl.google.com/android/repository/${ndkfile} && unzip ${ndkfile} >/dev/null 2>/dev/null && rm ${ndkfile} && date

COPY . app

RUN sudo chown -Rv user ${WORK_DIR}/app

RUN pip2 install sh buildozer==0.37 Cython==0.28.6 --upgrade && pip2 list && pip3 list \
 && cd app && cp -vf buildozer-python2.spec buildozer.spec \
 && patch -p0 <main-without-cred.patch  && time buildozer android debug && mkdir ~/result \
 && cp /home/user/hostcwd/app/.buildozer/android/platform/build/dists/funcrash/build/outputs/apk/debug/*.apk ~/result

CMD tail -f /var/log/faillog

#ENTRYPOINT ["buildozer"]
