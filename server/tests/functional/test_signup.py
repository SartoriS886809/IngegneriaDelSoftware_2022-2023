# TODO not tested yet, to check

def test_login_page(client):
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

    response = client.post("/signup", data={
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
    assert response.status_code == 200
    # print(response.json)

    assert response.json["token"] == ""
    assert response.json["status"] == "success"
