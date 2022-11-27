from . import app
from flask import request
from project.operations import commit, rollback, flush, add_and_commit, add_no_commit, delete_tuple, update_tuple, get_all, get_user
from uuid import uuid4


@app.route('/')
def home():
    return {}


@app.route('/signup', methods=['POST'])
def signup():
    email = request.form.get('email')
    password = request.form.get('password')
    username = request.form.get('username')
    name = request.form.get('name')
    lastname = request.form.get('lastname')
    birth_date = request.form.get('birth_date')
    address = request.form.get('address')
    family = request.form.get('family')
    house_type = request.form.get('house_type')
    id_neighborhoods = request.form.get('id_neighborhoods')

    reason = ''
    if get_user(email) is not None:
        status = 'failure'
        reason = 'user already exists'
    else:
        status = 'success'
        add_and_commit('users', email=email, password=password, username=username, name=name, lastname=lastname,
                       birth_date=birth_date, address=address, family=family, house_type=house_type, token='', id_neighborhoods=id_neighborhoods)

    return {'status': status, 'reason': reason}


@app.route('/login', methods=['POST'])
def login():
    email = request.form.get('email')
    password = request.form.get('password')
    rand_token = ''

    user = get_user(email)
    control = (email != "" and password != "" and user is not None and user.password_check(psw=password))
    status = 'success' if control else 'failure'
    reason = '' if control else 'email or password are wrong'

    if control:
        rand_token = str(uuid4())
        update_tuple('users', email, token=rand_token)

    if control and get_user(email).token != rand_token:
        status = 'failure'
        reason = 'update does not work'

    return {'token': rand_token, 'status': status, 'reason': reason}


@app.route('/neighborhoods', methods=['GET'])
def get_neighborhoods():
    status = 'success'
    neighs = get_all('neighborhoods')
    ans = ''
    if neighs is not None:
        for n in neighs:
            ans = ans + n.name + ';'
    return {'neighborhoods': ans, 'status': status}
