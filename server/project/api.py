from . import app
from flask import request
from project.operations import commit, rollback, flush, add_and_commit, add_no_commit, delete_tuple, update_tuple, get_all, get_table, get_user_by_token
from uuid import uuid4
from sqlalchemy.exc import SQLAlchemyError


@app.errorhandler(Exception)
def handle_error(e):
    rollback()
    return {'status': 'failure', 'reason': str(e)}


@app.errorhandler(SQLAlchemyError)
def handle_error(e):
    rollback()
    return {'status': 'failure', 'reason': str(e)}


@app.route('/')
def home():
    return 'Hello, from Neighborhood'


'''
Method: POST
Route: '/signup'
Desc: signup the new user with the data specified in the post request

Need: {'email': email,
        'password': string,
        'username': string,
        'name': string,
        'lastname': string,
        'birth_date': date,
        'address': string,
        'family': int,
        'house_type': string,
        'id_neighborhoods': int}

Return success: {'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/signup', methods=['POST'])
def signup():
    if get_table('users', request.json['email']):
        return {'status': 'failure', 'reason': 'user already exists'}

    add_and_commit('users', token='', **request.json)

    return {'status': 'success'}


'''
Method: POST
Route: '/login'
Desc: login the user with the data specified in the post request, return the session token of the user

Need: {'email': string, 'password': string}

Return success: {'token': string, 'status': 'success'}
Return failure: {'status': 'failure', 'reason': string} 
'''
@app.route('/login', methods=['POST'])
def login():
    email = request.json.get('email')
    password = request.json.get('password')
    user = get_table('users', email)

    if user is None:
        return {'status': 'failure', 'reason': 'user does not exist'}

    if password == "" or not user.password_check(psw=password):
        return {'status': 'failure', 'reason': 'password is not correct'}

    rand_token = str(uuid4())
    while get_user_by_token(rand_token):
        rand_token = str(uuid4())
    user.token = rand_token
    commit()

    return {'token': rand_token, 'status': 'success'}


'''
Method: POST
Route: '/logout'
Desc: logout the user with the email specified in the post request

Need: {'email': email}

Return success: {'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/logout', methods=['POST'])
def logout():
    email = request.json.get('email')
    user = get_table('users', email)

    if not user:
        return {'status': 'failure', 'reason': 'user does not exist'}

    user.token = ''
    commit()

    return {'status': 'success'}


'''
Method: DELETE
Route: '/delete-account'
Desc: delete the user specified

Need: {'token': string}

Return success: {'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/delete-account', methods=['DELETE'])
def delete_account():
    user = get_user_by_token(request.json.get('token'))

    if not user:
        return {'status': 'failure', 'reason': 'user does not exist'}

    email = user.email
    delete_tuple('users', email)
    if get_table('users', email):
        return {'status': 'failure', 'reason': 'delete does not work'}

    return {'status': 'success'}


'''
Method: POST
Route: '/token'
Desc: compare the token passed and the token in the db for the user specified

Need: {'token': string, 'email': string}

Return success: {'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/token', methods=['POST'])
def compare_token():
    email = request.json.get('email')
    token = request.json.get('token')

    user = get_table('users', email)
    if not user:
        return {'status': 'failure', 'reason': 'user does not exist'}

    if token != user.token:
        return {'status': 'failure', 'reason': 'token is not valid'}

    return {'status': 'success'}


'''
Method: GET
Route: '/neighborhoods'
Desc: return a list of dictionary that represent all the neighborhoods present in the app

Return success: {'neighborhoods': [dict], 'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/neighborhoods', methods=['GET'])
def get_neighborhoods():
    neighs = get_all('neighborhoods')
    ans = []
    if neighs is not None:
        for n in neighs:
            ans.append(n.get_all_elements())
    return {'neighborhoods': ans, 'status': 'success'}


'''
Method: POST to retrieve user data (only one field in the body)
Route: '/profile'
Desc: get the injsonation of the user with the token specified

Need: {'token': string}

Return success: {
                'email': string,
                'username': string,
                'name': string,
                'lastname': string,
                'birth_date': date,
                'address': string,
                'family': int,
                'house_type': string,
                'neighborhood': string,
                'id_neighborhoods': int,
                'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}


Method: POST to update user data (more than one field in the body)
Route: '/profile'
Desc: update the specified fields in the profile of the user with the token specified

You can choose how many arguments want to change
Need: { 
        'token': string,
        'email': string,
        'username': string,
        'name': string,
        'lastname': string,
        'birth_date': date,
        'address': string,
        'family': int,
        'house_type': string,
        'id_neighborhoods': int}
        
Return success: Return success: {
                'email': string,
                'username': string,
                'name': string,
                'lastname': string,
                'birth_date': date,
                'address': string,
                'family': int,
                'house_type': string,
                'neighborhood': string,
                'id_neighborhoods': int,
                'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/profile', methods=['POST'])
def profile():
    user = get_user_by_token(request.json.get('token'))

    if not user:
        return {'status': 'failure', 'reason': 'user does not exist'}

    if len(request.json) > 1:
        update_tuple('users', user.email, **request.json)

    elems = user.get_all_elements()
    elems['id_neighborhoods'] = user.id_neighborhoods
    elems['status'] = 'success'
    return elems


# aux function to check if elem and email are correct
def check(elem, token=None):
    if elem != 'reports' and elem != 'services' and elem != 'needs':
        return {'status': 'failure', 'reason': 'the list must be reports, services or needs'}

    if token is not None and get_user_by_token(token) is None:
        return {'status': 'failure', 'reason': 'the user does not exist'}

    return None


'''
Method: POST
Route: '/list/<elem>'
Desc: get a list of <elem> (services, needs, reports) for the user with the token specified

Need: {'token': string}

Return success: {'list': [dict], 'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/list/<elem>', methods=['POST'])
def get_list(elem):
    token = request.json.get('token')

    if check(elem, token):
        return check(elem, token)

    return {'list': [x.get_all_elements() for x in get_all(table=elem, not_creator=get_user_by_token(token).email)],
            'status': 'success'}


'''
Method: POST to retrieve elem data (only one field in the body)
Route: '/mylist/<elem>'
Desc: get the list of <elem> (services, needs, reports) for user specified

Need: {'token': string}

Return success: {'list': [dict], 'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}


Method: POST to update elem data (more than one field in the body)
Route: '/mylist/<elem>'
Desc: update the specified fields in the list of type <elem> (services, needs, reports) for user specified

You can choose how many arguments want to change
Need: { 'token': string,
        'id': int (not nullable),
        'title': string,
        ...}

Return success: {'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/mylist/<elem>', methods=['POST'])
def get_mylist(elem):
    token = request.json.get('token')

    if check(elem, token):
        return check(elem, token)

    if len(request.json) == 1:
        return {'list': [x.get_all_elements() for x in get_all(table=elem, creator=get_user_by_token(token).email)],
                'status': 'success'}

    update_tuple(elem, request.json.get('id'), **request.json)
    elems = get_table(elem, request.json.get('id')).get_all_elements()
    elems['status'] = 'success'
    return elems


'''
Method: POST
Route: '/assist-list'
Desc: get the list of needs the user specified have to assist

Need: {'token': string}

Return success: {'list': [dict], 'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/assist-list', methods=['POST'])
def get_assist_list():
    user = get_user_by_token(request.json.get('token'))

    if not user:
        return {'status': 'failure', 'reason': 'the user does not exist'}

    return {'list': [x.get_all_elements() for x in get_all(assistant=user.email)],
            'status': 'success'}


'''
Method: POST
Route: '/new/<elem>'
Desc: create a new element of type <elem> (services, needs, reports), return the id of the new element

Need (one of these types):
- services: {
        'token': string,
        'title': string,
        'desc': string,
        'link': string} 
         
- needs: {
        'token': string,
        'title': string,
        'desc' : string,
        'address' : string}
        
- reports: {
        'token': string,
        'title': string,
        'priority' : int (1 or 2 or 3),
        'address' : string,
        'category' : string}


Return success: {'id': int, 'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/new/<elem>', methods=['POST'])
def new_elem(elem):
    token = request.json.get('token')

    if check(elem, token):
        return check(elem, token)

    data = {'id_creator': get_user_by_token(token).email}
    for k, v in request.json.items():
        if k != 'token':
            data[k] = v
    id = add_and_commit(elem, **data).id
    return {'id': id, 'status': 'success'}


'''
Method: DELETE
Route: '/delete/<elem>'
Desc: delete element of type <elem> (services, needs, reports) with the id passed 

Need: {'token': string, 'id': int}

Return success: {'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/delete/<elem>', methods=['DELETE'])
def delete_elem(elem):
    id = request.json.get('id')
    token = request.json.get('token')

    if check(elem, token):
        return check(elem, token)

    if not get_table(elem, id):
        return {'status': 'failure', 'reason': 'id does not exist'}

    if get_table(elem, id).id_creator != get_user_by_token(token).email:
        return {'status': 'failure', 'reason': 'the user is not the creator of the element'}

    delete_tuple(elem, id)
    if get_table(elem, id):
        return {'status': 'failure', 'reason': 'delete does not work'}

    return {'status': 'success'}


'''
Method: POST
Route: '/assist'
Desc: the user specified can solve the need with id passed

Need: {'token': string, 'id': string}

Return success: {'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/assist', methods=['POST', 'DELETE'])
def assist():
    token = request.json.get('token')
    id = request.json.get('id')

    if not get_table('needs', id):
        return {'status': 'failure', 'reason': 'the id is not correct'}

    user = get_user_by_token(token)
    if not user:
        return {'status': 'failure', 'reason': 'the user does not exist'}

    if request.method == 'POST':
        if get_table('needs', id).id_creator == user.email:
            return {'status': 'failure', 'reason': 'creator and assistant must be different'}
        get_table('needs', id).id_assistant = user.email
    else:
        if get_table('needs', id).id_assistant != user.email:
            return {'status': 'failure', 'reason': 'user is not the assistant for this need'}
        get_table('needs', id).id_assistant = None

    return {'status': 'success'}
