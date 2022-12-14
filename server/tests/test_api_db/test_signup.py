import pytest

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
def test_signup(post_request):
    response = post_request('/signup', json)
    assert response["status"] == "success"

def test_signup_failure(post_request):
    response = post_request('/signup', json)
    assert response["status"] == "failure"
    assert response["reason"] == "user already exists"