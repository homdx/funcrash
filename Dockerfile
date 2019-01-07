FROM homdx/pydelhi_mobile:api27

#USER ${USER}

COPY . app2

RUN sudo chown -Rv user ${WORK_DIR}/app2

RUN sudo apt-get install python-3.7 --yes && git clone https://github.com/kivy/python-for-android.git && wget https://github.com/homdx/pydelhi_mobile/releases/download/0.1.1/patch-so-python37.patch && patch -p0 <patch-so-python37.patch \
 && cd app && cp -vf buildozer-python3.spec buildozer.spec \
 && patch -p0 <main-without-cred.patch  && time buildozer android debug || echo done

CMD tail -f /var/log/faillog

#ENTRYPOINT ["buildozer"]
