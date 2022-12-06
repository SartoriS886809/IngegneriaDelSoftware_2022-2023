import pytest

@pytest.mark.order(2)
def test_normal_login(client):
    email = "mario@gmail.com"
    password = "ciaociao123"
    response = client.post("/login", data={
            "email": email,
            "password": password,
            })
    assert response.status_code == 200
    #print(response.json)

    assert response.json["token"] != ""
    assert response.json["status"] == "success"

@pytest.mark.order(2)
def test_wrong_password(client):
    email = "mario@gmail.com"
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
def test_get_token(client):
    email = "mario@gmail.com"
    response = client.get("/token/" + email)

    assert response.status_code == 200
    assert response.json["status"] == "success"
    assert response.json["token"] != ""