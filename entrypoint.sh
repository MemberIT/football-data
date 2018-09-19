#!/bin/sh

cd $CHDIR
gunicorn --config=/etc/gunicorn/config.py app:app
