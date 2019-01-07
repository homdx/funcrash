FROM homdx/pydelhi_mobile:api27

#USER ${USER}

COPY . app2

RUN sudo chown -Rv user ${WORK_DIR}/app2

RUN pip2 uninstall cython buildozer --yes && pip3 install buildozer==0.37 cython==0.28.6 sh --user

RUN echo rm -rf /home/user/.buildozer/android/platform/android-sdk-24 && sudo apt-get install python3.7 --yes && sudo git clone https://github.com/kivy/python-for-android.git && sudo chown user -R python-for-android && sudo wget https://github.com/homdx/pydelhi_mobile/releases/download/0.1.1/patch-so-python37.patch && patch -p0 <patch-so-python37.patch \
 && cd app2 && cp -vf buildozer-python3.spec buildozer.spec \
 && patch -p0 <main-without-cred.patch  && time buildozer android debug || echo done

RUN cd app && cp -vf buildozer-python31.spec buildozer.spec \
 && time buildozer android debug || echo done2

CMD tail -f /var/log/faillog

#ENTRYPOINT ["buildozer"]
