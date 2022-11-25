def test_login(client):
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
    assert response.json["status"] == "success"

def test_login_empty_field(client):
    email = ""
    password = ""
    response = client.post("/login", data={
            "email": email,
            "password": password,
            })
    assert response.status_code == 200
    #print(response.json)
    
    assert response.json["email"] == email
    assert response.json["password"] == password
    assert response.json["status"] == "failure"
    
def test_login_incorrect_psw(client):
    email = "email1@email.com"
    password = "ciao"
    response = client.post("/login", data={
            "email": email,
            "password": password,
            })
    assert response.status_code == 200
    #print(response.json)
    
    assert response.json["email"] == email
    assert response.json["password"] == password
    assert response.json["status"] == "failure"
