import pytest

def post_request(client):
    email = "mario@gmail.com"
    password = "ciaociao123"
    username = "username"
    name = "name"
    lastname = "lastname"
    birth_date = "01/01/2000"
    address = "address"
    family = 4
    house_type = "house type"
    id_neighborhoods = 1

    return client.post("/signup", data={
        "email": email,
        "password": password,
        "username": username,
        "name": name,
        "lastname": lastname,
        "birth_date": birth_date,
        "address": address,
        "family": family,
        "house_type": house_type,
        "id_neighborhoods": id_neighborhoods
    })

@pytest.mark.order(1)
def test_signup(client):
    response = post_request(client)

    assert response.status_code == 200
    # print(response.json)

    assert response.json["status"] == "success"

def test_signup_failure(client):
    response = post_request(client)

    assert response.status_code == 200
    # print(response.json)

    assert response.json["status"] == "failure"
    assert response.json["reason"] == "user already exists"