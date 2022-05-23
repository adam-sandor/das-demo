import os
import sys
import time
import logging
import uuid
import json
import requests
from flask import abort
from flask import Flask
from flask import Response
from flask import request
from flask import jsonify

app = Flask(__name__)
app.logger.setLevel(logging.INFO)


@app.errorhandler(Exception)
def exception_handler(err):
    app.logger.error(str(err))
    return str(err), 500

@app.route('/health', methods=['GET'])
def health():
    return 'OK'

@app.route('/accountholder/<id>', methods=['GET'])
def accountholder(id):
    app.logger.info('/accountholder/{}'.format(id))
    # TODO: generalize to bigger data set
    if id == '1':
        accountholderData = {
            'id': '1',
            'name': 'Mr. Anderson',
            'address': 'Borgerstraat, Amsterdam',
            'geo': 'EU',
        }
        return jsonify(accountholderData)
    else:
        abort(404, 'No accountholder record of ID: {}.'.format(id))



if __name__ == "__main__":
    sh = logging.StreamHandler(sys.stdout)
    sh.setLevel(logging.INFO)
    fmt = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    port = "8080"
    app.logger.info('Starting on port {}'.format(port))
    app.run(host='0.0.0.0', port=port)
