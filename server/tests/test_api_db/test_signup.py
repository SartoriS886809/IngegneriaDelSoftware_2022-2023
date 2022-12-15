import pytest
from tests.conftest import post_request, get_request, delete_request

json = {
        "email": "mario@gmail.com",
        "password": "ciaociao123",
        "username": "username",
        "name": "name",
        "lastname": "lastname",
        "birth_date": "01/01/2000",
        "address": "address",
        "family": 4,
        "house_type": "house type",
        "id_neighborhoods": 1
}

@pytest.mark.order(1)
def test_signup():
    response = post_request('/signup', json=json)
    assert response["status"] == "success"

def test_signup_failure():
    response = post_request('/signup', json=json)
    assert response["status"] == "failure"
    assert response["reason"] == "user already exists"