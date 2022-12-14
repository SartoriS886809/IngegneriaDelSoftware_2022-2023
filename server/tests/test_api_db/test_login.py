import pytest
import requests as rq

email = "mario@gmail.com"
password = "ciaociao123"
token = None

@pytest.mark.order(2)
def test_normal_login(base_url):
    send = {
        "email": email,
        "password": password
    }
    rq.post(base_url+'/login', json=)


    password = "ciaociao123"
    response = client.post("/login", json={
            "email": email,
            "password": password,
            })
    assert response.status_code == 200
    #print(response.json)

    assert response.json["token"] != ""
    assert response.json["status"] == "success"

    global token
    token = response.json["token"]

@pytest.mark.order(2)
def test_wrong_password(client):
    password = "ciao"
    response = client.post("/login", json={
            "email": email,
            "password": password,
            })
    assert response.status_code == 200
    #print(response.json)

    assert response.json["status"] == "failure"
    assert response.json["reason"] == "password is not correct"

@pytest.mark.order(2)
def test_login_incorrect_email(client):
    email = "r@gmail.com"
    password = "ciaociao123"
    response = client.post("/login", json={
            "email": email,
            "password": password,
            })
    assert response.status_code == 200
    #print(response.json)

    assert response.json["status"] == "failure"
    assert response.json["reason"] == "user does not exist"

@pytest.mark.order(2)
def test_compare_token(client):
    response = client.post("/token", json={
        "email": email,
        "token": token,
    })

    assert response.status_code == 200
    assert response.json["status"] == "success"


@pytest.mark.order(2)
def test_compare_token_wrong(client):
    response = client.post("/token", json={
        "email": email,
        "token": "wrong_token",
    })

    assert response.status_code == 200
    assert response.json["status"] == "failure"
    assert response.json["reason"] == "token is not valid"

new_token = token
