from . import app
from flask import request


@app.route('/')
def home():
    return {}


@app.route('/signup', methods=['GET', 'POST'])
def signup():
    status = 'ok'
    return {'status': f'{status}'}


@app.route('/login', methods=['GET', 'POST'])
def login():
    email = request.args['email']
    password = request.args['password']
    # login operation
    status = 'ok'
    return {'status': f'{status}'}


@app.route('/neighborhoods')
def get_neighborhoods():
    status = 'ok'
    return {'neighborhoods': 'neigh1;neigh2;neigh3', 'status': f'{status}'}
