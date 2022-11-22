def test_login_page(client):
    email = "ciccio@gmail.com"
    password = "ciaociao123"
    response = client.post("/login", data={
            "email": email,
            "password": password,
            })
    assert response.status_code == 200
    #print(response.json)
    
    assert response.json["email"] == email
    assert response.json["password"] == password

def test_login_2(client):
    assert 1 == 1
