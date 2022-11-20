from project import create_app
from flask import request, jsonify


def test_login_page():
    flask_app = create_app()
    
    with flask_app.test_client() as c:
        email = 'flask@example.com'
        rv = c.get('/login')
        print(rv)
        json_data = rv.get_json()
        assert email == json_data['token']
