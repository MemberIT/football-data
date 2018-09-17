# -*- coding: utf-8 -*-
import json
import requests
import os

from flask import render_template
from app import app


@app.route('/')
def standings():
    SECRET_KEY = os.environ.get("SECRET_KEY")
    if not SECRET_KEY:
        raise ValueError("No secret key set for Flask application")
    id_competitions = '2021'
    api = 'https://api.football-data.org'
    uri = '/v2/competitions/' + id_competitions + '/standings'
    headers = { 'X-Auth-Token': SECRET_KEY }
    try:
        response = requests.get(api + uri, headers = headers)
        response.raise_for_status()
        content = response.json()
        table = content['standings'][0]['table']
        return render_template("succes.html", data = table)
    except requests.exceptions.Timeout:
        return render_template("timeout.html", api = api)
    except requests.exceptions.ConnectionError:
        return render_template("connection_error.html")
    except requests.exceptions.HTTPError as err:
        content = json.loads(err.response.content.decode())
        return render_template("error.html", content = content)
    except:
        print("Unexpected error:", sys.exc_info()[0])
        raise

