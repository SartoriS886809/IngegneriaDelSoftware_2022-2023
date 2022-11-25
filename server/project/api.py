from . import app
from flask import request
from project.operations import commit, rollback, flush, add_and_commit, add_no_commit, delete_tuple, update_tuple, get_all

@app.route('/')
def home():
    return {}


@app.route('/signup', methods=['GET', 'POST'])
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

    token = ""  # TODO to generate
    status = 'success'
    add_and_commit('users', email=email, hashed_password=password, username=username, name=name, lastname=lastname,
                   birth_date=birth_date, address=address, family=family, house_type=house_type, token=token, id_neighborhoods=id_neighborhoods)
    return {'token': token, 'status': status}


@app.route('/login', methods=['GET', 'POST'])
def login():
    email = request.form.get('email')
    password = request.form.get('password')
    # login operation 
    if (email == "" or password == ""):
        status = 'failure'
    else:
        # TODO if not present in db
        # TODO if password or email aren't correct
        status = 'success'
    return {'email': email, 'password' : password, 'status': status}


@app.route('/neighborhoods')
def get_neighborhoods():
    status = 'success'
    neighs = get_all('neighborhoods')
    ans = ''
    if neighs is not None:
        for n in neighs:
            ans = ans + n.name + ';'
    return {'neighborhoods': ans, 'status': status}
