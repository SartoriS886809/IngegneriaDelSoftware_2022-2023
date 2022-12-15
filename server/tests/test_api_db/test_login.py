import pytest
import requests as rq
from tests.conftest import post_request, get_request, delete_request

email = "mario@gmail.com"
token = None

@pytest.mark.order(2)
def test_normal_login():
    json = {
        "email": email,
        "password": "ciaociao123"
    }

    response = post_request('/login', json=json)
    assert response["status"] == "success"
    assert response["token"] != ""

    global token
    token = response["token"]

@pytest.mark.order(2)
def test_wrong_password():
    json = {
        "email": email,
        "password": "ciao"
    }

    response = post_request('/login', json=json)
    assert response["status"] == "failure"
    assert response["reason"] == "password is not correct"

@pytest.mark.order(2)
def test_login_incorrect_email():
    json = {
        "email": "r@gmail.com",
        "password": "ciao"
    }

    response = post_request('/login', json=json)
    assert response["status"] == "failure"
    assert response["reason"] == "user does not exist"

@pytest.mark.order(2)
def test_compare_token():
    json = {
        "email": email,
        "token": token
    }

    response = post_request('/token', json=json)
    assert response["status"] == "success"

@pytest.mark.order(2)
def test_compare_token_wrong():
    json = {
        "email": email,
        "token": "wrong_token"
    }

    response = post_request('/token', json=json)
    assert response["status"] == "failure"
    assert response["reason"] == "token is not valid"