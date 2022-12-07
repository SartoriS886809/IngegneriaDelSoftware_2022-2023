from . import app
from flask import request
from project.operations import commit, rollback, flush, add_and_commit, add_no_commit, delete_tuple, update_tuple, get_all, get_table, get_user_by_token
from uuid import uuid4


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
    if get_table('users', request.form.get('email')):
        return {'status': 'failure', 'reason': 'user already exists'}

    add_and_commit('users', token='', **request.form)

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
    email = request.form.get('email')
    password = request.form.get('password')
    user = get_table('users', email)

    if user is None:
        return {'status': 'failure', 'reason': 'user does not exist'}

    if password == "" or not user.password_check(psw=password):
        return {'status': 'failure', 'reason': 'password is not correct'}

    rand_token = str(uuid4())
    user.token = rand_token

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
    email = request.form.get('email')
    user = get_table('users', email)

    if not user:
        return {'status': 'failure', 'reason': 'user does not exist'}

    user.token = ''

    return {'status': 'success'}


'''
Method: DELETE
Route: '/delete-account/<email>'
Desc: delete the user with <email> 

Return success: {'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/delete-account/<email>', methods=['DELETE'])
def delete_account(email):
    if not get_table('users', email):
        return {'status': 'failure', 'reason': 'user does not exist'}

    delete_tuple('users', email)
    if get_table('users', email):
        return {'status': 'failure', 'reason': 'delete does not work'}

    return {'status': 'success'}


'''
Method: POST
Route: '/token'
Desc: compare the token passed and the token in the db for the user specified

Return success: {'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/token', methods=['POST'])
def compare_token():
    email = request.form.get('email')
    token = request.form.get('token')

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
Desc: get the information of the user with the token specified

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
                'id_neighborhoods': int,
                'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/profile', methods=['POST'])
def profile():
    user = get_user_by_token(request.form.get('token'))

    if not user:
        return {'status': 'failure', 'reason': 'user does not exist'}

    if len(request.form) > 1:
        update_tuple('users', user.email, **request.form)

    elems = user.get_all_elements()
    elems['status'] = 'success'
    return elems


# aux function to check if elem and email are correct
def check(elem, email=None):
    if elem != 'reports' and elem != 'services' and elem != 'needs':
        return {'status': 'failure', 'reason': 'the list must be reports, services or needs'}

    if email is not None and get_table('users', email) is None:
        return {'status': 'failure', 'reason': 'the email does not exist'}

    return None


'''
Method: GET
Route: '/list/<elem>/<email>'
Desc: get a list of <elem> (services, needs, reports) for the user with <email>

Return success: {'list': [dict], 'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/list/<elem>/<email>', methods=['GET'])
def get_list(elem, email):
    if check(elem, email):
        return check(elem, email)

    return {'list': [get_table(elem, x.id).get_all_elements() for x in get_all(table=elem, not_creator=email)],
            'status': 'success'}


'''
Method: GET
Route: '/mylist/<elem>/<email>'
Desc: get the list of <elem> (services, needs, reports) for the current user with <email>

Return success: {'list': [dict], 'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}


Method: POST
Route: '/mylist/<elem>/<email>'
Desc: update the specified fields in the list of type <elem> (services, needs, reports) for the current user with <email>

You can choose how many arguments want to change
Need: {'id': int (not nullable),
        'title': string,
        ...}

Return success: {'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/mylist/<elem>/<email>', methods=['GET', 'POST'])
def get_mylist(elem, email):
    if check(elem, email):
        return check(elem, email)

    if request.method == 'GET':
        return {'list': [get_table(elem, x.id).get_all_elements() for x in get_all(table=elem, creator=email)],
                'status': 'success'}

    update_tuple(elem, request.form.get('id'), **request.form)
    elems = get_table(elem, request.form.get('id')).get_all_elements()
    elems['status'] = 'success'
    return elems


'''
Method: POST
Route: '/new/<elem>'
Desc: create a new element of type <elem> (services, needs, reports), return the id of the new element

Need (one of these types):
- services: {'title': string, 
        'id_creator': string, 
        'desc': string,
        'link': string} 
         
- needs: {'title': string, 
        'id_creator': string, 
        'desc' : string,
        'address' : string}
        
- reports: {'title': string, 
        'id_creator': string, 
        'priority' : int (1 or 2 or 3),
        'address' : string,
        'category' : string}


Return success: {'id': int, 'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/new/<elem>', methods=['POST'])
def new_elem(elem):
    if check(elem, request.form.get('id_creator')):
        return check(elem, request.form.get('id_creator'))

    id = add_and_commit(elem, **request.form).id
    return {'id': id, 'status': 'success'}


'''
Method: DELETE
Route: '/delete/<elem>/<id>'
Desc: delete element of type <elem> (services, needs, reports) with <id> 

Return success: {'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/delete/<elem>/<id>', methods=['DELETE'])
def delete_elem(elem, id):
    if check(elem):
        return check(elem)

    delete_tuple(elem, id)
    if get_table(elem, id):
        return {'status': 'failure', 'reason': 'delete does not work'}

    return {'status': 'success'}


'''
Method: POST
Route: '/assist'
Desc: the user with <email> can solve the need with <id>

Need: {'id': string, 'email': string}

Return success: {'status': 'success'}
Return failure: {'status': 'failure', 'reason': string}
'''
@app.route('/assist', methods=['POST'])
def assist():
    if not get_table('needs', request.form.get('id')):
        return {'status': 'failure', 'reason': 'the id is not correct'}

    if not get_table('users', request.form.get('email')):
        return {'status': 'failure', 'reason': 'the user does not exist'}

    if get_table('needs', request.form.get('id')).id_creator == request.form.get('email'):
        return {'status': 'failure', 'reason': 'creator and assistant must be different'}

    get_table('needs', request.form.get('id')).id_assistant = request.form.get('email')
    return {'status': 'success'}
