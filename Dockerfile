FROM python:3.6-alpine3.8
EXPOSE 9000/tcp
ENV WORKERS=3
ENV SECRET_KEY=2174fc83ec034e49ac3d25f7fb666864
ENV CHDIR=/opt/project
ADD config.py_tail /tmp/config.py_tail
ADD entrypoint.sh /entrypoint.sh
RUN set -ex; \
      mkdir /etc/gunicorn; \
      echo "workers = ${WORKERS}" > /etc/gunicorn/config.py; \
      echo "raw_env = [" >> /etc/gunicorn/config.py; \
      echo "    'SECRET_KEY=${SECRET_KEY}'" >> /etc/gunicorn/config.py; \
      echo "]" >> /etc/gunicorn/config.py; \
      cat /tmp/config.py_tail >> /etc/gunicorn/config.py; \
      rm -f /tmp/config.py_tail
RUN set -ex; \
      addgroup -g 1000 epl_www; \
      adduser -D -u 1000 -G epl_www -s /bin/false -h $CHDIR epl_www
COPY --chown=1000:1000 . $CHDIR/
RUN rm -rf $CHDIR/.git
RUN set -ex; \
      pip install -r $CHDIR/requirements.txt; \
      pip install gunicorn
USER 1000
WORKDIR $CHDIR
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
