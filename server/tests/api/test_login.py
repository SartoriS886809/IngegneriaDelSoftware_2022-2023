import pytest

email = "mario@gmail.com"
token = None

@pytest.mark.order(2)
def test_normal_login(client):
    password = "ciaociao123"
    response = client.post("/login", data={
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
    response = client.post("/login", data={
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
    response = client.post("/login", data={
            "email": email,
            "password": password,
            })
    assert response.status_code == 200
    #print(response.json)

    assert response.json["status"] == "failure"
    assert response.json["reason"] == "user does not exist"

@pytest.mark.order(2)
def test_compare_token(client):
    response = client.post("/token", data={
        "email": email,
        "token": token,
    })

    assert response.status_code == 200
    assert response.json["status"] == "success"


@pytest.mark.order(2)
def test_compare_token_wrong(client):
    response = client.post("/token", data={
        "email": email,
        "token": "wrong_token",
    })

    assert response.status_code == 200
    assert response.json["status"] == "failure"
    assert response.json["reason"] == "token is not valid"