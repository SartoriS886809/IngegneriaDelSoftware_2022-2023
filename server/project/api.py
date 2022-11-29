from . import app
from flask import request
from project.operations import commit, rollback, flush, add_and_commit, add_no_commit, delete_tuple, update_tuple, get_all, get_table
from uuid import uuid4


@app.route('/')
def home():
    return {}


@app.route('/signup', methods=['POST'])
def signup():
    if get_table('users', request.form.get('email')):
        return {'status': 'failure', 'reason': 'user already exists'}

    add_and_commit('users', token='', **request.form)

    return {'status': 'success', 'reason': ''}


@app.route('/login', methods=['POST'])
def login():
    email = request.form.get('email')
    password = request.form.get('password')
    rand_token = ''

    user = get_table('users', email)
    control = (email != "" and password != "" and user is not None and user.password_check(psw=password))
    status = 'success' if control else 'failure'
    reason = '' if control else 'email or password are wrong'

    if control:
        rand_token = str(uuid4())
        user.token = rand_token

    if control and get_table('users', email).token != rand_token:
        status = 'failure'
        reason = 'update does not work'

    return {'token': rand_token, 'status': status, 'reason': reason}


@app.route('/logout', methods=['POST'])
def logout():
    email = request.form.get('email')
    user = get_table('users', email)

    if not user:
        return {'status': 'failure', 'reason': 'user does not exist'}

    user.token = ''

    return {'status': 'success', 'reason': ''}


@app.route('/neighborhoods', methods=['GET'])
def get_neighborhoods():
    neighs = get_all('neighborhoods')
    ans = ''
    if neighs is not None:
        for n in neighs:
            ans = ans + n.name + ';'
    return {'neighborhoods': ans, 'status': 'success'}


@app.route('/profile/<email>', methods=['GET', 'POST'])
def profile(email):
    user = get_table('users', email)

    if not user:
        return {'status': 'failure', 'reason': 'user does not exist'}

    if request.method == 'POST':
        update_tuple('users', user.email, **request.form)

    elems = user.get_all_elements()
    elems['status'] = 'success'
    elems['reason'] = ''
    return elems


def check(elem, email=None):
    if elem != 'reports' and elem != 'services' and elem != 'needs':
        return {'status': 'failure', 'reason': 'the list must be reports, services or needs'}

    if email is not None and get_table('users', email) is None:
        return {'status': 'failure', 'reason': 'the email does not exist'}

    return None


@app.route('/list/<elem>/<email>', methods=['GET'])
def get_list(elem, email):
    if check(elem, email):
        return check(elem, email)

    return {'list': [get_table(elem, x.id).get_all_elements() for x in get_all(table=elem, not_creator=email)],
            'status': 'success', 'reason': ''}


@app.route('/mylist/<elem>/<email>', methods=['GET', 'POST'])
def get_mylist(elem, email):
    if check(elem, email):
        return check(elem, email)

    if request.method == 'GET':
        return {'list': [get_table(elem, x.id).get_all_elements() for x in get_all(table=elem, creator=email)],
                'status': 'success', 'reason': ''}

    update_tuple(elem, request.form.get('id'), **request.form)
    elems = get_table(elem, request.form.get('id')).get_all_elements()
    elems['status'] = 'success'
    elems['reason'] = ''
    return elems


@app.route('/new/<elem>', methods=['POST'])
def new_elem(elem):
    if check(elem, request.form.get('id_creator')):
        return check(elem, request.form.get('id_creator'))

    id = add_and_commit(elem, **request.form).id
    return {'id' : id, 'status': 'success', 'reason': ''}


@app.route('/delete/<elem>/<id>', methods=['DELETE'])
def delete_elem(elem, id):
    if check(elem):
        return check(elem)

    delete_tuple(elem, id)
    if get_table(elem, id):
        return {'status': 'failure', 'reason': 'delete does not work'}

    return {'status': 'success', 'reason': ''}


@app.route('/assist', methods=['POST'])
def assist():
    if request.form.get('id') == request.form.get('email'):
        return {'status': 'failure', 'reason': 'creator and assistant must be different'}

    get_table('needs', request.form.get('id')).id_assistant = request.form.get('email')
    return {'status': 'success', 'reason': ''}
