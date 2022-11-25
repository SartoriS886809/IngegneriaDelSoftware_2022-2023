def test_normal_login(client):
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

def test_empty_fields_login(client):
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
    
def test_incorrect_psw_login(client):
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

def test_login_incorrect_email(client):
    email = "r@gmail.com"
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
